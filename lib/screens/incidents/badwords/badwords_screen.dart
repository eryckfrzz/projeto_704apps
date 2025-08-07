import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:projeto_704apps/features/models/badword.dart';
import 'package:projeto_704apps/stores/badword_store.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Para obter o userId

class BadwordsScreen extends StatefulWidget {
  const BadwordsScreen({super.key});

  @override
  State<BadwordsScreen> createState() => _BadwordsScreenState();
}

class _BadwordsScreenState extends State<BadwordsScreen> {
  late BadwordStore _badwordStore;
  int? _currentUserId; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _badwordStore = Provider.of<BadwordStore>(context);
    _loadUserIdAndFetchBadwords(); 
  }

  // Nova função para carregar o userId e então buscar as badwords
  Future<void> _loadUserIdAndFetchBadwords() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getInt('user_id');
    });
    // Carrega todas as listas de badwords somente se o userId estiver disponível
    if (_currentUserId != null) {
      _badwordStore.fetchAllBadwords();
    } else {
      _showFeedback('Erro: ID do usuário não encontrado. Faça login novamente.', isError: true);
    }
  }

  // Função para exibir feedback visual (SnackBar)
  void _showFeedback(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // Diálogo para adicionar ou editar uma palavra hostil
  Future<void> _showAddEditBadwordDialog({Badword? badwordToEdit}) async {
    final TextEditingController _wordController = TextEditingController(text: badwordToEdit?.word);
    final _formKey = GlobalKey<FormState>();

    // Garante que o userId esteja disponível antes de abrir o diálogo
    if (_currentUserId == null) {
      _showFeedback('Erro: ID do usuário não encontrado. Não foi possível realizar a operação.', isError: true);
      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(badwordToEdit == null ? 'Cadastrar Palavra Hostil' : 'Editar Palavra Hostil'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _wordController,
              decoration: const InputDecoration(
                labelText: 'Palavra',
                hintText: 'Ex: idiota, estúpido',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'A palavra não pode ser vazia.';
                }
                if (value.trim().length < 2) {
                  return 'A palavra deve ter pelo menos 2 caracteres.';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final String word = _wordController.text.trim();
                  bool success = false;

                  // Se estiver editando, usa o userId existente da badword e a palavra original para identificar
                  if (badwordToEdit != null) {
                    // Chamada atualizada para updateBadword
                    success = await _badwordStore.updateBadword(
                      _currentUserId!, // Passa o userId atual
                      badwordToEdit.word, // Palavra antiga
                      word, // Nova palavra
                    );
                  } else {
                    // Se estiver cadastrando, usa o _currentUserId
                    print('Cadastrando badword com userId: $_currentUserId'); // Log para depuração
                    final newBadword = Badword(word: word, userId: _currentUserId!);
                    success = await _badwordStore.registerCustomBadword(newBadword);
                  }

                  if (success) {
                    _showFeedback('Palavra salva com sucesso!');
                    Navigator.of(context).pop(); // Fecha o diálogo
                  } else {
                    _showFeedback(_badwordStore.errorMessage ?? 'Falha ao salvar palavra.', isError: true);
                  }
                }
              },
              child: Text(badwordToEdit == null ? 'Cadastrar' : 'Salvar'),
            ),
          ],
        );
      },
    );
  }

  // Diálogo de confirmação de exclusão
  Future<void> _showDeleteConfirmationDialog(int userId, String word) async { 
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir esta palavra hostil?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Chamada atualizada para deleteBadwordCustom
                bool success = await _badwordStore.deleteBadwordCustom(userId, word); 
                if (success) {
                  _showFeedback('Palavra excluída com sucesso!');
                  Navigator.of(context).pop(); // Fecha o diálogo
                } else {
                  _showFeedback(_badwordStore.errorMessage ?? 'Falha ao excluir palavra.', isError: true);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  // Widget auxiliar para construir uma seção de lista de badwords
  Widget _buildBadwordSection(String title, List<Badword> badwords, {bool enableActions = false}) {
    return ExpansionTile(
      title: Text('$title (${badwords.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
      children: [
        if (badwords.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Nenhuma palavra encontrada nesta categoria.'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: badwords.length,
            itemBuilder: (context, index) {
              final badword = badwords[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                elevation: 1,
                child: ListTile(
                  title: Text(
                    badword.word,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  trailing: enableActions
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showAddEditBadwordDialog(badwordToEdit: badword);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Ao excluir, passamos o userId e a palavra para identificar a badword
                                if (badword.userId != null) {
                                  _showDeleteConfirmationDialog(badword.userId!, badword.word); 
                                } else {
                                  _showFeedback('ID do usuário da palavra não encontrado para exclusão.', isError: true);
                                }
                              },
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Gerenciamento de Palavras Hostis',
            style: TextStyle(
              color: Colors.deepPurple[400],
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.deepPurple[400]),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.deepPurple[400],
            width: 350,
          ),
        ),
      ),
      body: Observer(
        builder: (_) {
          if (_badwordStore.isLoading || _currentUserId == null) { // Adiciona verificação do userId
            return const Center(child: CircularProgressIndicator());
          } else if (_badwordStore.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Erro: ${_badwordStore.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          }

          if (_badwordStore.defaultBadwords.isEmpty &&
              _badwordStore.configuredBadwords.isEmpty &&
              _badwordStore.customBadwords.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma palavra hostil encontrada em nenhuma categoria.\nClique "+" para adicionar uma palavra customizada.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView(
            children: [
              _buildBadwordSection('Palavras Padrão', _badwordStore.defaultBadwords),
              _buildBadwordSection('Palavras Configuradas', _badwordStore.configuredBadwords),
              _buildBadwordSection('Palavras Customizadas', _badwordStore.customBadwords, enableActions: true),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditBadwordDialog();
        },
        backgroundColor: Colors.deepPurple[400],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
