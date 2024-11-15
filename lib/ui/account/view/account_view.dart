import 'package:app_lecocon_ssbe/ui/comon/widgets/buttoms/custom_buttom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../theme.dart';

class AccountView extends StatelessWidget {
  final Map<String, dynamic> userData;

  const AccountView({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final auth = GetIt.instance<FirebaseAuth>();
    return Scaffold(
        // Ajoutez le Scaffold ici
        appBar: AppBar(
          title: const Text('Mon Compte'),
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
        body: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bonjour ${userData['userName']} ",
                  style: titleStyleLarge(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 35,
                ),
                Image.asset(
                  'assets/images/logo_cocon.png',
                  fit: BoxFit.contain,
                  width: size.width / 1.6,
                ),
                const SizedBox(
                  height: 90,
                ),
                CustomButton(
                    label: 'Je crée un événement',
                    onPressed: () {
                      GoRouter.of(context).go('/evenement');
                    }),
                const SizedBox(
                  height: 50,
                ),
                CustomButton(
                    label: 'Je crée un avis client',
                    onPressed: () {
                      GoRouter.of(context).go('/addAvisClients');
                    }),
                CustomButton(
                  label: 'je supprime un événement',
                  onPressed: () {
                    GoRouter.of(context).go('/evenementList');
                  },
                )
              ],
            ),
          ),
        ));
  }
}
