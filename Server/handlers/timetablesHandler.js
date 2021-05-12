const url = require('url')
var db = require('../dbHelper')

var handler = (req,res)=>{
    var params = new URLSearchParams(url.parse(req.url).query)
    var options = {sort: {_id: 1}};
    var query = {};

    // Afegim l'uid a la query
    var uid = params.get('uid') || 0;
    query['id_students'] = uid

    // Afegim el constraint de subject al query:
    if (params.get('subject'))
        query['subject'] = params.get('subject')
    
    // Afegim el constraint de limit a les opcions
    if (params.get('limit')) {
        options['limit'] = parseInt(params.get('limit'));
    }
    // Constraint per consultar en funcio del dia
    if (params.get('day')) {
        query['day'] = params.get('day')
    }
    // Afegim constraint de hour[gt]
    if (params.get('hour[gt]')) {
        query['hour'] = {$gt: params.get('hour[gt]')}
    }
    //Afegim constraint per filtrar per hora
    if (params.get('hour')) {
        query['hour'] = params.get('hour')
    }

    // Enviem el query a la base de dades
    db.sendQuery('timetable_unwind', query, options, {_id: 0, id_students: 0}, (err, obj) => {
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