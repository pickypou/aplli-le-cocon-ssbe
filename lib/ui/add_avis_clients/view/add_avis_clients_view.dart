import 'package:app_lecocon_ssbe/ui/add_avis_clients/bloc/avis_clients_bloc.dart';
import 'package:app_lecocon_ssbe/ui/add_avis_clients/bloc/avis_clients_event.dart';
import 'package:app_lecocon_ssbe/ui/add_avis_clients/bloc/avis_clients_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';
import '../../comon/widgets/buttoms/custom_buttom.dart';
import '../../comon/widgets/inputs/custom_text_field.dart';
import '../../../theme.dart';

class AddAvisClientsView extends StatelessWidget {
  final TextEditingController categoriesController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final TextEditingController publishDateController = TextEditingController();


  AddAvisClientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<AddAvisClientsBloc, AddAvisClientsState>(
        builder: (context, state) {
          if (state is AddAvisClientsSignUpLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AddAvisClientsSignUpErrorState) {
            return Text(state.error);
          } else if (state is AddAvisClientsSignUpSuccessState) {
            return _buildForm(context, state.addAvisClientsId);
          } else {
            return _buildForm(context, '');
          }
        },
      );
  }

  Widget _buildForm(BuildContext context, String adherentId) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        appBar: AppBar(title: const Text('Mon Compte'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout), color: Theme
                .of(context)
                .colorScheme
                .secondary,
              onPressed: () {
                auth.signOut().then((_) {
                  debugPrint('Déconnexion réussie');
                  context.go('/');
                });
              },
            )
          ],
        ), // Ajoutez une AppBar si nécessaire
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    Text(
                      'Ajouter un commenter',
                      style: titleStyleLarge(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Image.asset('assets/images/logo_cocon.png', fit: BoxFit.contain,width: size.width/1.6),
                    const SizedBox(height: 40),
                    Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 40.0,
                        runSpacing: 20.0,
                        children: [
                          CustomTextField(
                            labelText: 'Catégories',
                            controller: categoriesController, maxLines: 1,
                          ),
                          const SizedBox(width: 40),
                          CustomTextField(
                            labelText: 'Date du jour',
                            controller: publishDateController, maxLines: 1,
                          ),
                          CustomTextField(
                            labelText: 'mon commenter',
                            controller: textController,
                            maxLines: 5,
                          ),
                          const SizedBox(height: 20),


                CustomButton(
                  onPressed: () {
                    try {
                      DateFormat format = DateFormat('dd/MM/yyyy');
                      DateTime publishDate = format.parse(publishDateController.text);

                      context.read<AddAvisClientsBloc>().add(
                        AddAvisClientsSignUpEvent(
                          id: 'someId',
                          categories: categoriesController.text,
                          text: textController.text,
                          publishDate: publishDate,  // DateTime au lieu de la chaîne
                          navigateToAccount: () => GoRouter.of(context).go('/account'),
                        ),
                      );
                    } catch (e) {
                      debugPrint('Erreur de format de date : $e');
                    }
                  },
                  label: 'Je poste mon avis',
                )



                ]
                    ),
                  ]
              ),
            )
        )
    );
  }
}
