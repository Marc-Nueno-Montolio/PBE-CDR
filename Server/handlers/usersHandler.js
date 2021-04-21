var url = require('url');
var dbHelper = require('../dbHelper.js')

var actions = {
    'GET': (req, res) => {
        uid = url.parse(req.url).query;
        uid = uid.split('=')[1]

        user = dbHelper.findUserByUid(uid)
        console.log(user)
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.end(JSON.stringify(user));
    }
};

module.exports = (request, response) => {
    var action = actions[request.method];
    if (action) {
        action(request, response);
    } else {
        utils.sendResponse(response, "Not Found", 404,{'Content-Type': 'text/plain'});
    }
};
