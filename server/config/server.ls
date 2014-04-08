require! <[ express express-promise cors ]>

module.exports = express!
  ..set 'showStackError' true

  ..use express.json!
  ..use express.urlencoded!

  ..use express-promise!

  ..use cors!
