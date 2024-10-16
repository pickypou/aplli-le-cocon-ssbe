import 'package:app_lecocon_ssbe/ui/HomePage/home_page.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class ViewAll extends StatelessWidget {
  const ViewAll({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
        color: theme.primaryColor,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Expanded(child:
            HomePage()
        )
          ],
        ),
      ),
    );
  }
}
