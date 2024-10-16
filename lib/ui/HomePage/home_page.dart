import 'package:app_lecocon_ssbe/ui/comon/router/router_config.dart';
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
            Image.asset('assets/images/logo_cocon.png',
            fit: BoxFit.contain,width: size.width / 2,),
            const SizedBox(height: 25,),
            Text('Bienvenue sur le cocon', style: titleStyleMedium(context).copyWith(fontSize: size.width/8),),
            const SizedBox(height: 20,),
            TextButton(
                onPressed: ()=> context.go('/account/inscription'),
                child: Text('Créer un compte',style: textStyleText(context).copyWith(fontSize:size.width/18 ),
                ),
            )
          ],
        ),
      ),
    );
  }
}
