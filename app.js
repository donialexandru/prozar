const http = require("http");

http
  .createServer(function (req, res) {
    res.write("This text represents that CI CD works with Docker");
    res.end();
  })
  .listen(3000);
console.log("Server started");
