import 'dart:io';

Future<HttpServer> startServer(String content) async {
  HttpServer server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print(
    'Server running on IP : ' +
        server.address.toString() +
        ' On Port : ' +
        server.port.toString(),
  );
  server.listen((event) {
    event.response.headers.contentType = new ContentType(
      'text',
      'html',
      charset: 'utf-8',
    );
    event.response.write(content);
    event.response.close();
  });
  return server;
}
