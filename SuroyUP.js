var express = require('express')
var app = express()
var pg = require('pg');
var conString = "postgres://postgres:archie456@localhost:5432/vanessa";
var client = new pg.Client(conString);
client.connect();

app.use(express.static(__dirname))

app.get('/', function (req, res) {
   res.sendFile( __dirname + "/" + "UP Suroy.html")
})

app.get('/dummy', function (req, res) {
   res.sendFile( __dirname + "/" + "dummy.html")
})

app.get('/map', function (req, res) {
   res.sendFile( __dirname + "/" + "map.html")
})

app.get('/empty', function (req, res) {
   res.sendFile( __dirname + "/" + "empty.html")
})

app.get('/getTitle', function(req, res){
	var query = client.query("Select * FROM Titles")
	var str = "hey"
	query.on('row', function(row) {
	   	str = row.title
	})

	query.on('end', function() {
		return res.json(str)
	})
	
})

var server = app.listen(8081, function () {
   var host = server.address().address
   var port = server.address().port

   console.log("SuroyUP at http://%s:%s", host, port)
})