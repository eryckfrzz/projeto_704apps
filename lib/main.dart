import 'package:flutter/material.dart';
import 'package:projeto_704apps/my_app.dart';
import 'package:projeto_704apps/stores/contact_store.dart';
import 'package:projeto_704apps/stores/user_store.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<UserStore>(create: (context) => UserStore()),
        Provider<ContactStore>(create: (context) => ContactStore()),
      ],
      child: const MyApp(),
    ),
  );
}
