var http = require('http');
var port = 3000;
// Creem l'objecte servidor
http.createServer(function (req, res) {

    // response header 200 OK
    res.writeHead(200, {'Content-Type': 'text/html'});

    res.write('Hello World!');
    res.end();
    console.log(req.url)


}).listen(port, function() {
    console.log("El servidor esta escolatant al port" + port);
});
