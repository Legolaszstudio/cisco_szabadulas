import 'dart:convert';
import 'dart:io';

HttpClient client = HttpClient();

Future<String> getBody({
  required String destination,
  String path = '/',
}) async {
  try {
    HttpClientRequest request = await client.get(
      Uri.parse(destination).host,
      8080,
      path,
    );
    HttpClientResponse response = await request.close();
    final stringData = await response.transform(utf8.decoder).join();
    return stringData;
  } finally {
    client.close();
  }
}
