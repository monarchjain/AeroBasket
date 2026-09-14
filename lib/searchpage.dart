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
      searchController.selectedConnectionLegs = null;
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

  void selectConnection(ConnectingItinerary itinerary) {
    searchController.selectedConnectionLegs = itinerary.legs;
    searchController.selectedOutboundFlight = null;
    searchController.selectedReturnFlight = null;
    Navigator.push(context, MaterialPageRoute(builder: (context) => const FlightDetail()));
  }

  Widget _directFlightCard(Flight flight) {
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
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.mist, borderRadius: BorderRadius.circular(4)),
                  child: Text('Direct', style: GoogleFonts.inter(fontSize: 11, color: AppColors.slate, fontWeight: FontWeight.w600)),
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
  }

  Widget _legRow(Flight flight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formatTime12Hour(flight.departureTime), style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink)),
              Text('${flight.fromCode} · ${flight.fromCity}', style: GoogleFonts.inter(color: AppColors.slate, fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        Column(
          children: [
            Text(flight.airline, style: GoogleFonts.inter(fontSize: 11, color: AppColors.slate)),
            const Icon(Icons.flight, color: AppColors.runway, size: 16),
          ],
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formatTime12Hour(flight.arrivalTime), style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink)),
              Text('${flight.toCode} · ${flight.toCity}', style: GoogleFonts.inter(color: AppColors.slate, fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  Widget _connectionCard(ConnectingItinerary itinerary) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.runway.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                  child: Text('1 stop', style: GoogleFonts.inter(fontSize: 11, color: AppColors.runway, fontWeight: FontWeight.w700)),
                ),
                const Spacer(),
                Text('₹${itinerary.totalPrice}', style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink)),
              ],
            ),
            const SizedBox(height: 14),
            _legRow(itinerary.legs[0]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(child: Divider(color: AppColors.mist)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(itinerary.layoverLabel, style: GoogleFonts.inter(fontSize: 11, color: AppColors.slate, fontWeight: FontWeight.w500)),
                  ),
                  Expanded(child: Divider(color: AppColors.mist)),
                ],
              ),
            ),
            _legRow(itinerary.legs[1]),
            const SizedBox(height: 16),
            PrimaryButton(label: "Select itinerary", onTap: () => selectConnection(itinerary)),
          ],
        ),
      ),
    );
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
        final bool showConnections = !searchController.isRoundTrip.value && searchController.connectionResults.isNotEmpty;

        if (searchController.searchResults.isEmpty && !showConnections) {
          return Center(child: Text("No flights found", style: GoogleFonts.inter(color: AppColors.slate)));
        }

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            if (searchController.searchResults.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 4),
                child: Text('Direct flights', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.slate, fontSize: 13)),
              ),
              ...searchController.searchResults.map((f) => _directFlightCard(f)),
            ],
            if (showConnections) ...[
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 8, bottom: 4),
                child: Text('Connecting flights', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.slate, fontSize: 13)),
              ),
              ...searchController.connectionResults.map((c) => _connectionCard(c)),
            ],
          ],
        );
      }),
    );
  }
}