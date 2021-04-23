require('dotenv').config()
var MongoClient = require('mongodb').MongoClient;
const url = process.env.DBString; // Per no compartir el password
const conOptions = {useUnifiedTopology: true} // Soluciona l'error de Connection Depprecated...

// Provar la connexio amb la base de dades
function testDbConnection(callback) {
    MongoClient.connect(url, conOptions, function (err, db) {
        if (err)
            return callback(err)
        return callback("connected successfully")
        db.close();
    });
};

// Buscar un usuari a la base de dades a partir del seu UID
function findUserByUid(uid, callback) {
    MongoClient.connect(url, conOptions, function (err, db) {
        if (err) {
            return callback(err, []);
        }
        // Construim el query
        var query = {student_id: uid};

        // Connexio a mongo db retorna objecte db, ens coloquem a la db pbe i coleccio students
        db.db("pbe").collection("students").find(query, {limit: 1}).toArray(function (err, student) {
            db.close();
            // retorna l'estudiant o null
            return callback(err, student[0]);
        });
    });
};

function sendQuery(collection, query, options, projection, callback) {
    // Arreglem els parametres:
    collection = collection || {};
    options = options || {};
    query = query || {};

    //Connexió a mongoDB
    MongoClient.connect(url, conOptions, (err, db) => {
        if (err) {
            return callback(err, [])
        }
        // Creem una colecció i li passem un query amb opcions i projeccio. El resultat retornem amb un callback.
        const col = db.db("pbe").collection(collection).find(query, options).project(projection).toArray((err, obj) => {
            return callback(err, obj);
        })
    })
}

// exportem els metodes
module.exports = {findUserByUid, testDbConnection, sendQuery}