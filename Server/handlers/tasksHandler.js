const url = require('url')
var db = require('../dbHelper')

var handler = (req,res)=>{
    var params = new URLSearchParams(url.parse(req.url).query)
    var options = {sort: {subject: 1}};
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
     // Afegim el constraint gte
     if (params.get('date[gte]')) {
        query['date'] = {$gte: params.get('date[gte]')}
    }
    // Afegim constraint per buscar data exacta
    if (params.get('date')){
        query['date'] = new Date(params.get('date'))
    }
    // Enviem el query a la base de dades
    db.sendQuery('tasks_unwinded', query, options, {_id: 0, id_students: 0}, (err, obj) => {
        res.writeHead(200, {'Content-Type': 'application/json'});
        res.end(JSON.stringify(obj))
    })

}

module.exports = (req, res) => {
    if (req.method == 'GET') {
        handler(req, res)
    }
}