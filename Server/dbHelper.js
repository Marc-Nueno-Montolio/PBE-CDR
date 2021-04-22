require('dotenv').config()
var MongoClient = require('mongodb').MongoClient;
const url = process.env.DBString;
const options = {useUnifiedTopology: true}

function testDbConnection(callback) {
    MongoClient.connect(url, options, function (err, db) {
        if (err)
            return callback(err)
        return callback("connected successfully")
        db.close();
    });
};

function findUserByUid(uid, callback) {
    MongoClient.connect(url, options, function (err, db) {
        if (err) {
            return callback(err, []);
        }
        var query = {student_id: uid};

        db.db("pbe").collection("students").find(query).toArray(function (err, student) {
            db.close();
            return callback(err, student[0]);
        });
    });
};


module.exports = {
    findUserByUid,
    testDbConnection
}