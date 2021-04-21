var MongoClient = require('mongodb').MongoClient;
const url = "mongodb://138.68.163.210:27017";
const options = {useUnifiedTopology: true}

function testDbConnection() {
    MongoClient.connect(url, options, function (err, db) {
        if (err) throw err;
        console.log("Connected succesfully")
        db.close();
    });
};


function findUserByUid(uid) {
    MongoClient.connect(url, options, function(err, db) {
        var query = {student_id: uid};
        db.db("pbe").collection("students").find(query).toArray(function(err, result) {
            if (err) throw err;

            db.close();

        });
    });


};

console.log(findUserByUid('A677A214'))
module.exports = {
    findUserByUid,
    testDbConnection
}