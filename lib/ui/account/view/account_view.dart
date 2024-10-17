import 'package:app_lecocon_ssbe/ui/comon/widgets/buttoms/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../main.dart';
import '../../theme.dart';
import '../../users/login/bloc/user_login_bloc.dart';
import '../../users/login/bloc/user_login_event.dart';


class AccountView extends StatelessWidget {
  final Map<String, dynamic> userData;

  const AccountView({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold( // Ajoutez le Scaffold ici
      appBar: AppBar(title: const Text('Mon Compte'),
      actions: [
        IconButton(
          icon:  const Icon(Icons.logout),color: Theme.of(context).colorScheme.secondary,
          onPressed: (){
            auth.signOut().then((_){
              debugPrint('Déconnexion réussie');
              context.go('/');
            });
          },
        )
      ],
      ), // Ajoutez une AppBar si nécessaire
      body: SizedBox(
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
            const SizedBox(height: 35,),
            Image.asset('assets/images/logo_cocon.png', fit: BoxFit.contain,width: size.width/1.6,),
            const SizedBox(height: 90,),

                CustomButton(
                    label: 'Je crée un événement',
                    onPressed: (){}),
                const SizedBox(height: 50,),
                CustomButton(
                    label: 'Je crée un avis client',
                    onPressed: (){}),
          ],
        ),
      ),
    );
  }
}


