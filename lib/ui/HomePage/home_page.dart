import 'package:app_lecocon_ssbe/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/check_user_connection.dart';
import '../comon/widgets/buttoms/custom_buttom.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = GetIt.instance<FirebaseAuth>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              auth.signOut().then((_) {
                debugPrint('Déconnexion réussie');
                context.go('/');
              });
            },
          )
        ],
      ), // Ajoutez une AppBar si nécessaire
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Container(
                  width: constraints.maxWidth,
                  color: theme.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Image.asset(
                            'assets/images/logo_cocon.png',
                            fit: BoxFit.contain,
                            width: constraints.maxWidth / 2,
                          ),
                        ),
                        const SizedBox(height: 70),
                        Text(
                          'Bienvenue sur l\'aplication',
                          style: titleStyleLarge(context),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Du Cocon SSBE',
                          style: titleStyleLarge(context),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          onPressed: () {
                            checkUserConnection(context);
                          },
                          label: 'Connexion',
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
