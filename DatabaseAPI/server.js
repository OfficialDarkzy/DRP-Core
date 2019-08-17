const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const config = require("./config").server;

app.use(bodyParser.json());

require("./routes")(app);

app.listen(config.port, (req, res) => {
    console.log("API Server Listening On Port: " + config.port)
});

console.log("[DatabaseAPI Message] : Loaded 'server.js'");