import 'package:app_lecocon_ssbe/theme.dart';
import 'package:app_lecocon_ssbe/core/router/router_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'core/di/di.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configure toutes les dépendances
  configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouterConfig = GetIt.I<AppRouterConfig>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Le cocon.ssbe',
      theme: theme,
      routerConfig: appRouterConfig.router,
    );
  }
}
