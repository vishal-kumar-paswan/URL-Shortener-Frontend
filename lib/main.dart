import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';
import 'views/desktop/desktop.dart';
import 'views/mobile/mobile.dart';
import 'views/tablet/tablet.dart';

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
          if (constraints.maxWidth <= 640) {
            return const Mobile();
          } else if (constraints.maxWidth <= 1280) {
            return const Tablet();
          } else {
            return const Desktop();
          }
        },
      ),
    );
  }
}
