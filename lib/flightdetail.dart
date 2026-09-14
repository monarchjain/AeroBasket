import 'dart:convert';
import 'package:aerobasket/mycart.dart';
import 'package:aerobasket/navigationdrawer.dart';
import 'package:aerobasket/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'controllers/flight_search_controller.dart';
import 'controllers/auth_controller.dart';
import 'config/api_config.dart';
import 'config/app_theme.dart';
import 'models/flight_model.dart';
import 'utils/time_format.dart';

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

    final bool isConnection = searchController.selectedConnectionLegs != null;
    final bool roundTrip = !isConnection && searchController.isRoundTrip.value && searchController.selectedReturnFlight != null;
    final bool needsTripId = isConnection || roundTrip;
    final String? tripId = needsTripId ? DateTime.now().microsecondsSinceEpoch.toString() : null;

    try {
      bool allOk;

      if (isConnection) {
        final legs = searchController.selectedConnectionLegs!;
        final ok1 = await _postCartItem(flightId: legs[0].id, travelDate: searchController.travelDate.value, legType: 'leg1', tripId: tripId);
        final ok2 = await _postCartItem(flightId: legs[1].id, travelDate: searchController.travelDate.value, legType: 'leg2', tripId: tripId);
        allOk = ok1 && ok2;
      } else {
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
        allOk = outboundOk && returnOk;
      }

      if (!mounted) return;

      if (allOk) {
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.runway)),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(6)),
                  child: Flexible(child: Text(flight.airline, style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                ),
                const SizedBox(width: 10),
                Flexible(child: Text(flight.flightNumber, style: GoogleFonts.inter(color: AppColors.slate, fontSize: 13), overflow: TextOverflow.ellipsis)),
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
                      Text(formatTime12Hour(flight.departureTime), style: GoogleFonts.spaceGrotesk(fontSize: 26,fontWeight: FontWeight.w600, color: AppColors.ink)),
                      Text('${flight.fromCode} · ${flight.fromCity}', style: GoogleFonts.inter(color: AppColors.slate,fontSize: 13,fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const Icon(Icons.flight, color: AppColors.runway, size: 22),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(formatTime12Hour(flight.arrivalTime), style: GoogleFonts.spaceGrotesk(fontSize: 26,fontWeight: FontWeight.w600, color: AppColors.ink)),
                      Text('${flight.toCode} · ${flight.toCity}', style: GoogleFonts.inter(color: AppColors.slate,fontSize: 13,fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
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
              children: [
                const Icon(Icons.airline_seat_recline_normal, color: AppColors.slate, size: 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text("${flight.travelClass} • ${flight.seatsAvailable} seats left • ₹${flight.price}", style: GoogleFonts.inter(color: AppColors.slate,fontWeight: FontWeight.w500, fontSize: 13), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _layoverBanner(int minutes, String city) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    final label = h > 0 ? '${h}h ${m}m layover in $city' : '${m}m layover in $city';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.slate.withOpacity(0.3))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.slate, fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Divider(color: AppColors.slate.withOpacity(0.3))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Flight>? connectionLegs = searchController.selectedConnectionLegs;
    final Flight? outbound = searchController.selectedOutboundFlight;
    final bool showReturn = searchController.isRoundTrip.value && searchController.selectedReturnFlight != null;
    final Flight? returnFlight = searchController.selectedReturnFlight;

    if (connectionLegs == null && outbound == null) {
      return Scaffold(
        backgroundColor: AppColors.paper,
        appBar: AppBar(backgroundColor: AppColors.navy, foregroundColor: Colors.white, title: const Text('Flight details')),
        body: Center(child: Text('No flight selected. Please go back and choose a flight.', style: GoogleFonts.inter(color: AppColors.slate))),
      );
    }

    final int travellerCount = int.tryParse(searchController.travellers.value) ?? 1;

    int totalPrice;
    List<Widget> cardWidgets;

    if (connectionLegs != null) {
      totalPrice = (connectionLegs[0].price + connectionLegs[1].price) * travellerCount;
      final l1 = connectionLegs[0].arrivalTime.split(':').map(int.parse).toList();
      final l2 = connectionLegs[1].departureTime.split(':').map(int.parse).toList();
      final layoverMinutes = (l2[0] * 60 + l2[1]) - (l1[0] * 60 + l1[1]);
      cardWidgets = [
        _flightCard(connectionLegs[0], "Leg 1"),
        _layoverBanner(layoverMinutes, connectionLegs[0].toCity),
        _flightCard(connectionLegs[1], "Leg 2"),
      ];
    } else {
      totalPrice = (outbound!.price + (showReturn ? returnFlight!.price : 0)) * travellerCount;
      cardWidgets = [
        _flightCard(outbound, showReturn ? "Outbound" : "Flight"),
        if (showReturn) _flightCard(returnFlight!, "Return"),
      ];
    }

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Flight details', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, fontSize: 19, color: Colors.white)),
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 12),
              children: cardWidgets,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total price · $travellerCount ${travellerCount == 1 ? "traveller" : "travellers"}', style: GoogleFonts.inter(fontSize: 13,fontWeight: FontWeight.w500,color: AppColors.slate)),
                    Text('₹$totalPrice', style: GoogleFonts.spaceGrotesk(color: AppColors.ink,fontSize: 22,fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: "Cancel",
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Searchpage()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: PrimaryButton(
                        label: "Add to cart",
                        isLoading: isAdding,
                        onTap: isAdding ? null : addToCart,
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