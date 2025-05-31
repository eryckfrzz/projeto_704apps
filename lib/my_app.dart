import 'package:flutter/material.dart';
import 'package:projeto_704apps/screens/contacts/add_contact_screen.dart';
import 'package:projeto_704apps/screens/contacts/contact_detail_screen.dart';
import 'package:projeto_704apps/screens/contacts/contacts_list.dart';
import 'package:projeto_704apps/screens/contacts/edit_contact_screen.dart';
import 'package:projeto_704apps/screens/users/add_user_screen.dart';
import 'package:projeto_704apps/screens/users/edit_user_screen.dart';
import 'package:projeto_704apps/screens/home.dart';
import 'package:projeto_704apps/screens/users/user_detail_screen.dart';
import 'package:projeto_704apps/screens/users/users_list.dart';
import 'package:projeto_704apps/screens/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginScreen(),
        'home': (context) => Home(),
        'usersList': (context) => UsersList(),
        'addUserScreen': (context) => AddUserScreen(),
        'contactsList': (context) => ContactsList(),
        'addContactScreen': (context) => AddContactScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == 'userDetail') {
          final userId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => UserDetailScreen(userId: userId),
          );
        } else if (settings.name == 'editUser') {
          final userId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) {
              return EditScreen(userId: userId);
            },
          );
        } else if (settings.name == 'contactDetail') {
          final contactId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) {
              return ContactDetailScreen(contactId: contactId);
            },
          );
        } else if (settings.name == 'editContact') {
          final contactId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) {
              return EditContactScreen(contactId: contactId);
            },
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
