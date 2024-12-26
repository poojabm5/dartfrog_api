import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/src/generated/prisma/prisma_client.dart';
import 'package:my_first/user_repositary.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _createusers(context),
    HttpMethod.get => _getusers(context),
    _ => Future.value(Response(body: 'hello'))
  };
}

Future<Response> _getusers(RequestContext context) async {
  final repo = context.read<UserRepositary>();
  final user = await repo.getAll();
  return Future.value(Response.json(body: user));
}

Future<Response> _createusers(RequestContext context) async {
  final json = (await context.request.json()) as Map<String, dynamic>;
  final firstname = json['firstname'] as String?;
  final lastname = json['lastname'] as String?;
  final username = json['username'] as String?;
  final password = json['password'] as String?;
  if (firstname == null ||
      lastname == null ||
      username == null ||
      password == null) {
    return Response.json(body: {
      'message': 'add firstname,lastname,username, password',
    }, statusCode: HttpStatus.badRequest);
  }
  final repo = context.read<UserRepositary>();
  final user = await repo.createUser(
    firstname: firstname,
    lastname: lastname,
    username: username,
    password: password,
  );
  return Response.json(body: {'message': 'saved!', 'user': user.toJson()});
}
