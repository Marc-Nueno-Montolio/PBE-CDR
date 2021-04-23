const url = require('url')
var db = require('../dbHelper')

var handler = (req,res)=>{

}

module.exports = (req, res) => {
    if (req.method == 'GET') {
        handler(req, res)
    }
}