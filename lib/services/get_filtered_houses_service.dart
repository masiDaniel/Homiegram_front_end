import 'package:homi_2/models/amenities.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

late Future<List<GetHouse>> futureHouses;
late Future<List<Amenities>> futureAmenities;
String _selectedLocation = 'All Locations';
final List<String> _locations = [
  'All Locations',
  'Devki',
  'Nairobi - CBD',
  'Machakos'
];

final double _minPrice = 0;
double _maxPrice = 1000;
final List<String> _selectedAmenities = [];
final List<String> _amenities = [];

Future<List<GetHouse>> fetchFilteredHouses() async {
  String apiUrl = '$azurebaseUrl/api/houses/filter';

  // Prepare the filter parameters
  Map<String, dynamic> filterParams = {
    'location': _selectedLocation,
    'min_price': _minPrice,
    'max_price': _maxPrice,
    'amenities': _selectedAmenities,
  };

  // Send the request to the API
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(filterParams),
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => GetHouse.fromJSon(data)).toList();
  } else {
    throw Exception('Failed to load houses');
  }
}
