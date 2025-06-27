import 'package:projeto_704apps/features/models/user.dart';

abstract class UsersDao {
  Future<User?> register(User user);

  Future<List<User>> getAllUsers({required String token});

  getUserById(int id, {required String token});

  Future<bool> updateUser(User user, int id, {required String token});

  Future<bool> deleteUser(int id, {required String token});

  Future<bool> sendPushNotification(int id, {required String token});
}
