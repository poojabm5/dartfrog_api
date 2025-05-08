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

  Future<User?> delete(String id) async {
    // Convert id to an integer if needed
    final int parsedId = int.tryParse(id) ?? (throw Exception("Invalid ID"));

    // Use the parsed integer ID in the where clause
    final deletedUser = await _db.user.delete(
      where: UserWhereUniqueInput(
        id: parsedId,
      ),
    );

    return deletedUser;
  }

 Future<User?> updateUser(int id, Map<String, dynamic> updates) async {
  try {
    final updatedUser = await _db.user.update(
      where: UserWhereUniqueInput(id: id),
      data: UserUpdateInput(
        firstname: updates.containsKey('firstname')
            ? StringFieldUpdateOperationsInput(
                set: updates['firstname'] as String)
            : null,
        lastname: updates.containsKey('lastname')
            ? StringFieldUpdateOperationsInput(
                set: updates['lastname'] as String)
            : null,
        username: updates.containsKey('username')
            ? StringFieldUpdateOperationsInput(
                set: updates['username'] as String)
            : null,
        password: updates.containsKey('password')
            ? StringFieldUpdateOperationsInput(
                set: updates['password'] as String)
            : null,
      ),
    );
    return updatedUser;
  } catch (e) {
    // Handle errors (e.g., user not found)
    return null;
  }
}

Future<bool> deleteUser(int id) async {
  try {
    await _db.user.delete(
      where: UserWhereUniqueInput(id: id),
    );
    return true;
  } catch (e) {
    // If deletion fails (e.g., user doesn't exist), return false
    return false;
  }
}

}

