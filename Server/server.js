// Imports
var http = require('http');
var url = require('url')
var parse = require('url-parse');
var usersHandler = require('./handlers/usersHandler')
var marksHandler = require('./handlers/marksHandler')

// Opcions de configuració
var port = 3000;

// Cada ruta te el seu handler que procesa la petició
var routes = {
    '/students': usersHandler,
    '/marks': marksHandler
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
        res.writeHead(404, {'Content-Type': 'text/html'});
        res.write('Vaja... la ruta no existeix... Prova un dels 100 metodes diferents que et proposa el Francesc oller per solucionar aquest problema. ')
        res.end();
    }

}).listen(port, function () {
    console.log("El servidor esta escoltant al port: " + port);
});
