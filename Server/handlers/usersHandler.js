
var url = require('url');
var dbHelper = require('../dbHelper.js')

var handler = (req, res) => {
    var query = new URLSearchParams(url.parse(req.url).query);
    var uid = query.get('uid')
    if (uid) {
        dbHelper.findUserByUid(uid, (err, student) => {
            if (student) {
                res.writeHead(200, {'Content-Type': 'application/json'});
                res.end(JSON.stringify({
                    'name': student.name,
                    'uid': student.student_id
                }))
            } else {
                res.writeHead(404, {'Content-Type': 'application/json'});
                res.end(JSON.stringify({}));
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