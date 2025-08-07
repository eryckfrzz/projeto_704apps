import 'package:image_picker/image_picker.dart';
import 'package:projeto_704apps/features/models/user.dart';

abstract class UsersDao {
  Future<User?> register(User user, {required bool userApp});

  Future<List<User>> getAllUsers({required String token});

  getUserById(int id, {required String token, required bool userApp});

  Future<bool> updateUser(User user, int id, {required String token});

  Future<bool> deleteUser(int id, {required String token});

  Future<bool> sendPushNotification(int id, {required String token});

  Future<bool> addImageProfile(int id, XFile file, {required String token});

  Future<bool> requestPasswordReset(String email);
  Future<bool> resetPassword(String token, String newPassword);
}
