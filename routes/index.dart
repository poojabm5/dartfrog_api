import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  if (context.request.method == HttpMethod.get) {
    return Response(body: 'Welcome to Dart Frog!');
  } else {
    return Response(body: 'Hey this is not a get request');
  }
}
