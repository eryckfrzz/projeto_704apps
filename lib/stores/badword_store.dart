import 'package:mobx/mobx.dart';
import 'package:projeto_704apps/features/models/badword.dart';
import 'package:projeto_704apps/services/remote/badword_dao_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'badword_store.g.dart'; // Certifique-se de que esta linha está correta para seu build_runner

class BadwordStore = _BadwordStore with _$BadwordStore;

abstract class _BadwordStore with Store {
  @observable
  ObservableList<Badword> defaultBadwords = ObservableList<Badword>();

  @observable
  ObservableList<Badword> configuredBadwords = ObservableList<Badword>();

  @observable
  ObservableList<Badword> customBadwords = ObservableList<Badword>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  final BadwordDaoImpl _badwordService = BadwordDaoImpl();

  // Método para buscar todas as listas de badwords
  @action
  Future<void> fetchAllBadwords() async {
    isLoading = true;
    errorMessage = null;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('access_token');
      final int? userId = prefs.getInt('user_id'); // Lendo userId como int

      if (token == null) {
        errorMessage = 'Token de autenticação não encontrado.';
        isLoading = false;
        return;
      }
      print('BadwordStore: fetchAllBadwords - Token presente. userId: $userId');

      // Buscar badwords padrão
      print('BadwordStore: Buscando badwords padrão...');
      final fetchedDefault = await _badwordService.getBadwordsDefault(token: token);
      defaultBadwords = ObservableList.of(fetchedDefault);
      print('BadwordStore: Badwords padrão carregadas: ${defaultBadwords.length}');

      // Buscar badwords configuradas (requer serial do dispositivo)
      // Assumindo que o serial do dispositivo é obtido de alguma forma,
      // talvez através de um UserStore ou diretamente no serviço de background
      // Para a tela de Badwords, podemos usar o userId como o deviceId se for o mesmo conceito
      if (userId != null) { // Usando userId como deviceId para buscar badwords configuradas
        print('BadwordStore: Buscando badwords configuradas para userId: $userId...');
        final fetchedConfigured = await _badwordService.getBadwordsConfigured(userId, token: token);
        configuredBadwords = ObservableList.of(fetchedConfigured);
        print('BadwordStore: Badwords configuradas carregadas: ${configuredBadwords.length}');
      } else {
        print('BadwordStore: User ID não disponível para buscar badwords configuradas.');
      }


      // Buscar badwords customizadas (requer userId)
      if (userId != null) {
        print('BadwordStore: Buscando badwords customizadas para userId: $userId...');
        final fetchedCustom = await _badwordService.getBadwordsCustom(token: token); // Assumindo que a API filtra pelo token
        customBadwords = ObservableList.of(fetchedCustom);
        print('BadwordStore: Badwords customizadas carregadas: ${customBadwords.length}');
      } else {
        print('BadwordStore: User ID não disponível para buscar badwords customizadas.');
      }

    } catch (e) {
      errorMessage = 'Falha ao carregar palavras hostis: ${e.toString()}';
      print('BadwordStore: Erro em fetchAllBadwords: $e');
    } finally {
      isLoading = false;
    }
  }

  // Método para registrar uma palavra hostil customizada
  @action
  Future<bool> registerCustomBadword(Badword badword) async {
    isLoading = true;
    errorMessage = null;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('access_token');

      if (token == null) {
        errorMessage = 'Token de autenticação não encontrado.';
        isLoading = false;
        return false;
      }
      print('BadwordStore: Registrando badword customizada: ${badword.word} para userId: ${badword.userId}');
      final bool success = await _badwordService.registerBadwordCustom(badword, token: token);
      if (success) {
        print('BadwordStore: Palavra customizada registrada com sucesso. Recarregando listas...');
        await fetchAllBadwords(); // Recarrega todas as listas após o registro
        return true;
      } else {
        errorMessage = 'Falha ao registrar palavra customizada.';
        print('BadwordStore: Falha ao registrar palavra customizada.');
        return false;
      }
    } catch (e) {
      errorMessage = 'Erro ao registrar palavra customizada: ${e.toString()}';
      print('BadwordStore: Erro em registerCustomBadword: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  // Método para atualizar uma palavra hostil customizada
  @action
  Future<bool> updateBadword(int userId, String oldWord, String newWord) async { // Assinatura atualizada
    isLoading = true;
    errorMessage = null;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('access_token');

      if (token == null || userId == null) {
        errorMessage = 'Token ou ID do usuário não encontrado.';
        isLoading = false;
        return false;
      }

      // Cria uma nova Badword com a palavra atualizada e o userId existente
      final updatedBadword = Badword(
        word: newWord,
        userId: userId, // Garante que o userId seja o do usuário logado
      );
      print('BadwordStore: Atualizando badword de "$oldWord" para "$newWord" para userId: $userId');

      final bool success = await _badwordService.updateBadwordCustom(
        userId, // Passa o userId como int
        oldWord, // Palavra original para identificar
        updatedBadword, // Nova palavra e dados
        token: token,
      );

      if (success) {
        print('BadwordStore: Palavra customizada atualizada com sucesso. Recarregando listas...');
        await fetchAllBadwords(); // Recarrega todas as listas após a atualização
        return true;
      } else {
        errorMessage = 'Falha ao atualizar palavra.';
        print('BadwordStore: Falha ao atualizar palavra.');
        return false;
      }
    } catch (e) {
      errorMessage = 'Erro ao atualizar palavra: ${e.toString()}';
      print('BadwordStore: Erro em updateBadword: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  // Método para excluir uma palavra hostil customizada
  @action
  Future<bool> deleteBadwordCustom(int userId, String word) async { // userId como int
    isLoading = true;
    errorMessage = null;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('access_token');

      if (token == null) {
        errorMessage = 'Token de autenticação não encontrado.';
        isLoading = false;
        return false;
      }
      print('BadwordStore: Excluindo badword "$word" para userId: $userId');
      final bool success = await _badwordService.deleteBadwordCustom(userId, word, token: token);
      if (success) {
        print('BadwordStore: Palavra customizada excluída com sucesso. Recarregando listas...');
        await fetchAllBadwords(); // Recarrega todas as listas após a exclusão
        return true;
      } else {
        errorMessage = 'Falha ao excluir palavra.';
        print('BadwordStore: Falha ao excluir palavra.');
        return false;
      }
    } catch (e) {
      errorMessage = 'Erro ao excluir palavra: ${e.toString()}';
      print('BadwordStore: Erro em deleteBadwordCustom: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }
}