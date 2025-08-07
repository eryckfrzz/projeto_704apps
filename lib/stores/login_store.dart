import 'package:mobx/mobx.dart';
import 'package:projeto_704apps/features/models/user.dart';
import 'package:projeto_704apps/services/remote/login_dao_impl.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  @observable
  User? user;

  final LoginDaoImpl service = LoginDaoImpl();

  @action
  Future<bool> loginUser(String email, String password) async {
    final User? loggedUser = await service.login(
      email: email,
      password: password,
    );

    if (loggedUser != null) {
      user = loggedUser;
      return true;
    }

    return false;
  }

  // @action
  // Future<bool> registerUser(String email, String password, String name) async {
  //   final bool registeredUser = await service.register(
  //     email: email,
  //     password: password,
  //     name: name,
  //   );

  //   if (registeredUser) {
  //     user = registeredUser as User;
  //     return true;
  //   }

  //   return false;
  // }
}
