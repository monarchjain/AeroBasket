import 'package:get/get.dart';
import '../models/flight_model.dart';

class FlightSearchController extends GetxController {
  // search form values, filled in by Homepage
  var fromCity = ''.obs;
  var toCity = ''.obs;
  var travelDate = ''.obs;
  var returnDate = ''.obs;
  var travellers = '1'.obs;
  var travelClass = 'Economy Class'.obs;

  // search results, read by Searchpage
  var searchResults = <Flight>[].obs;

  // the flight the user tapped "Check" on, read by FlightDetail
  Flight? selectedFlight;

  Future<void> searchFlights() async {
    // TEMPORARY mock data until the Node backend is ready.
    // Later this becomes: an http.get call to your /flights/search endpoint.
    await Future.delayed(const Duration(milliseconds: 300));

    searchResults.value = [
      Flight(
        id: '1', airline: 'IndiGo', flightNumber: '6E-5054',
        fromCity: fromCity.value.isEmpty ? 'Indore' : fromCity.value, fromCode: 'IDR',
        toCity: toCity.value.isEmpty ? 'Mumbai' : toCity.value, toCode: 'BOM',
        departureTime: '05:40', arrivalTime: '06:55', duration: '01hr 15min',
        travelClass: travelClass.value, price: 5000, seatsAvailable: 12,
      ),
      Flight(
        id: '2', airline: 'Air India', flightNumber: 'AI-2031',
        fromCity: fromCity.value.isEmpty ? 'Indore' : fromCity.value, fromCode: 'IDR',
        toCity: toCity.value.isEmpty ? 'Mumbai' : toCity.value, toCode: 'BOM',
        departureTime: '09:10', arrivalTime: '10:30', duration: '01hr 20min',
        travelClass: travelClass.value, price: 5600, seatsAvailable: 5,
      ),
      Flight(
        id: '3', airline: 'Vistara', flightNumber: 'UK-945',
        fromCity: fromCity.value.isEmpty ? 'Indore' : fromCity.value, fromCode: 'IDR',
        toCity: toCity.value.isEmpty ? 'Mumbai' : toCity.value, toCode: 'BOM',
        departureTime: '14:25', arrivalTime: '15:45', duration: '01hr 20min',
        travelClass: travelClass.value, price: 6200, seatsAvailable: 8,
      ),
    ];
  }
}