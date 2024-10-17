import 'package:app_lecocon_ssbe/main.dart';
import 'package:app_lecocon_ssbe/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: theme.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_cocon.png',
              fit: BoxFit.contain,
              width: size.width / 1.6,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Bienvenue sur le cocon',
              style:
                  titleStyleLarge(context),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () => context.go('/account/inscription'),
              child: Text(
                'Créer un compte',
                style:
                    textStyleText(context)//.copyWith(fontSize: size.width / 18),
              ),
            ),
            TextButton(
              onPressed: () => context.go('/account/login'),
              child: Text(
                'Connexion',
                style:
                    textStyleText(context).copyWith(fontSize: size.width / 18),
              ),
            ),
            IconButton(
          icon: const Icon(Icons.logout,color: Colors.red,),
                onPressed: (){
                  auth.signOut().then((_){
                    debugPrint('Déconnexion réussie');
                    context.go('/');
                  });
                },
                )
          ],
        ),
      ),
    );
  }
}
