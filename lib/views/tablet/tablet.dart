import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:url_shortener_frontend/views/about.dart';
import '../../apis/url_shortener_apis.dart';
import '../../models/shorten_url.dart';
import '../../constants.dart';

class Tablet extends StatefulWidget {
  const Tablet({super.key});
  @override
  State<Tablet> createState() => _TabletState();
}

class _TabletState extends State<Tablet> {
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
            SizedBox(
              width: 610,
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
                                  text: 'https://${snapshot.data!.shortenUrl}'),
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
                              fontSize: 18,
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
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Constants.accentColor,
                      ),
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
