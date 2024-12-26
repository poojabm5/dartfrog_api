import 'package:my_first/src/generated/prisma/prisma_client.dart';

// ignore: public_member_api_docs
class UserRepositary {
  UserRepositary(this._db);

  final PrismaClient _db;
  Future<User> createUser({
    required String firstname,
    required String lastname,
    required String username,
    required String password,
  }) async {
    final user = await _db.user.create(
      data: UserCreateInput(
        firstname: firstname,
        lastname: lastname,
        username: username,
        password: password,
      ),
    );
    return user;
  }

  Future<User?> auth(
      {required String username, required String password}) async {
    final user = _db.user.findFirst(
      where: UserWhereInput(
        username: StringFilter(equals: username),
        password: StringFilter(equals: password),
      ),
    );
    return user;
  }

  Future<List<User>> getAll() async {
    final list = await _db.user.findMany();
    return list.toList();
  }
}
