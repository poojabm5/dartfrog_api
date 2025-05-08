import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  if (context.request.method == HttpMethod.get) {
    return Response(body: 'hey! its get method');
  }
  return Response(body: 'hey! its not a get method');
}
