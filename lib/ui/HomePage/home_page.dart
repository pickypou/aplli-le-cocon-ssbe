import 'package:app_lecocon_ssbe/ui/theme.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        width: size.width,
        color: theme.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo_cocon.png'),
            const SizedBox(height: 25,),
            Text('Bienvenue sur le cocon', style: titleStyleMedium(context),)
          ],
        ),
      ),
    );
  }
}
