var MongoClient = require('mongodb').MongoClient;
var url = "mongodb://138.68.163.210:27017";

function testDbConnection(url) {
    MongoClient.connect(url, { useUnifiedTopology: true } ,function (err, db) {
        if (err) throw err;
        console.log("Connected succesfully")
        db.close();
    });
};

export {testDbConnection}
