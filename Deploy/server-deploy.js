const { exec } = require("child_process");

var express = require('express'),
    bodyParser = require('body-parser'),
    app = express(),
    port = 3030;

app.use(bodyParser.json());

app.post('/deploy', function (req, res) {
    exec("cd /home/pbe/PBE-CDR/ ; git pull; pm2 restart /home/pbe/PBE-CDR/Server/server.js", (error, output) => {
        if (error) {
            return;
        }
        console.log(output)
    });
    res.end('Deploying...');
});

var server = app.listen(port, function () {

    var host = server.address().address
    var port = server.address().port

    console.log('Example app listening at http://%s:%s', host, port)

});