const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const config = require("./config").server;

app.use(bodyParser.json());

require("./routes")(app);

app.listen(config.port, "localhost", (req, res) => {
    console.log("API Server Listening On Port: " + config.port)
});

console.log("^1[DatabaseAPI Message] ^0: ^4Loaded 'server.js'^0");
