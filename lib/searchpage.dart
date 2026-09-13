import 'package:aerobasket/flightdetail.dart';
import 'package:aerobasket/mycart.dart';
import 'package:aerobasket/navigationdrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controllers/flight_search_controller.dart';
import 'models/flight_model.dart';
import 'utils/time_format.dart';
import 'config/app_theme.dart';

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
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Obx(() => Text(
          searchController.isRoundTrip.value && searchController.currentLeg.value == 'return'
              ? 'Select return flight'
              : 'Available flights',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, fontSize: 19, color: Colors.white),
        )),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
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
          return Center(child: Text("No flights found", style: GoogleFonts.inter(color: AppColors.slate)));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: searchController.searchResults.length,
          itemBuilder: (BuildContext context, int index) {
            final Flight flight = searchController.searchResults[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(6)),
                          child: Flexible(
                            child: Text(flight.airline, style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(flight.flightNumber, style: GoogleFonts.inter(color: AppColors.slate, fontSize: 13), overflow: TextOverflow.ellipsis),
                        ),
                        const Spacer(),
                        Text(flight.duration, style: GoogleFonts.inter(color: AppColors.slate, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(formatTime12Hour(flight.departureTime), style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.ink)),
                              Text('${flight.fromCode} · ${flight.fromCity}', style: GoogleFonts.inter(color: AppColors.slate, fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        const Icon(Icons.flight, color: AppColors.runway, size: 20),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(formatTime12Hour(flight.arrivalTime), style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.ink)),
                              Text('${flight.toCode} · ${flight.toCity}', style: GoogleFonts.inter(color: AppColors.slate, fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Divider(height: 1, color: AppColors.mist),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.airline_seat_recline_normal, size: 18, color: AppColors.slate),
                            const SizedBox(width: 6),
                            Text(flight.travelClass, style: GoogleFonts.inter(fontSize: 13, color: AppColors.slate, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Text('₹${flight.price}', style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(label: "Check", onTap: () => selectFlight(flight)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(label: "Add to cart", onTap: () => selectFlight(flight)),
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