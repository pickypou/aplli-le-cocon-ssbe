import 'package:flutter/material.dart';

import '../../theme.dart';


class AccountView extends StatelessWidget {
  final Map<String, dynamic> userData;

  const AccountView({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        children: [
          Text(
            "Bienvenue sur votre espace",
            style: titleStyleMedium(context),
            textAlign: TextAlign.center,
          ),
          ListTile(
            title: const Text('Nom: ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(userData['userName'] ?? 'Not available'),
          ),

        ],
      ),
    );
  }
}
