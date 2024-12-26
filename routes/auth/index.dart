import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/user_repositary.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _auth(context),
    _ => Future.value(Response(body: 'delayed')),
  };
}

Future<Response> _auth(RequestContext context) async {
  final json = (await context.request.json()) as Map<String, dynamic>;
  final username = json['username'] as String?;
  final password = json['password'] as String?;
  if (username == null || password == null) {
    return Response.json(body: {
      'message': 'enter username and password',
    }, statusCode: HttpStatus.badRequest);
  }

  final repo = context.read<UserRepositary>();
  final user = await repo.auth(username: username, password: password);
  if (user == null) {
    return Response.json(body: {
      'message': 'user not found',
    }, statusCode: HttpStatus.notFound);
  }
  return Response.json(
    body: {'message': 'login successful', 'usercredentionals': user},
  );
}
