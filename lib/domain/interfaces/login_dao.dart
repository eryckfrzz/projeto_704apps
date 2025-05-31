abstract class LoginDao {
  Future<bool> login({required String email, required String password});

   Future<bool> getProfile();

  saveUserInfo(String body);
  // register({required String email, required String password});
}
