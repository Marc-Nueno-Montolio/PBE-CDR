var MongoClient = require('mongodb').MongoClient;
const url = "mongodb://138.68.163.210:27017";
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
        if (err){
            return callback(err, []);
        }
        var query = {student_id: uid};

        db.db("pbe").collection("students").find(query).toArray(function (err, student) {
            db.close();
            return callback(err, student);
        });
    });
};


module.exports = {
    findUserByUid,
    testDbConnection
}