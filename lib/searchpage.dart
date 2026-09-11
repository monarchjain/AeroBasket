import 'package:aerobasket/flightdetail.dart';
import 'package:aerobasket/mycart.dart';
import 'package:aerobasket/navigationdrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/flight_search_controller.dart';
import 'models/flight_model.dart';
import 'utils/time_format.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  final FlightSearchController searchController = Get.find<FlightSearchController>();

  void selectFlight(Flight flight) async {
    if (!searchController.isRoundTrip.value) {
      searchController.selectedOutboundFlight = flight;
      Navigator.push(context, MaterialPageRoute(builder: (context) => const FlightDetail()));
      return;
    }

    if (searchController.currentLeg.value == 'outbound') {
      searchController.selectedOutboundFlight = flight;
      await searchController.searchReturn();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Outbound selected. Now choose your return flight.")),
        );
      }
    } else {
      searchController.selectedReturnFlight = flight;
      Navigator.push(context, MaterialPageRoute(builder: (context) => const FlightDetail()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          searchController.isRoundTrip.value && searchController.currentLeg.value == 'return'
              ? 'Select Return Flight'
              : 'Available Flights',
          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
        )),
        backgroundColor: const Color(0xFFF88863),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_shopping_cart,size: 28,),
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
      body: Obx(() {
        if (searchController.searchResults.isEmpty) {
          return const Center(child: Text("No flights found"));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: searchController.searchResults.length,
          itemBuilder: (BuildContext context, int index) {
            final Flight flight = searchController.searchResults[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFF4B0082), borderRadius: BorderRadius.circular(4)),
                          child: Flexible(
                            child: Text(flight.airline, style: const TextStyle(color: Colors.white,fontSize: 12), overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(flight.flightNumber, style: const TextStyle(color: Color(0xFF4D4C4C)), overflow: TextOverflow.ellipsis),
                        ),
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
                              Text(formatTime12Hour(flight.departureTime), style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w600)),
                              Text('${flight.fromCode}(${flight.fromCity})', style: const TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        const Icon(Icons.flight, color: Color(0xFFEC441E)),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(formatTime12Hour(flight.arrivalTime), style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w600)),
                              Text('${flight.toCode}(${flight.toCity})', style: const TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.airline_seat_recline_normal, size: 18, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(flight.travelClass, style: const TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Text('Price ₹${flight.price}', style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => selectFlight(flight),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFEC441E)),
                              ),
                              child: const Center(child: Text("Check", style: TextStyle(fontSize: 16, color: Color(0xFFEC441E),fontWeight: FontWeight.w600))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => selectFlight(flight),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFEC441E),
                              ),
                              child: const Center(child: Text("Add to Cart", style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.w600))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}