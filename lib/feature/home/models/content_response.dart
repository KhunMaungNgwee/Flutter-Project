class ContentResponse {
  final String content_Name;
  final String wordDescription;
  final String pictureBackground;

  ContentResponse(
      {required this.content_Name,
      required this.wordDescription,
      required this.pictureBackground});

  factory ContentResponse.fromJson(Map<String, dynamic> json) {
    return ContentResponse(
      content_Name: json['content_Name'] as String,
      wordDescription: json['wordDescription'] as String,
      pictureBackground: json['pictureBackground'] as String,
    );
  }
}
