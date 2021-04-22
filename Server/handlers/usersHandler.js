var url = require('url');
var dbHelper = require('../dbHelper.js')

var handler = (req, res) => {
    var query = new URLSearchParams(url.parse(req.url).query);
    var uid = query.get('uid')
    if (uid) {
        dbHelper.findUserByUid(uid, (err, student) => {
            if (student[0]) {
                console.log(student)
                res.end(JSON.stringify(student))
            } else {
                res.end("No existeix l'estudiant")
            }
        })

    } else {
        res.end("ERROR")
    }

};

module.exports = (req, res) => {
    if (req.method == 'GET') {
        handler(req, res)
    }
}