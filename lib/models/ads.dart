class Ad {
  final String? imageUrl;
  final String? videoUrl;

  Ad({this.imageUrl, this.videoUrl});

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      imageUrl: json['image'] as String?,
      videoUrl: json['video_file'] as String?,
    );
  }
}
