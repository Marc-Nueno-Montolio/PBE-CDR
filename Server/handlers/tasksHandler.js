const url = require('url')
var db = require('../dbHelper')

var handler = (req,res)=>{
    var params = new URLSearchParams(url.parse(req.url).query)
    var options = {sort: {date: 1}};
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
        if(params.get('date[gte]')=='now'){
            query['date_d'] ={$gte: new Date()}
        }else{
            query['date_d'] = {$gte: new Date(params.get('date[gte]'))}
        }
    }
    // Afegim el constraint lte
    if (params.get('date[lte]')) {
        if(params.get('date[lte]')=='now'){
            query['date_d'] ={$lte: new Date()}
        }else{
            query['date_d'] = {$lte: new Date(params.get('date[lte]'))}
        }
    }
    //Constraint per buscar date[gt]
     if (params.get('date[gt]')) {
        if(params.get('date[gt]')=='now'){
            query['date_d'] ={$gt: new Date()}
        }else{
            query['date_d'] = {$gt: new Date(params.get('date[gt]'))}
        }
    }
    // Afegim el constraint lt
    if (params.get('date[lt]')) {
        if(params.get('date[lt]')=='now'){
            query['date_d'] ={$lt: new Date()}
        }else{
            query['date_d'] = {$lt: new Date(params.get('date[lt]'))}
        }
    }
    // Afegim constraint per buscar data exacta
    if (params.get('date')){
        query['date_d'] = new Date(params.get('date'))
    }
    // Enviem el query a la base de dades
    db.sendQuery('tasks_unwind', query, options, {_id: 0, id_students: 0, date_d: 0}, (err, obj) => {
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