import 'dart:convert';
import 'package:aerobasket/addpassenger.dart';
import 'package:aerobasket/homepage.dart';
import 'package:aerobasket/navigationdrawer.dart';
import 'package:aerobasket/payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'controllers/auth_controller.dart';
import 'config/api_config.dart';
import 'config/app_theme.dart';
import 'utils/time_format.dart';

class CartGroup {
  final String? tripId;
  final List<dynamic> legs;
  CartGroup({required this.tripId, required this.legs});

  int get totalPrice => legs.fold<int>(0, (sum, item) => sum + ((item['price'] as num?)?.toInt() ?? 0));
}

class Mycart extends StatefulWidget {
  const Mycart({super.key});

  @override
  State<Mycart> createState() => _MycartState();
}

class _MycartState extends State<Mycart> {
  final AuthController authController = Get.find<AuthController>();

  List<CartGroup> cartGroups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    setState(() { isLoading = true; });
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/cart'),
        headers: {'Authorization': 'Bearer ${authController.token.value}'},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          cartGroups = _groupItems(data['cartItems']);
          isLoading = false;
        });
      } else {
        setState(() { isLoading = false; });
      }
    } catch (e) {
      setState(() { isLoading = false; });
    }
  }

  List<CartGroup> _groupItems(List<dynamic> items) {
    final Map<String, List<dynamic>> byTrip = {};
    final List<dynamic> standalone = [];

    for (final item in items) {
      final tripId = item['tripId'];
      if (tripId != null) {
        byTrip.putIfAbsent(tripId, () => []).add(item);
      } else {
        standalone.add(item);
      }
    }

    final List<CartGroup> groups = [];
    for (final item in standalone) {
      groups.add(CartGroup(tripId: null, legs: [item]));
    }
    byTrip.forEach((tripId, legs) {
      legs.sort((a, b) => (a['legType'] == 'outbound' || a['legType'] == 'leg1') ? -1 : 1);
      groups.add(CartGroup(tripId: tripId, legs: legs));
    });

    return groups;
  }

  Future<void> deleteGroup(CartGroup group) async {
    for (final leg in group.legs) {
      await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/api/cart/${leg['_id']}'),
        headers: {'Authorization': 'Bearer ${authController.token.value}'},
      );
    }
    await fetchCart();
  }

  String _legLabel(String legType) {
    switch (legType) {
      case 'outbound': return 'Outbound';
      case 'return': return 'Return';
      case 'leg1': return 'Leg 1';
      case 'leg2': return 'Leg 2';
      default: return '';
    }
  }

  Widget _miniInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(color: AppColors.slate, fontSize: 11, fontWeight: FontWeight.w500)),
        Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
      ],
    );
  }

  Widget _legTile(Map<String, dynamic> leg, {String? label}) {
    final flight = leg['flightId'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.runway, fontSize: 13)),
          ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(6)),
              child: Text(flight['airline'] ?? '', style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 8),
            Text(flight['flightNumber'] ?? '', style: GoogleFonts.inter(color: AppColors.slate, fontSize: 13)),
            const Spacer(),
            Text(flight['duration'] ?? '', style: GoogleFonts.inter(color: AppColors.slate, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formatTime12Hour(flight['departureTime'] ?? ''), style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.ink)),
                Text('${flight['fromCode']} · ${flight['fromCity']}', style: GoogleFonts.inter(color: AppColors.slate, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
            const Icon(Icons.flight, color: AppColors.runway, size: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatTime12Hour(flight['arrivalTime'] ?? ''), style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.ink)),
                Text('${flight['toCode']} · ${flight['toCity']}', style: GoogleFonts.inter(color: AppColors.slate, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _miniInfo('Date', (leg['travelDate']?.toString().isNotEmpty ?? false) ? leg['travelDate'] : '-'),
            _miniInfo('Class', flight['travelClass'] ?? leg['travelClass'] ?? ''),
            _miniInfo('Travellers', '${leg['travellers'] ?? 1}'),
            _miniInfo('Price', '₹${leg['price']}'),
          ],
        ),
      ],
    );
  }

  Widget _groupCard(CartGroup group) {
    final bool isMultiLeg = group.legs.length > 1;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < group.legs.length; i++) ...[
              _legTile(group.legs[i], label: isMultiLeg ? _legLabel(group.legs[i]['legType'] ?? '') : null),
              if (i < group.legs.length - 1) Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1, color: AppColors.mist)),
            ],
            Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1, color: AppColors.mist)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: ₹${group.totalPrice}', style: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.ink)),
                TextButton.icon(
                  onPressed: () => deleteGroup(group),
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  label: Text('Remove', style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.w500)),
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
    final int grandTotal = cartGroups.fold<int>(0, (sum, g) => sum + g.totalPrice);

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('My cart', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, fontSize: 19, color: Colors.white)),
      ),
      drawer: const Navigationdrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.runway))
          : cartGroups.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.slate.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text("Your cart is empty", style: GoogleFonts.inter(fontSize: 17, color: AppColors.slate, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: PrimaryButton(
                label: "Search flights",
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Homepage()),
                        (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        color: AppColors.runway,
        onRefresh: fetchCart,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                itemCount: cartGroups.length,
                itemBuilder: (context, index) => _groupCard(cartGroups[index]),
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
                      Text('Grand total', style: GoogleFonts.inter(fontSize: 14, color: AppColors.slate, fontWeight: FontWeight.w500)),
                      Text('₹$grandTotal', style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.ink)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SecondaryButton(
                    label: "Choose passengers",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPassenger()));
                    },
                  ),
                  const SizedBox(height: 14),
                  SlideToConfirm(
                    label: "Slide to pay",
                    onConfirm: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Payment()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}