import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_704apps/stores/contact_store.dart';
import 'package:projeto_704apps/stores/user_store.dart';
import 'package:provider/provider.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    final userStore = Provider.of<UserStore>(context);

    final contactStore = Provider.of<ContactStore>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 50),
            Text(
              'Configuração',
              style: TextStyle(
                color: Colors.deepPurple[400],
                fontWeight: FontWeight.bold,
                fontSize: 25
              ),
            ),
          ],
        ),

        iconTheme: IconThemeData(color: Colors.deepPurple[400]),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: Colors.deepPurple[400],
            height: 1,
            width: 350,
          ),
        ),
      ),

      body: Observer(
        builder:
            (_) => Container(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap:
                              () =>
                                  Navigator.pushNamed(context, 'profile'),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.deepPurple[100],

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 7),
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            width: 100,
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.deepPurple[400],
                                ),
                                SizedBox(height: 15),

                                Text(
                                  'Perfil',
                                  style: TextStyle(
                                    fontSize: 15,

                                    color: Colors.deepPurple[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'usersList');
                            userStore.getUsers();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.deepPurple[100],

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 7),
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            width: 100,
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  size: 50,
                                  color: Colors.deepPurple[400],
                                ),
                                SizedBox(height: 15),

                                Text(
                                  'Incidentes',
                                  style: TextStyle(
                                    fontSize: 15,

                                    color: Colors.deepPurple[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'contactsList');
                            userStore.getUsers();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.deepPurple[100],

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 7),
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            width: 100,
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications,
                                  size: 50,
                                  color: Colors.deepPurple[400],
                                ),
                                SizedBox(height: 15),

                                Text(
                                  'Contatos',
                                  style: TextStyle(
                                    fontSize: 15,

                                    color: Colors.deepPurple[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
