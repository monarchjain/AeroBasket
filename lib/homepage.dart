import 'package:aerobasket/mycart.dart';
import 'package:aerobasket/navigationdrawer.dart';
import 'package:aerobasket/searchpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'controllers/flight_search_controller.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FlightSearchController searchController = Get.put(FlightSearchController());

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController travellerController = TextEditingController(text: "1");
  TextEditingController dateinput = TextEditingController();
  TextEditingController returnDateInput = TextEditingController();
  String dropdown = "Economy Class";
  var items = ["Economy Class","Premium Economy","Business Class"];

  @override
  void initState() {
    dateinput.text = "";
    super.initState();
  }

  var _isShow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Padding(
          padding: EdgeInsets.only(left: 70),
          child: Text('AeroBasket',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
        ),
        backgroundColor: const Color(0xFFF88863),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_shopping_cart,size: 30,),
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
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: ToggleSwitch(
                  minWidth: 90,
                  minHeight: 40,
                  cornerRadius: 20.0,
                  radiusStyle: true,
                  fontSize: 16.0,
                  initialLabelIndex: _isShow ? 1 :0,
                  activeBgColor: const [Color(0xFFEC441E)],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  labels: const ['One Way', 'Round',],
                  onToggle: (index) => setState(() {
                    _isShow = !_isShow;
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Card(
                margin: const EdgeInsets.only(left: 20,right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 20,top: 20),
                      child: TextField(
                        controller: fromController,
                        decoration: InputDecoration(
                            labelText: "From",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            prefixIcon: const Icon(Icons.flight_takeoff)
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20,left: 10,right: 20),
                      child: TextField(
                        controller: toController,
                        decoration: InputDecoration(
                            labelText: "To",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            prefixIcon: const Icon(Icons.flight_land)
                        ),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20,left: 10),
                            child: SizedBox(
                              width: 300,
                              child: TextField(
                                controller: travellerController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Traveller",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20,left: 10),
                          child: SizedBox(
                            width: 140,
                            child: TextField(
                                controller: dateinput,
                                decoration: InputDecoration(
                                    labelText: "Date",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    prefixIcon: const Icon(Icons.calendar_month)
                                ),
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
                        Visibility(
                            visible: _isShow,
                            child:Padding(
                              padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                              child: SizedBox(
                                width: 140,
                                child: TextField(
                                    controller: returnDateInput,
                                    decoration: InputDecoration(
                                        labelText: "Return",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        hintText: "Add Return",
                                        prefixIcon: const Icon(Icons.add)
                                    ),
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
                            )
                        )
                      ],
                    ),
                    Row(
                      children:[
                        Padding(
                          padding: const EdgeInsets.only(top: 20,left: 100),
                          child: SizedBox(
                            width: 170,
                            child: DropdownButton(
                                value: dropdown,
                                items: items.map((String items){
                                  return DropdownMenuItem(
                                      value: items,
                                      child: Text(items,selectionColor:Colors.black));
                                }).toList(),
                                borderRadius: BorderRadius.circular(10),
                                onChanged: (String? newValue){
                                  setState(() {
                                    dropdown = newValue!;
                                  });
                                }
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30,bottom: 30),
                      child: Center(
                        child: InkWell(
                          onTap: () async {
                            if (fromController.text.trim().isEmpty || toController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please enter both From and To cities")),
                              );
                              return;
                            }
                            searchController.fromCity.value = fromController.text.trim();
                            searchController.toCity.value = toController.text.trim();
                            searchController.travelDate.value = dateinput.text;
                            searchController.returnDate.value = returnDateInput.text;
                            searchController.travellers.value =
                            travellerController.text.trim().isEmpty ? "1" : travellerController.text.trim();
                            searchController.travelClass.value = dropdown;

                            await searchController.searchFlights();

                            if (!context.mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Searchpage()),
                            );
                          },
                          child:Container(
                            height: 40,
                            width: 300,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: Color(0xFFEC441E)
                            ),
                            child: const Center(child: Text("Search",style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.w600),)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}