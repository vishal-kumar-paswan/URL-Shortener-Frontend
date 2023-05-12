import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import '../../apis/url_shortener_apis.dart';
import '../../models/shorten_url.dart';
import '../../constants.dart';

class Desktop extends StatefulWidget {
  const Desktop({super.key});

  @override
  State<Desktop> createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  final _urlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var isVisible = true;

  Future<ShortenUrlModel>? _shortenUrl;

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
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Transform.scale(
                scale: 0.79,
                child: Lottie.asset('assets/link.json'),
              ),
              const Text(
                'Create a tiny link\nwithin seconds',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 43,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'tinylink.io',
                  style: TextStyle(
                    color: Constants.accentColor,
                    fontSize: 55,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  child: Visibility(
                    visible: isVisible,
                    replacement: FutureBuilder(
                      future: _shortenUrl,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            height: 50,
                            width: double.infinity,
                            decoration: ShapeDecoration(
                              color: Colors.grey.shade50,
                              shape: const StadiumBorder(
                                side: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            child: ListTile(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(
                                      text:
                                          'https://${snapshot.data!.shortenUrl}'),
                                );
                                Toast.show(
                                  'Link copied to clipboard',
                                  duration: Toast.lengthLong,
                                  gravity: Toast.bottom,
                                );
                              },
                              title: Text(
                                snapshot.data!.shortenUrl,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade700,
                                  fontSize: 22,
                                ),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(Icons.copy_outlined),
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
                            borderSide:
                                BorderSide(color: Constants.accentColor),
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.accentColor),
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
                const SizedBox(height: 30),
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
                        horizontal: 40.0,
                        vertical: 20.0,
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
                        horizontal: 40.0,
                        vertical: 20.0,
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
          )
        ],
      ),
    );
  }
}
