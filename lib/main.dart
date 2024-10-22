import 'package:app_lecocon_ssbe/core/di/di.dart';
import 'package:app_lecocon_ssbe/data/repository/repository_module.dart';
import 'package:app_lecocon_ssbe/domain/domain_module.dart';
import 'package:app_lecocon_ssbe/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'ui/comon/router/router_config.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
void main() async {
  setupDataModule();
  setupDomainModule();
  configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Vérifier si un utilisateur est connecté
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    debugPrint('Utilisateur déjà connecté: ${currentUser.email}');
  } else {
    debugPrint('Aucun utilisateur connecté.');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Le cocon.ssbe',
      theme: theme,
      routerConfig: goRouter,
    );
  }
}