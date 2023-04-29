import 'package:flutter/material.dart';
import 'package:url_shortener_frontend/views/mobile/about.dart';
import 'dart:js' as js;
import '../../apis/url_shortener_apis.dart';
import '../../models/shorten_url.dart';
import '../mobile/about.dart';
import '../../constants.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});
  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<ShortenUrlModel>? _shortenUrl;
  var isVisible = true;

  void _fetchshortenUrl() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isVisible = false;
      });
      _shortenUrl = URLShortenerAPI.createShortUrl(_urlController.text);
    }
    _urlController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const About(),
                  ),
                );
              },
              child: const Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  color: Constants.accentColor,
                  fontWeight: FontWeight.w400,
                ),
              ))
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'tinylink.io',
              style: TextStyle(
                color: Constants.accentColor,
                fontSize: 45,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Visibility(
                visible: isVisible,
                replacement: FutureBuilder(
                  future: _shortenUrl,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return InkWell(
                        onTap: () {
                          js.context.callMethod(
                              'open', ['https://${snapshot.data!.shortenUrl}']);
                        },
                        child: Text(
                          snapshot.data!.shortenUrl,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.blue.shade800,
                            fontSize: 21,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator(
                      color: Constants.accentColor,
                    );
                  },
                ),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _urlController,
                    decoration: const InputDecoration(
                      hintText: 'Paste your link here :)',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.accentColor),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.accentColor),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a url';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 17),
            Visibility(
              visible: isVisible,
              replacement: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isVisible = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 38.0,
                    vertical: 18.0,
                  ),
                  backgroundColor: Constants.accentColor,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              child: ElevatedButton(
                onPressed: _fetchshortenUrl,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 38.0,
                    vertical: 18.0,
                  ),
                  backgroundColor: Constants.accentColor,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Create Link',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
