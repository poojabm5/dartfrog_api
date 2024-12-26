import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.delete => _deleteuser(id),
    HttpMethod.put => _updateuser(context, id),
    _ => Future.value(Response(body: 'hello'))
  };
}

Future<Response> _deleteuser(String id) async {
  return Response.json(body: {
    'message': 'user with $id has been deleted',
  });
}

Future<Response> _updateuser(RequestContext context, String id) async {
  return Response.json(body: {
    'message': 'user has been updated',
  });
}
