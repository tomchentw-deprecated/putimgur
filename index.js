const Koa = require("koa");
const cors = require("@koa/cors");
const Sequelize = require("sequelize");
const fetch = require("node-fetch");
const replace = require("stream-buffer-replace");

const sequelize = new Sequelize(process.env.HEROKU_POSTGRESQL_MAROON_URL, {
  dialect: "postgres",
  dialectOptions: {
    ssl: true
  }
});

const Binding = sequelize.define("Binding", {
  clientId: { type: Sequelize.STRING, allowNull: false },
  albumId: { type: Sequelize.STRING, allowNull: false },
  albumDeleteHash: { type: Sequelize.STRING, allowNull: false },
  token: { type: Sequelize.STRING, allowNull: false, unique: true },
  userEmail: { type: Sequelize.STRING, allowNull: false }
});

const app = new Koa();

app.use(cors());
app.use(async ctx => {
  if (
    ctx.method !== "POST" ||
    !ctx.path.match(/^\/3\//) ||
    !ctx.get("Replacement").match(/^Token (\S+)/)
  ) {
    ctx.body =
      process.env.NODE_ENV === "production"
        ? "Error!"
        : await Binding.findAll();
    return;
  }
  const token = ctx.get("Replacement").match(/^Token (\S+)/)[1];
  const { albumDeleteHash } = await Binding.find({
    where: {
      token
    }
  });

  const proxy = await fetch(
    `https://api.imgur.com/3/${ctx.originalUrl.replace(/^\/3\//, "")}`,
    {
      method: ctx.method,
      headers: {
        Authorization: ctx.get("Authorization"),
        "Content-Type": ctx.get("Content-Type")
      },
      body: ctx.req.pipe(replace(token, albumDeleteHash))
    }
  );

  ctx.body = proxy.body;
});

let server;

exports.start = async () => {
  return await Promise.all([
    sequelize.authenticate().then(() => {
      console.log("Connection has been established successfully.");
    }),
    new Promise(resolve => {
      server = app.listen(process.env.PORT || 5000, resolve);
    }).then(() => {
      console.log("Koa server started.");
    })
  ]);
};

exports.stop = async () => {
  return await Promise.all([
    sequelize.close(),
    new Promise(resolve => {
      server.close(resolve);
    })
  ]);
};

if (require.main === module) {
  exports.start();
}
