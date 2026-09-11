import 'dart:convert';
import 'package:aerobasket/addpassenger.dart';
import 'package:aerobasket/homepage.dart';
import 'package:aerobasket/navigationdrawer.dart';
import 'package:aerobasket/payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:slider_button/slider_button.dart';
import 'controllers/auth_controller.dart';
import 'config/api_config.dart';
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
      legs.sort((a, b) => a['legType'] == 'outbound' ? -1 : 1);
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

  Widget _miniInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _legTile(Map<String, dynamic> leg, {String? label}) {
    final flight = leg['flightId'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEC441E), fontSize: 13)),
          ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFF4B0082), borderRadius: BorderRadius.circular(4)),
              child: Text(flight['airline'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 11)),
            ),
            const SizedBox(width: 8),
            Text(flight['flightNumber'] ?? '', style: const TextStyle(color: Color(0xFF4D4C4C), fontSize: 13)),
            const Spacer(),
            Text(flight['duration'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formatTime12Hour(flight['departureTime'] ?? ''), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                Text('${flight['fromCode']}(${flight['fromCity']})', style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
            const Icon(Icons.flight, color: Color(0xFFEC441E)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatTime12Hour(flight['arrivalTime'] ?? ''), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                Text('${flight['toCode']}(${flight['toCity']})', style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
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
    final bool isRoundTrip = group.legs.length > 1;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < group.legs.length; i++) ...[
              _legTile(group.legs[i], label: isRoundTrip ? (group.legs[i]['legType'] == 'outbound' ? 'Outbound' : 'Return') : null),
              if (i < group.legs.length - 1) const Divider(height: 28),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: ₹${group.totalPrice}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () => deleteGroup(group),
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  label: const Text('Remove', style: TextStyle(color: Colors.red)),
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
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: const Color(0xFFF88863),
      ),
      drawer: const Navigationdrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartGroups.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text("Your cart is empty", style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEC441E)),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Homepage()),
                      (route) => false,
                );
              },
              child: const Text("Search Flights", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchCart,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                itemCount: cartGroups.length,
                itemBuilder: (context, index) => _groupCard(cartGroups[index]),
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
                      const Text('Grand Total', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600)),
                      Text('₹$grandTotal', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFEC441E)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPassenger()));
                      },
                      child: const Text("Choose Passengers", style: TextStyle(color: Color(0xFFEC441E), fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: SliderButton(
                      action: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Payment()));
                        return null;
                      },
                      label: const Text("Slide For Payment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)),
                      icon: const Icon(Icons.arrow_forward, size: 30),
                      backgroundColor: const Color(0xFFEC441E),
                    ),
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