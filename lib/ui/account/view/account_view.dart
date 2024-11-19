import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/access_checker.dart';
import '../../../theme.dart';
import '../../common/widgets/buttoms/custom_buttom.dart';

class AccountView extends StatefulWidget {
  final Map<String, dynamic> userData;

  const AccountView({super.key, required this.userData});

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  bool isAdmin = false; // Par défaut, l'utilisateur n'est pas admin
  bool isLoading = true; // Indique si la vérification est en cours

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
  }

  Future<void> _checkAdminAccess() async {
    final hasAdminAccess = await hasAccess(); // Appelle la fonction asynchrone
    setState(() {
      isAdmin = hasAdminAccess;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = GetIt.instance<FirebaseAuth>();

    if (isLoading) {
      // Affiche un indicateur de chargement pendant la vérification
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mon Compte'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          // Ajout de marges latérales
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // Étirer les enfants sur toute la largeur
            children: [
              const SizedBox(height: 20),
              Text(
                "Bonjour ${widget.userData['userName']} ",
                style: titleStyleLarge(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35),
              Image.asset(
                'assets/images/logo_cocon.png',
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              const SizedBox(height: 90),
              if (isAdmin) ...[
                CustomButton(
                  label: 'Je crée un événement',
                  onPressed: () {
                    GoRouter.of(context).go('/evenement');
                  },
                ),
                const SizedBox(height: 50),
                CustomButton(
                  label: 'Je crée un avis client',
                  onPressed: () {
                    GoRouter.of(context).go('/addAvisClients');
                  },
                ),
                const SizedBox(height: 50),
                CustomButton(
                  label: 'Je supprime un événement',
                  onPressed: () {
                    GoRouter.of(context).go('/evenementList');
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
