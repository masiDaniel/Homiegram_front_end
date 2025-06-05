class Amenities {
  final int? Id;
  final String? name;

  Amenities({
    this.Id,
    this.name,
  });

  factory Amenities.fromJSon(Map<String, dynamic> json) {
    return Amenities(
      Id: json['id'],
      name: json['name'],
    );
  }
}
