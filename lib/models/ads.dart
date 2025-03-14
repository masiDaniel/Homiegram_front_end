class Ad {
  late String title;
  late String description;
  final String? imageUrl;
  final String? videoUrl;

  Ad(
      {this.imageUrl,
      this.videoUrl,
      required this.title,
      required this.description});

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
        imageUrl: json['image'] as String?,
        videoUrl: json['video_file'] as String?,
        title: json['title'] as String,
        description: json['description'] as String);
  }
}

class AdRequest {
  final String? title;
  final String? description;
  final String? startDate;
  final String? endDate;

  AdRequest(
      {this.title,
      this.description,
      this.startDate,
      this.endDate,
      String? message});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'start_date': startDate, // Ensures it's properly formatted
      'end_date': endDate,
    };
  }

  factory AdRequest.fromJson(Map<String, dynamic> json) {
    return AdRequest(
      message: json['message'] as String?,
    );
  }
}
