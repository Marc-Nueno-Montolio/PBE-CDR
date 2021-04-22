// Imports
var http = require('http');
var url = require('url')
var parse = require('url-parse');
var usersHandler = require('./handlers/usersHandler')


// Conf options
var port = 3000;

var routes = {
    '/students': usersHandler
}


// Creem l'objecte servidor
http.createServer(function (req, res) {
    var route = routes[url.parse(req.url).pathname];
    if (route)
        // Si la ruta existeix, enviem la petició al handler corresponent
        route(req, res);
    else {
        res.writeHead(404, {'Content-Type': 'text/html'});
        res.write('La ruta solicitada no existeix')
        res.end();
    }


}).listen(port, function () {
    console.log("El servidor esta escolatant al port: " + port);
});
