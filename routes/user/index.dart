import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/user_repositary.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _createusers(context),
    HttpMethod.get => _getusers(context),
    HttpMethod.put => _updateUser(context),
    HttpMethod.delete => _deleteUser(context),
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
      'message': 'Missing required fields: firstname, lastname, username, password',
    }, statusCode: HttpStatus.badRequest);
  }

  final repo = context.read<UserRepositary>();

  try {
    final user = await repo.createUser(
      firstname: firstname,
      lastname: lastname,
      username: username,
      password: password,
    );

    return Response.json(body: {
      'message': 'User saved!',
      'user': user.toJson(),
    });

  } catch (e) {
    if (e.toString().contains('Unique constraint failed') ||
        e.toString().contains('User_username_key')) {
      return Response.json(
        statusCode: HttpStatus.conflict,
        body: {'message': 'Username already exists.'},
      );
    }
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'message': 'Something went wrong', 'error': e.toString()},
    );
  }
}


Future<Response> _updateUser(RequestContext context) async {
  final json = (await context.request.json()) as Map<String, dynamic>;
  final id = json['id'] as int?;
  final updates = json['updates'] as Map<String, dynamic>?;

  if (id == null || updates == null) {
    return Response.json(
      body: {'message': 'Provide user id and updates'},
      statusCode: HttpStatus.badRequest,
    );
  }

  final repo = context.read<UserRepositary>();
  final updatedUser = await repo.updateUser(id, updates);

  if (updatedUser == null) {
    return Response.json(
      body: {'message': 'User not found'},
      statusCode: HttpStatus.notFound,
    );
  }

  return Response.json(
      body: {'message': 'User updated!', 'user': updatedUser.toJson()});
}

Future<Response> _deleteUser(RequestContext context) async {
  final json = (await context.request.json()) as Map<String, dynamic>;
  final id = json['id'] as int?;

  if (id == null) {
    return Response.json(
      body: {'message': 'User id is required'},
      statusCode: HttpStatus.badRequest,
    );
  }

  final repo = context.read<UserRepositary>();
  final success = await repo.deleteUser(id);

  if (!success) {
    return Response.json(
      body: {'message': 'User not found'},
      statusCode: HttpStatus.notFound,
    );
  }

  return Response.json(body: {'message': 'User deleted!'});
}
