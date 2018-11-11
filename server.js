const http = require('http');
const keys = require('./keys');
const redis = require('redis');
// const client = redis.createClient(); // this creates a new client
const client = redis.createClient(
    keys.redisPort, 
    keys.redisHost
  );

isRedisConnected = false;

var handleRequest = function(request, response) {
  console.log('Received request for URL: ' + request.url);
  response.writeHead(200);

  client.get('mkey', function (error, result) {
    if (error) {
        console.log(error);
        throw error;
        isRedisConnected = false;
    }
    console.log('REDIS GET result ->' + result);
  });

  var str = "REDIS IS ALSO CONNECTED."
  if(!isRedisConnected){
    str = "REDIS NOT CONNECTED.";
  }
  response.end('Hello World! This is Node running on Kubernetes.\n\n' + str);
};
var www = http.createServer(handleRequest);
www.listen(8086);

client.on('connect', function() {
  console.log('Redis client connected');
  isRedisConnected = true;
  client.set('mkey', 'my_test_value', redis.print);
});

client.on('error', function (err) {
  console.log('Something went wrong ' + err);
});