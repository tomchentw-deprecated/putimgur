const fs = require("fs");
const fetch = require("node-fetch");
const FormData = require("form-data");
const { start, stop } = require("./index");

describe("Server", () => {
  beforeAll(async () => {
    jest.setTimeout(10000);
    await start();
  });

  afterAll(async () => {
    await stop();
  });

  describe("Error", () => {
    it("should work", async () => {
      const response = await fetch("http://localhost:5000/3/123456789").then(
        r => r.json()
      );
      expect(response).toHaveLength(6);
    });
  });

  describe("Normal", () => {
    it("should replace and proxy", async () => {
      const TOKEN =
        "73aa69e0a6558c7247da39bdc4bf9f1ad2361392ea7d255c95aaaa547803b6e3"; /* id: 1 by developer@tomchentw.com */
      const form = new FormData();
      const description = `test of put at ${Date.now()}`;
      form.append("image", fs.createReadStream("./test.jpg"));
      form.append("title", "test");
      form.append("description", description);
      form.append("album", TOKEN);

      const response = await fetch("http://localhost:5000/3/image", {
        method: "POST",
        headers: {
          Authorization:
            "Client-ID 4635a09fd1260a1" /* https://imgur.com/account/settings/apps */,
          Replacement: `Token ${TOKEN}`
        },
        body: form
      }).then(r => r.json());
      expect(response).toHaveProperty("data");
      expect(response.success).toBeTruthy();
      expect(response.data.id).toBeTruthy();
      expect(response.data.title).toBe("test");
      expect(response.data.description).toBe(description);
    });
  });
});
