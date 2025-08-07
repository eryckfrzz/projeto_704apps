import 'package:projeto_704apps/features/models/user.dart';

abstract class LoginDao {
  Future<User?> login({required String email, required String password});

  Future<bool> getProfile();

  saveUserInfo(String body);
  // Future<bool>register({required String email, required String password, required String name});
}
