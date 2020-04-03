const mysql = require("mysql");
const config = require("./config").database;
const devmode = require("./config").dev;

// Connection Pool
var pool = mysql.createPool(config);

function SendQuery(query, data) {
	return new Promise((resolve) => {
		pool.getConnection((error, connection) => {
			if (error) {
				resolve([false, error, "[]"]);
			} else {
				connection.query(query, data, (error, results, fields) => {
					if (error) {
						resolve([false, error, "[]"]);
					}
					else {
						resolve([true, "Query Success", results]);
					}
				});
			}
			connection.release();
		});
	});
}

pool.on("connection", (connection) => {
	connection.config.queryFormat = function (query, values) {
        if (!values) return query;
        return query.replace(/\:(\w+)/g, function (txt, key) {
            if (values.hasOwnProperty(key)) {
                return this.escape(values[key]);
            }
            return txt;
        }.bind(this));
    };
});

pool.on("acquire", (connection) => {
	if (devmode){ DisplayConnections() }
});

pool.on("enqueue", () => {
	console.log("Waiting for available connection slot");
})

pool.on("release", (connection) => {
	if (devmode){ DisplayConnections() }
})

function DisplayConnections() {
	console.log(`Acquiring Connections: ${pool._acquiringConnections.length}`);
	console.log("------------------------------------------------")
	console.log(`All Connections: ${pool._allConnections.length}`);
	console.log("------------------------------------------------")
	console.log(`Free Connections: ${pool._freeConnections.length}`);
	console.log("------------------------------------------------")
	console.log(`Connections Queued: ${pool._connectionQueue.length}`);
	console.log("------------------------------------------------")
}

module.exports = SendQuery;

console.log("[DatabaseAPI Message] : Loaded 'database.js'");