import 'package:app_lecocon_ssbe/ui/theme.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/bloc/add_user_bloc.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/bloc/add_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../comon/widgets/buttoms/custom_buttom.dart';
import '../../../../comon/widgets/inputs/custom_text_field.dart';
import '../bloc/add_user_event.dart';

class AddUserView extends StatelessWidget {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  AddUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddUserBloc, AddUserState>(
      builder: (context, state) {
        if (state is AddUserSignUpLoadingState) {
          return const SizedBox(
              width: 60, height: 60, child: CircularProgressIndicator());
        } else if (state is AddUserSignUpErrorState) {
          return Text(state.error);
        } else {
          return _buildForm(context);
        }
      },
    );
  }

  Widget _buildForm(BuildContext context) {
    return  Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Text(
                "Inscription",
                style: titleStyleMedium(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 40.0,
                runSpacing: 20.0, children: [
                CustomTextField(
                    labelText: 'NOM', controller: userNameController),

                const SizedBox(height: 25),

                CustomTextField(
                    labelText: 'E-mail', controller: emailController),

                const SizedBox(height: 25),
                CustomTextField(
                  labelText: 'Mot de passe',
                  controller: passwordController,
                  obscureText: true,
                ),
              ],
              ),
              const SizedBox(height: 25),
              CustomButton(
                onPressed: () async {
                  try {
                    String firstNameInput = userNameController.text.trim();

                    debugPrint('valeur de firstName $firstNameInput');

                    context.read<AddUserBloc>().add(
                     AddUserSignUpEvent(
                          id: '',
                          userName: userNameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                     ),
                     );
                  } catch (error) {
                    debugPrint('Erreur données non transmise: $error');
                  }
                },
                label: "S'inscrire",
              ),
              const SizedBox(
                height: 25,
              ),
              TextButton(
                  onPressed: () => context.go('/account/login'),
                  child: Text(
                    "Connexion",
                    style: textStyleText(context),
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
    );
  }
}
