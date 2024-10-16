import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/add_user_bloc.dart';
import '../bloc/add_user_event.dart';
import '../bloc/add_user_state.dart';

class AddUserView extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AddUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un compte')),
      body: BlocConsumer<AddUserBloc, AddUserState>(
        listener: (context, state) {
          if (state is AddUserSignUpLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Compte créé avec succès!')),
            );
            Navigator.of(context).pushReplacementNamed('/login');
          } else if (state is AddUserSignUpFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur: $AddUserSignUpErrorState')),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: userNameController,
                    decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  if (state is AddUserSignUpLoadingState)
                    CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () {
                        context.read<AddUserBloc>().add(
                          AddUserSignUpEvent(
                            userName: userNameController.text,
                            email: emailController.text,
                            password: passwordController.text, id: '',
                          ),
                        );
                      },
                      child: const Text('Créer le compte'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}