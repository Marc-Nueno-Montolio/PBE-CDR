// Imports
var http = require('http');
var url = require('url')
var parse = require('url-parse');
var usersHandler = require('./handlers/usersHandler')
var marksHandler = require('./handlers/marksHandler')
var tasksHandler = require('./handlers/tasksHandler')
var timetablesHandler = require('./handlers/timetablesHandler')

// Opcions de configuració
var port = 3000;

// Cada ruta te el seu handler que procesa la petició
var routes = {
    '/students': usersHandler,
    '/marks': marksHandler,
    '/timetables': timetablesHandler,
    '/tasks': tasksHandler
}

// Creem l'objecte servidor
http.createServer(function (req, res) {

    var route = routes[url.parse(req.url).pathname];
    // Info per debug
    console.log('-> Nova Petició: ' + req.method + ': ' +req.url)

    if (route)
        // Si la ruta existeix, enviem la petició al handler corresponent
        route(req, res);
    else {
        // si la ruta no existeix resposta per defecte.
        // Set CORS headers
        res.setHeader('Access-Control-Allow-Origin', '*');
        res.setHeader('Access-Control-Request-Method', '*');
        res.setHeader('Access-Control-Allow-Methods', 'OPTIONS, GET');
        res.setHeader('Access-Control-Allow-Headers', '*');

        res.writeHead(404, {'Content-Type': 'application/json'});
        res.end(JSON.stringify({}));
    }

}).listen(port, function () {
    console.log("El servidor esta escoltant al port: " + port);
});
