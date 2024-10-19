import 'package:app_lecocon_ssbe/ui/add_evenement/view/add_evenements_view.dart';
import 'package:app_lecocon_ssbe/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../main.dart';

class AddEvenementsPage extends StatelessWidget {
  const AddEvenementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evénements'),
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Je crée un événement',
                          style: titleStyleLarge(context),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50),
                        Image.asset(
                          'assets/images/logo_cocon.png',
                          fit: BoxFit.contain,
                          width: constraints.maxWidth / 2,
                        ),
                        const SizedBox(height: 50),
                        const Expanded(child: AddEvenementView())
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}