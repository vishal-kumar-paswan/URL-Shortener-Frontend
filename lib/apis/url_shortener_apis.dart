import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/shorten_url.dart';

class URLShortenerAPI {
  static const url = "https://tinylink-io.vercel.app/";

  static Future<ShortenUrlModel> createShortUrl(String mainUrl) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'url': mainUrl}),
    );
    if (response.statusCode == 200) {
      return ShortenUrlModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to shorten url');
    }
  }
}
