import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/flight_model.dart';

class FlightSearchController extends GetxController {
  var fromCity = ''.obs;
  var toCity = ''.obs;
  var travelDate = ''.obs;
  var returnDate = ''.obs;
  var travellers = '1'.obs;
  var travelClass = 'Economy Class'.obs;

  var searchResults = <Flight>[].obs;
  var isSearching = false.obs;

  Flight? selectedFlight;

  Future<bool> searchFlights() async {
    isSearching.value = true;
    try {
      final uri = Uri.parse('http://10.0.2.2:3000/api/flights/search').replace(
        queryParameters: {
          if (fromCity.value.isNotEmpty) 'from': fromCity.value,
          if (toCity.value.isNotEmpty) 'to': toCity.value,
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> flightsJson = data['flights'];
        searchResults.value = flightsJson.map((f) => Flight.fromJson(f)).toList();
        return true;
      } else {
        searchResults.value = [];
        return false;
      }
    } catch (e) {
      searchResults.value = [];
      return false;
    } finally {
      isSearching.value = false;
    }
  }
}