class Amenities {
  final int? locationId;
  final String? name;

  Amenities({
    this.locationId,
    this.name,
  });

  factory Amenities.fromJSon(Map<String, dynamic> json) {
    return Amenities(
      locationId: json['id'],
      name: json['name'],
    );
  }
}
