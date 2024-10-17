import 'package:app_lecocon_ssbe/ui/comon/widgets/buttoms/custom_buttom.dart';
import 'package:app_lecocon_ssbe/ui/comon/widgets/inputs/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/add_user_bloc.dart';
import '../bloc/add_user_event.dart';
import '../bloc/add_user_state.dart';

class AddUserView extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AddUserView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un compte')),
      body: BlocConsumer<AddUserBloc, AddUserState>(
        listener: (context, state) {
          if (state is AddUserSignUpSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Compte créé avec succès!')),
            );
            Navigator.of(context).pushReplacementNamed('/login');
          } else if (state is AddUserSignUpErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          if (state is AddUserSignUpLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
          child:
            Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo_cocon.png',
                    fit: BoxFit.contain,
                    width: size.width / 2,
                  ),
                  const SizedBox(height: 35),
                  CustomTextField(
                    controller: userNameController,
                    labelText: 'Prénom',
                  ),
                  const SizedBox(height: 35),
                  CustomTextField(
                    controller: emailController,
                    labelText: 'Email',
                  ),
                  const SizedBox(height: 35),
                  CustomTextField(
                    controller: passwordController,
                    labelText: 'Mot de passe',
                    obscureText: true,
                  ),
                  const SizedBox(height: 35),
                  CustomButton(
                    onPressed: () {
                      context.read<AddUserBloc>().add(
                        AddUserSignUpEvent(
                          userName: userNameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          id: '',
                          navigateToAccount: () =>
                          GoRouter.of(context).go('/account'),
                        ),
                      );
                    },
                    label: 'Créer le compte',
                  ),
                ],
              ),
            ),
            )
          );
        },
      ),
    );
  }
}
