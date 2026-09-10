import 'dart:convert';
import 'package:aerobasket/mycart.dart';
import 'package:aerobasket/navigationdrawer.dart';
import 'package:aerobasket/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'controllers/flight_search_controller.dart';
import 'controllers/auth_controller.dart';
import 'config/api_config.dart';
import 'models/flight_model.dart';

class FlightDetail extends StatefulWidget {
  const FlightDetail({super.key});

  @override
  State<FlightDetail> createState() => _FlightDetailState();
}

class _FlightDetailState extends State<FlightDetail> {
  final FlightSearchController searchController = Get.find<FlightSearchController>();
  final AuthController authController = Get.find<AuthController>();

  bool isAdding = false;

  Future<bool> _postCartItem({
    required String flightId,
    required String travelDate,
    required String legType,
    String? tripId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token.value}',
        },
        body: jsonEncode({
          "flightId": flightId,
          "travelDate": travelDate,
          "travelClass": searchController.travelClass.value,
          "travellers": int.tryParse(searchController.travellers.value) ?? 1,
          "legType": legType,
          "tripId": tripId,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<void> addToCart() async {
    setState(() { isAdding = true; });

    final bool roundTrip = searchController.isRoundTrip.value && searchController.selectedReturnFlight != null;
    final String? tripId = roundTrip ? DateTime.now().microsecondsSinceEpoch.toString() : null;

    try {
      final outbound = searchController.selectedOutboundFlight!;
      final outboundOk = await _postCartItem(
        flightId: outbound.id,
        travelDate: searchController.travelDate.value,
        legType: roundTrip ? 'outbound' : 'one_way',
        tripId: tripId,
      );

      bool returnOk = true;
      if (roundTrip) {
        final ret = searchController.selectedReturnFlight!;
        returnOk = await _postCartItem(
          flightId: ret.id,
          travelDate: searchController.returnDate.value,
          legType: 'return',
          tripId: tripId,
        );
      }

      if (!mounted) return;

      if (outboundOk && returnOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Added to cart")),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Mycart()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not add to cart. Please try again.")),
        );
      }
    } finally {
      if (mounted) {
        setState(() { isAdding = false; });
      }
    }
  }

  Widget _flightCard(Flight flight, String label) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFEC441E))),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFF4B0082), borderRadius: BorderRadius.circular(4)),
                  child: Flexible(child: Text(flight.airline, style: const TextStyle(color: Colors.white,fontSize: 12), overflow: TextOverflow.ellipsis)),
                ),
                const SizedBox(width: 10),
                Flexible(child: Text(flight.flightNumber, style: const TextStyle(color: Color(0xFF4D4C4C)), overflow: TextOverflow.ellipsis)),
                const Spacer(),
                Text(flight.duration, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(flight.departureTime, style: const TextStyle(fontSize: 28,fontWeight: FontWeight.w600)),
                      Text('${flight.fromCode}(${flight.fromCity})', style: const TextStyle(color: Colors.grey,fontSize: 13,fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const Icon(Icons.flight, color: Color(0xFFEC441E)),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(flight.arrivalTime, style: const TextStyle(fontSize: 28,fontWeight: FontWeight.w600)),
                      Text('${flight.toCode}(${flight.toCity})', style: const TextStyle(color: Colors.grey,fontSize: 13,fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.airline_seat_recline_normal, color: Colors.grey, size: 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text("${flight.travelClass} • ${flight.seatsAvailable} seats left • ₹${flight.price}", style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.w600, fontSize: 13), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Flight? outbound = searchController.selectedOutboundFlight;
    final bool showReturn = searchController.isRoundTrip.value && searchController.selectedReturnFlight != null;
    final Flight? returnFlight = searchController.selectedReturnFlight;

    if (outbound == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Flight Details')),
        body: const Center(child: Text('No flight selected. Please go back and choose a flight.')),
      );
    }

    final int totalPrice = outbound.price + (showReturn ? returnFlight!.price : 0);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Flight Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: const Color(0xFFF88863),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_shopping_cart, size: 26),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Mycart()),
              );
            },
          ),
        ],
      ),
      drawer: const Navigationdrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8),
              children: [
                _flightCard(outbound, showReturn ? "Outbound" : "Flight"),
                if (showReturn) _flightCard(returnFlight!, "Return"),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Price', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.grey)),
                    Text('₹$totalPrice', style: const TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Searchpage()),
                          );
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFEC441E)),
                          ),
                          child: const Center(child: Text("Cancel", style: TextStyle(fontSize: 16, color: Color(0xFFEC441E)))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: isAdding ? null : addToCart,
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFEC441E),
                          ),
                          child: Center(
                            child: isAdding
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text("Add to Cart", style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}