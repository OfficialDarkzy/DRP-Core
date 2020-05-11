const SendQuery = require("./database");
const jwt = require("jsonwebtoken");
const config = require("./config.json");

module.exports = (app) => {

    // Authentication Request
    app.post(config.api.route + "/authentication", (req, res) => {
        if (CheckSecretKey(req.body.secret, config.api.secret)) {
            jwt.sign({ community: req.body.community }, req.body.secret, {expiresIn: '2 days'}, (error, token) => {
                res.json({status: true, message: "Key Valid", authToken: token});
            })
        } else {
            res.json({status: false, message: "Key Invalid", token: ""});
        };
    });

    // Database Request
    app.post(config.api.route + "/execute", verifyToken, async (req, res) => {
        jwt.verify(req.token, req.body.secret, async (error, authData) => {
            if (error) {
                res.json({status: false, message: error, results: ""});
            } else {
				let query = await SendQuery(req.body.query, req.body.data);
				res.json({status: query[0], message: query[1], results: query[2]});
            }
        })
	});
}

// Verifying Bearer Token
function verifyToken(req, res, next) {
	const bearerHeader = req.headers["authentication"];
    if (typeof bearerHeader !== "undefined") {
        const bearer = bearerHeader.split(" ");
        const bearerToken = bearer[1];
        req.token = bearerToken;
        next()
    } else {
        res.json("Token Not Found");
    }
}

// Check Secret Key Matches
function CheckSecretKey(key, secret) {
    if (key != secret) {
        return false
    } else {
        return true
    }
}

console.log("^1[DatabaseAPI Message] ^0: ^4Loaded 'routes.js'^0");