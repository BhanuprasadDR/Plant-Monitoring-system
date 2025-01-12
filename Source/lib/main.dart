import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_health_cse/ui_page.dart';
import 'package:provider/provider.dart';

import 'ml/common/global_context.dart';
import 'ml/screens/home_screen.dart';
import 'ml/providers/disease_provider.dart';

import 'ml/screens/home_screen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Color(0xffedf3fa)),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return ChangeNotifierProvider(
      create: (context) => DiseaseProvider(),
      child: NeumorphicApp(
        title: 'Flutter Example',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: NeumorphicThemeData(
          baseColor: const Color(0xffedf3fa),
          lightSource: LightSource.topLeft,
          shadowLightColor: Colors.white,
          textTheme: GoogleFonts.notoSansTextTheme(),
          shadowDarkColor: const Color.fromARGB(255, 192, 205, 220),
          iconTheme: const IconThemeData(color: Color(0xff112a42)),
          defaultTextColor: const Color(0xff112a42),
          appBarTheme: const NeumorphicAppBarThemeData(
            centerTitle: true,
            buttonStyle: NeumorphicStyle(depth: 5),
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xff112a42),
            ),
          ),
          buttonStyle: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(15),
            ),
          ),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
          intensity: .9,
          depth: 4,
        ),
        home: UiPage(),
      ),
    );
  }
}
