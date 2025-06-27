import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_704apps/stores/contact_store.dart';
import 'package:provider/provider.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  late ContactStore _contactStore;
  bool _isInitialLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _contactStore = Provider.of<ContactStore>(context, listen: false);

    if (_isInitialLoad) {
      _contactStore.fetchContacts();
      _isInitialLoad = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 80),
            Text(
              'Contatos',
              style: TextStyle(
                color: Colors.deepPurple[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        iconTheme: IconThemeData(color: Colors.deepPurple[400]),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1 + 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(color: Colors.deepPurple[400], height: 1, width: 350),

              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, 'addContactScreen');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      Text(
                        '+ Adicionar',
                        style: TextStyle(
                          color: Colors.deepPurple[400],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              _contactStore.fetchContacts();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: Observer(
        builder: (context) {
          if (_contactStore.contacts.isEmpty) {
            return const Center(child: Text('Nenhum contato encontrado.'));
          }

          return ListView.builder(
            itemCount: _contactStore.contacts.length,
            itemBuilder: (context, index) {
              final contact = _contactStore.contacts[index];
              
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    'contactDetail',
                    arguments: contact.id,
                  );
                },

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '${contact.title}',
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(
                            '${contact.number}',
                            style: TextStyle(fontSize: 17),
                          ),
                          PreferredSize(
                            preferredSize: Size.fromHeight(1),
                            child: Container(
                              color: Colors.black,
                              height: 1,
                              width: 350,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
