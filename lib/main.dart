import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';
import 'views/desktop/homepage.dart';
import 'views/mobile/homepage.dart';

void main() {
  runApp(const URLShortener());
}

class URLShortener extends StatelessWidget {
  const URLShortener({super.key});

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
      home: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth <= 480) {
            return const MobileHomePage();
          } else {
            return const DesktopHomePage();
          }
        },
      ),
    );
  }
}
