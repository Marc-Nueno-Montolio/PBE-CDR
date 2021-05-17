var url = require('url');
var dbHelper = require('../dbHelper.js')

var handler = (req, res) => {
    var query = new URLSearchParams(url.parse(req.url).query);
    var uid = query.get('uid')
    if (uid) {
        dbHelper.findUserByUid(uid, (err, student) => {
            if (student) {
                res.setHeader('Access-Control-Allow-Origin', '*');
                res.setHeader('Access-Control-Request-Method', '*');
                res.setHeader('Access-Control-Allow-Methods', 'OPTIONS, GET');
                res.setHeader('Access-Control-Allow-Headers', '*');

                res.writeHead(200, {'Content-Type': 'application/json'});
                res.end(JSON.stringify({
                    'uid': student.student_id,
                    'photo_url': student.photo_url,
                    'name': student.name


                }))
            } else {
                // Set CORS headers
                res.setHeader('Access-Control-Allow-Origin', '*');
                res.setHeader('Access-Control-Request-Method', '*');
                res.setHeader('Access-Control-Allow-Methods', 'OPTIONS, GET');
                res.setHeader('Access-Control-Allow-Headers', '*');
                res.writeHead(404, {'Content-Type': 'application/json'});
                res.end(JSON.stringify({}));
            }
        })

    } else {
        // Set CORS headers
        res.setHeader('Access-Control-Allow-Origin', '*');
        res.setHeader('Access-Control-Request-Method', '*');
        res.setHeader('Access-Control-Allow-Methods', 'OPTIONS, GET');
        res.setHeader('Access-Control-Allow-Headers', '*');
        res.end("ERROR")
    }

};

module.exports = (req, res) => {
    if (req.method == 'GET') {
        handler(req, res)
    }
}