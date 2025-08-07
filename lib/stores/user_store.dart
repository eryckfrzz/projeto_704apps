import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:projeto_704apps/features/models/user.dart';
import 'package:projeto_704apps/services/remote/image_profile_dao_impl.dart';
import 'package:projeto_704apps/services/remote/image_vehicle_dao_impl.dart';
import 'package:projeto_704apps/services/remote/users_dao_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  final UsersDaoImpl service = UsersDaoImpl();
  final ImageProfileDaoImpl _imageProfileService =
      ImageProfileDaoImpl(); // Instância do serviço de imagem de perfil
  final ImageAnalyzeDaoImpl _imageAnalyzeService =
      ImageAnalyzeDaoImpl(); // Instância do serviço de imagem de veículo

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
  Future<void> getUserId(int id, {required bool userAppFlag}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final fetchedUser = await service.getUserById(
      id,
      token: token!,
      userApp: userAppFlag,
    );

    if (fetchedUser != null) {
      user = fetchedUser;
    } else {
      print('Erro não encontrado ou erro na API!');
    }
  }

  @action
  Future<bool> addUser(User newUser, {required bool userAppFlag}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      bool success;
      if (newUser.id != null) {
        // Se o ID existe, é uma atualização
        success = await service.updateUser(newUser, newUser.id!, token: token!);
      } else {
        // Se o ID não existe, é um novo usuário
        User? registeredUser = await service.register(
          newUser,
          userApp: userAppFlag,
        );
        success = registeredUser != null;
        if (registeredUser != null) newUser = registeredUser;
      }

      if (success) {
        // Após a atualização/registro, atualize o usuário na store
        // Idealmente, a API retornaria o usuário atualizado
        await getUserId(
          newUser.id!,
          userAppFlag: userAppFlag,
        ); // Recarrega os dados para garantir consistência
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro em addUser: $e');
      return false;
    }
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

    final updated = await service.updateUser(user, user.id!, token: token!);

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

  // @action
  // Future<void> addImageProfile(int userId, XFile file) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   String? token = prefs.getString('access_token');

  //   final result = await service.addImageProfile(userId, file, token: token!);

  //   if (result != null) {
  //     print('Imagem de perfil enviada!');
  //     await getUserId(userId);
  //   } else {
  //     print('Erro ao enviar imagem de perdil');
  //   }
  // }

  @action
  Future<bool> requestPasswordReset(String email) async {
    try {
      final bool success = await service.requestPasswordReset(email);
      if (success) {
        print(
          'USER_STORE: Solicitação de recuperação de senha bem-sucedida para $email.',
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @action
  Future<bool> resetPassword(String token, String newPassword) async {
    try {
      final bool success = await service.resetPassword(token, newPassword);
      if (success) {
        print('USER_STORE: Senha redefinida com sucesso.');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Método para fazer upload da foto de perfil
  @action
  Future<bool> uploadProfileImage(int userId, String imagePath) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      // O DAO de imagem de perfil espera um int para userId
      final result = await _imageProfileService.registerImageProfile(
        userId,
        imagePath,
        token: token!,
      );
      if (result != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro em uploadProfileImage: $e');
      return false;
    }
  }

  // Método para fazer upload de múltiplas fotos
  @action
  Future<bool> uploadOtherImages(int userId, List<String> imagePaths) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      // O DAO de imagem de análise espera um int para userId
      final result = await _imageAnalyzeService.registerImageAnalysis(
        userId,
        imagePaths,
        token: token!,
      );
      if (result != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro em uploadOtherImages: $e');
      return false;
    }
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
