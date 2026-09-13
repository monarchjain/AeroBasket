import 'dart:convert';
import 'package:aerobasket/mycart.dart';
import 'package:aerobasket/navigationdrawer.dart';
import 'package:aerobasket/searchpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'controllers/flight_search_controller.dart';
import 'config/api_config.dart';
import 'config/app_theme.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FlightSearchController searchController = Get.put(FlightSearchController());

  List<String> cityList = [];
  bool isLoadingCities = true;
  String? selectedFromCity;
  String? selectedToCity;

  TextEditingController travellerController = TextEditingController(text: "1");
  TextEditingController dateinput = TextEditingController();
  TextEditingController returnDateInput = TextEditingController();
  String dropdown = "Economy Class";
  var items = ["Economy Class","Premium Economy","Business Class"];

  @override
  void initState() {
    dateinput.text = "";
    super.initState();
    fetchCities();
  }

  Future<void> fetchCities() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/flights/cities'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          cityList = List<String>.from(data['cities']);
          isLoadingCities = false;
        });
      } else {
        setState(() { isLoadingCities = false; });
      }
    } catch (e) {
      setState(() { isLoadingCities = false; });
    }
  }

  var _isShow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('AeroBasket', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 28, bottom: 36),
              color: AppColors.navy,
              child: Center(
                child: ToggleSwitch(
                  minWidth: 100,
                  minHeight: 38,
                  cornerRadius: 19.0,
                  radiusStyle: true,
                  fontSize: 14.0,
                  initialLabelIndex: _isShow ? 1 :0,
                  activeBgColor: const [AppColors.runway],
                  activeFgColor: Colors.white,
                  inactiveBgColor: AppColors.navy,
                  inactiveFgColor: Colors.white70,
                  totalSwitches: 2,
                  labels: const ['One Way', 'Round',],
                  onToggle: (index) => setState(() {
                    _isShow = !_isShow;
                  }),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedFromCity,
                          decoration: AppInputs.filled(label: "From", icon: Icons.flight_takeoff, hint: isLoadingCities ? "Loading cities..." : "Select departure city"),
                          items: cityList.map((city) => DropdownMenuItem(value: city, child: Text(city, style: GoogleFonts.inter()))).toList(),
                          onChanged: (value) {
                            setState(() { selectedFromCity = value; });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: selectedToCity,
                          decoration: AppInputs.filled(label: "To", icon: Icons.flight_land, hint: isLoadingCities ? "Loading cities..." : "Select arrival city"),
                          items: cityList.map((city) => DropdownMenuItem(value: city, child: Text(city, style: GoogleFonts.inter()))).toList(),
                          onChanged: (value) {
                            setState(() { selectedToCity = value; });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: travellerController,
                          keyboardType: TextInputType.number,
                          decoration: AppInputs.filled(label: "Traveller", icon: Icons.person_outline),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: _isShow ? 8 : 0),
                                child: TextField(
                                    controller: dateinput,
                                    decoration: AppInputs.filled(label: "Date", icon: Icons.calendar_month),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? date = await showDatePicker(
                                          context: context,initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101)
                                      );
                                      if (date != null) {
                                        if (kDebugMode) { print(date); }
                                        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                                        setState(() {dateinput.text = formattedDate;});
                                      }
                                    }
                                ),
                              ),
                            ),
                            if (_isShow)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: TextField(
                                      controller: returnDateInput,
                                      decoration: AppInputs.filled(label: "Return", icon: Icons.event_repeat),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? date = await showDatePicker(
                                            context: context,initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2101)
                                        );
                                        if (date != null) {
                                          if (kDebugMode) { print(date); }
                                          String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                                          setState(() {returnDateInput.text = formattedDate;});
                                        }
                                      }
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<String>(
                                value: dropdown,
                                isExpanded: true,
                                decoration: AppInputs.filled(label: "Class").copyWith(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                ),
                                items: items.map((String item){
                                  return DropdownMenuItem(
                                      value: item,
                                      child: Text(item, style: GoogleFonts.inter(fontSize: 13)));
                                }).toList(),
                                onChanged: (String? newValue){
                                  setState(() {
                                    dropdown = newValue!;
                                  });
                                }
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Obx(() => PrimaryButton(
                          label: "Search flights",
                          isLoading: searchController.isSearching.value,
                          onTap: searchController.isSearching.value ? null : () async {
                            if (selectedFromCity == null || selectedToCity == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please select both From and To cities")),
                              );
                              return;
                            }
                            if (selectedFromCity == selectedToCity) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("From and To cities can't be the same")),
                              );
                              return;
                            }
                            if (dateinput.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please select a travel date")),
                              );
                              return;
                            }
                            if (_isShow && returnDateInput.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please select a return date for round trip")),
                              );
                              return;
                            }

                            searchController.fromCity.value = selectedFromCity!;
                            searchController.toCity.value = selectedToCity!;
                            searchController.travelDate.value = dateinput.text;
                            searchController.returnDate.value = returnDateInput.text;
                            searchController.travellers.value =
                            travellerController.text.trim().isEmpty ? "1" : travellerController.text.trim();
                            searchController.travelClass.value = dropdown;
                            searchController.isRoundTrip.value = _isShow;

                            final success = await searchController.searchOutbound();

                            if (!context.mounted) return;

                            if (success) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Searchpage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Could not connect to server. Is the backend running?")),
                              );
                            }
                          },
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}