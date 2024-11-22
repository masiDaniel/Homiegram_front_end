class GetRooms {
  final int roomId;
  final int noOfBedrooms;
  final String sizeInSqMeters;
  final String rentAmount;
  final bool occuiedStatus;
  final String roomImages;
  final int apartmentID;
  final int tenantId;
  final bool rentStatus;

  GetRooms(
      {required this.roomId,
      required this.noOfBedrooms,
      required this.sizeInSqMeters,
      required this.rentAmount,
      required this.occuiedStatus,
      required this.roomImages,
      required this.apartmentID,
      required this.tenantId,
      required this.rentStatus});

  factory GetRooms.fromJSon(Map<String, dynamic> json) {
    return GetRooms(
        roomId: json['id'] ?? 0,
        noOfBedrooms: json['number_of_bedrooms'] ?? 0,
        sizeInSqMeters: json['user_id'] ?? '',
        rentAmount: json['rent'] ?? '',
        occuiedStatus: json['occuiedStatus'] ?? false,
        roomImages: json['room_images'] ?? '',
        apartmentID: json['apartment'] ?? 0,
        tenantId: json['tenant'] ?? 0,
        rentStatus: json['rent_status'] ?? false);
  }

  Map<String, dynamic> tojson() {
    return {
      "id": roomId,
      "number_of_bedrooms": noOfBedrooms,
      "user_id": sizeInSqMeters,
      "rentAmount": rentAmount,
      "occuiedStatus": occuiedStatus,
      "nested_id": roomImages,
      "apartment": apartmentID,
      "tenant": tenantId,
      'rent_status': rentStatus
    };
  }
}
