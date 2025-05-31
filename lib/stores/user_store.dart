import 'package:mobx/mobx.dart';
import 'package:projeto_704apps/domain/models/user.dart';
import 'package:projeto_704apps/services/users_dao_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  final UsersDaoImpl service = UsersDaoImpl();

  @observable
  User? user;

  @observable
  ObservableList<User> users = ObservableList<User>();

  @action
  Future<void> getUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final fetchedUsers = await service.getAllUsers(token: token);

    users = fetchedUsers.asObservable();
    print('Usuários encontrados: ${users.length}');
  }

  @action
  Future<void> getUserId(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final fetchedUser = await service.getUserById(id, token: token!);

    if (fetchedUser != null) {
      user = fetchedUser;
    } else {
      print('Erro não encontrado ou erro na API!');
    }
  }

  @action
  Future<bool> addUser(User newUser) async {

    final User? addedUser = await service.register(newUser);

    if (addedUser != null) {
      users.add(addedUser);

      return true;
    }

    return false;
  }

  @action
  Future<bool> deleteUser(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final deleted = await service.deleteUser(id, token: token!);

    if (deleted) {
      user = null;
      return true;
    } else {
      print('Erro ao deletar o usuário!');
    }
    return false;
  }

  @action
  Future<bool> updateUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final updated = await service.updateUser(user, user.id, token: token!);

    if (updated) {
      this.user = user;

      final int index = users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        users[index] = user;
      }
      return true;
    } else {
      print('Erro ao atualizar o usuário!');
    }
    return false;
  }

  @action
  void removeUserFromList(int userId) {
    users.removeWhere((user) => user.id == userId);
  }

  @action
  void userSelected(int index) {
    users[index];
  }
}
