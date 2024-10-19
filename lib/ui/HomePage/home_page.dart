import 'package:app_lecocon_ssbe/ui/comon/widgets/buttoms/custom_buttom.dart';
import 'package:app_lecocon_ssbe/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          'Bienvenue sur le cocon',
                          style: titleStyleLarge(context),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                       CustomButton(
                          onPressed: () => context.go('/account/inscription'),
                          label:
                            'Créer un compte',
                          ),

                        const SizedBox(height: 30),
                        CustomButton(
                          onPressed: () => context.go('/account/login'),
                          label:
                            'Connexion',
                        ),
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