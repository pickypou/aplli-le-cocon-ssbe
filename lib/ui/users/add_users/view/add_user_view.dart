import 'package:app_lecocon_ssbe/theme.dart';
import 'package:app_lecocon_ssbe/ui/common/widgets/buttoms/custom_buttom.dart';
import 'package:app_lecocon_ssbe/ui/common/widgets/inputs/custom_text_field.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/add_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../add_user_bloc.dart';
import '../add_user_event.dart';

class AddUserView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();

  AddUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddUserBloc, AddUserState>(builder: (context, state) {
      if (state is SignUpLoadingState) {
        return const SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(),
        );
      } else if (state is SignUpErrorState) {
        return Text(state.error);
      } else {
        return _buildForm(context);
      }
    });
  }

  Widget _buildForm(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    if (size.width < 749) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Inscripion'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop(); // Revenir à la page précédente
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_cocon.png',
                  fit: BoxFit.contain,
                  width: size.width / 2,
                ),
                const SizedBox(
                  height: 35,
                ),
                Text(
                  'Je crée un compte',
                  style: titleStyleLarge(context),
                ),
                const SizedBox(
                  height: 35,
                ),
                CustomTextField(
                  labelText: 'Email',
                  maxLines: 1,
                  controller: emailController,
                ),
                const SizedBox(
                  height: 35,
                ),
                CustomTextField(
                  labelText: 'Mot de passe',
                  maxLines: 1,
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 35,
                ),
                CustomTextField(
                  labelText: 'Prénom',
                  maxLines: 1,
                  controller: userNameController,
                ),
                const SizedBox(
                  height: 35,
                ),
                CustomButton(
                    onPressed: () {
                      context.read<AddUserBloc>().add(AddUserSignUpEvent(
                          id: '',
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          userName: userNameController.text,
                          navigateToAccount: () =>
                              GoRouter.of(context).go('/account')));
                    },
                    label: 'Je valide mon compte')
              ],
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(title: const Text('Inscripion')),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_cocon.png',
                  fit: BoxFit.contain,
                  width: size.width / 4,
                ),
                const SizedBox(
                  height: 35,
                ),
                Text(
                  'Je crée un compte',
                  style: titleStyleLarge(context),
                ),
                const SizedBox(
                  height: 35,
                ),
                CustomTextField(
                  labelText: 'Email',
                  maxLines: 1,
                  controller: emailController,
                ),
                const SizedBox(
                  height: 35,
                ),
                CustomTextField(
                  labelText: 'Mot de passe',
                  maxLines: 1,
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 35,
                ),
                CustomTextField(
                  labelText: 'Prénom',
                  maxLines: 1,
                  controller: userNameController,
                ),
                const SizedBox(
                  height: 35,
                ),
                CustomButton(
                    onPressed: () {
                      context.read<AddUserBloc>().add(AddUserSignUpEvent(
                          id: '',
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          userName: userNameController.text,
                          navigateToAccount: () =>
                              GoRouter.of(context).go('/account')));
                    },
                    label: 'Je valide mon compte')
              ],
            ),
          )));
    }
  }
}
