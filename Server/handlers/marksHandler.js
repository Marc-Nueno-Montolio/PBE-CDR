const url = require('url')
var db = require('../dbHelper')

var handler = (req, res) => {
    var params = new URLSearchParams(url.parse(req.url).query)
    var options = {sort: {subject: 1}};
    var query = {}; //https://docs.mongodb.com/manual/reference/operator/query/#miscellaneous-operators

    // Afegim l'uid a la query
    var uid = params.get('uid') || 0;
    query['student_id'] = uid

    // Afegim el constraint de subject al query:
    if (params.get('subject'))
        query['subject'] = params.get('subject')

    // Afegim el constraing de limit a les opcions
    if (params.get('limit')) {
        options['limit'] = parseInt(params.get('limit'));
    }

    // Afegim constraints lt, gt
    if (params.get('mark[gt]')) {
        query['mark'] = {$gt: parseInt(params.get('mark[gt]'))}
    }
    if (params.get('mark[lt]')) {
        query['mark'] = {$lt: parseInt(params.get('mark[lt]'))}
    }
    // Afegim constraints lte, gte
    if (params.get('mark[gte]')) {
        query['mark'] = {$gte: parseInt(params.get('mark[gte]'))}
    }
    if (params.get('mark[lte]')) {
        query['mark'] = {$lte: parseInt(params.get('mark[lte]'))}
    }

    // TODO: Constraints que tinguin a veure amb dates

    // Enviem el query a la base de dades
    db.sendQuery('marks', query, options, {_id: 0, student_id: 0}, (err, obj) => {
        res.setHeader('Access-Control-Allow-Origin', '*');
        res.setHeader('Access-Control-Request-Method', '*');
        res.setHeader('Access-Control-Allow-Methods', 'OPTIONS, GET');
        res.setHeader('Access-Control-Allow-Headers', '*');

        res.writeHead(200, {'Content-Type': 'application/json'});
        res.end(JSON.stringify(obj))
    })
}

module.exports = (req, res) => {
    if (req.method == 'GET') {
        handler(req, res)
    }
}