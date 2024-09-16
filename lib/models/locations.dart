class Locations {
  final int? locationId;
  final String? county;
  final String? town;
  final String? area;
  // final String? token;

  Locations({this.locationId, this.county, this.town, this.area});

  factory Locations.fromJSon(Map<String, dynamic> json) {
    return Locations(
      locationId: json['id'],
      county: json['county'],
      town: json['town'],
      area: json['area'],
    );
  }
}
