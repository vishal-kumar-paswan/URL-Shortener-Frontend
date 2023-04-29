class ShortenUrlModel {
  final String shortenUrl;

  ShortenUrlModel({required this.shortenUrl});

  factory ShortenUrlModel.fromJson(Map<String, dynamic> json) {
    return ShortenUrlModel(
      shortenUrl: json['shortenURL'],
    );
  }
}
