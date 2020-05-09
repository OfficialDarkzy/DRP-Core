const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const config = require("./config.json");

app.use(bodyParser.json());

require("./routes")(app);

app.listen(config.api.port, (req, res) => {
    console.log(`API Server Listening On Port: ${config.api.port}`)
  })

console.log("^1[DatabaseAPI Message] ^0: ^4Loaded 'index.js'^0");