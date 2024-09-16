class Rate {
  final int? rating;
  final String? comment;

  // final String? token;

  Rate({
    this.rating,
    this.comment,
  });

  factory Rate.fromJSon(Map<String, dynamic> json) {
    return Rate(
      rating: json['rating'],
      comment: json['comment'],
    );
  }
}
