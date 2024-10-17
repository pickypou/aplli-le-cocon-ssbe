import 'package:app_lecocon_ssbe/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../comon/widgets/buttoms/custom_buttom.dart';
import '../../../comon/widgets/inputs/custom_text_field.dart';
import '../bloc/user_login_bloc.dart';
import '../bloc/user_login_event.dart';
import '../bloc/user_login_state.dart';


class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();



  LoginView({super.key, });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocConsumer<UserLoginBloc, UserLoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Erreur de connexion"),
              content: Text(state.error),
              actions: [
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
        // Ajoutez d'autres réactions pour différents états si nécessaire
      },
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(title: const Text('Connexion')),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.center, // Centrer le texte
                  child: Text(
                    'Connexion',
                    style: titleStyleLarge(context),
                  ),
                ),


                const SizedBox(height: 40),
                CustomTextField(
                  labelText: 'E-mail',
                  controller: emailController,
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  labelText: 'Mot de passe',
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  child: CustomButton(
                    label: 'Connexion',
                    onPressed: () {
                      BlocProvider.of<UserLoginBloc>(context).add(
                        LoginWithEmailPassword(
                            email: emailController.text,
                            password: passwordController.text,
                            navigateToAccount: ()  {
                              GoRouter.of(context).go('/account');


                            }),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => context.go('/account/inscription'),

                        child: Text(
                          "Créer un compte",
                          style: textStyleText(context).copyWith(fontSize: size.width/30)),
                        ),
                      ),

                    Expanded(
                      child: TextButton(
                        onPressed: () => context.go('/account/ResetPassword'),

                        child: Text(
                          "Mot de passe oublié?",
                          style: textStyleText(context).copyWith(fontSize: size.width/30)),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
