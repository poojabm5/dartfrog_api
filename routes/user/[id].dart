import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/user_repositary.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.delete => _deleteuser(id, context),
    HttpMethod.put => _updateuser(context, id),
    _ => Future.value(Response(body: 'hello'))
  };
}

Future<Response> _deleteuser(String id, RequestContext context) async {
  final repo = context.read<UserRepositary>();
  final user = await repo.delete(id);
  return Response.json(body: {'message': 'deleted!'});
}

Future<Response> _updateuser(RequestContext context, String id) async {
  return Response.json(body: {
    'message': 'user has been updated',
  });
}
