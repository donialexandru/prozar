const http = require('http');

http.createServer(
	function(req, res) {
		res.write("On the way to beign a full stack eng");
		res.end();
	}
).listen(3000);
console.log("Server started");
