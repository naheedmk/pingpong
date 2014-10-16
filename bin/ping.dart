library ping;

import 'package:start/start.dart';
import 'package:http/http.dart' as http;
import 'package:args/args.dart';

/**
 * Starts the ping server.
 */
void startPingServer(args) {
  // Command line options for the ping server
  final options = new ArgParser();
  options.addOption('url', abbr: 'u', defaultsTo: 'http://localhost:4040', help: 'used to specify the pong url');
  options.addOption('port', abbr: 'p', defaultsTo: '8080', help: 'port number');

  final url  = options.parse(args)['url'];             // get the url of pong server
  final port = int.parse(options.parse(args)['port']); // get the port number of ping server

  start(host: "0.0.0.0", port: port).then((app) {
    app.get("/ping/:length").listen((req) {
      int len = int.parse(req.param('length'));

      http.get("$url/pong/$len").then((response) {
        req.response.status(200);
        req.response.send(response.body);
      }).catchError((err) {
        print(err);
        req.response.status(503);
        req.response.send("Pong server is not answering");
      });
    });

    print("Ping-Server is up and running, Listening on port $port");
    print("Pong-Server assumed to be reachable at $url");

  });  
}

/**
 * Entrypoint to start the ping relay server without docker.
 */
void main(args) => startPingServer(args);
