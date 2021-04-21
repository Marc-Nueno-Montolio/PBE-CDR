var http = require('http');
var dbHelper = require('./dbHelper.js')
var port = 3000;
// Creem l'objecte servidor
http.createServer(function (req, res) {

    // response header 200 OK
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end();
    console.log(req.url)
    dbHelper.testDbConnection()


}).listen(port, function() {
    console.log("El servidor esta escolatant al port" + port);
});
