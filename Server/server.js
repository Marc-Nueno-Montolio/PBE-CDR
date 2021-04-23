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
        res.write('OK Vaja... la ruta no existeix... Prova un dels 100 metodes diferents que et proposa el Francesc oller per solucionar aquest problema. ')
        res.end();
    }


}).listen(port, function () {
    console.log("El servidor esta escoltant al port: " + port);
});
