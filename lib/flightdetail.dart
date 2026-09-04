import 'package:aerobasket/mycart.dart';
import 'package:aerobasket/navigationdrawer.dart';
import 'package:aerobasket/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/flight_search_controller.dart';
import 'models/flight_model.dart';

class FlightDetail extends StatefulWidget {
  const FlightDetail({super.key});

  @override
  State<FlightDetail> createState() => _FlightDetailState();
}

class _FlightDetailState extends State<FlightDetail> {
  final FlightSearchController searchController = Get.find<FlightSearchController>();

  @override
  Widget build(BuildContext context) {
    final Flight? flight = searchController.selectedFlight;

    if (flight == null) {
      // Safety net: this screen was opened without a flight ever being selected
      // (shouldn't normally happen, but avoids a crash if it does).
      return Scaffold(
        appBar: AppBar(title: const Text('Flight Details')),
        body: const Center(child: Text('No flight selected. Please go back and choose a flight.')),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Flight Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          backgroundColor: const Color(0xFFF88863),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_shopping_cart, size: 28),
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
        body: ListView(
            children: [
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40,top: 20),
                          child: Container(
                            width: 60,
                            height: 20,
                            color: const Color(0xFF4B0082),
                            child: Center(child: Text(flight.airline,style: const TextStyle(color: Colors.white,fontSize: 12),)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20,left: 10),
                          child: Text(flight.flightNumber,style: const TextStyle(color: Color(0xFF4D4C4C)),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: Text(flight.duration,style: const TextStyle(color: Colors.grey,)),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: RichText(
                            text: TextSpan(
                              text: '',
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(text: '${flight.departureTime}\n', style: const TextStyle(fontSize: 35,fontWeight: FontWeight.w600,color: Colors.black)),
                                TextSpan(text: '${flight.fromCode}(${flight.fromCity})',style: const TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600,),),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Image.asset("assets/trip1.png",width: 120,height: 90),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: RichText(
                            text: TextSpan(
                              text: '',
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(text: '${flight.arrivalTime}\n', style: const TextStyle(fontSize: 35,fontWeight: FontWeight.w600,color: Colors.black)),
                                TextSpan(text: '${flight.toCode}(${flight.toCity})',style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.black),),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text("${flight.fromCity}\nAirport India",style: const TextStyle(color: Colors.grey),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 180),
                          child: Text("${flight.toCity}\nAirport India",style: const TextStyle(color: Colors.grey),),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20,left: 20),
                      child: Row(
                        children: [
                          const Icon(Icons.airline_seat_recline_normal, color: Colors.grey),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text("${flight.travelClass} • ${flight.seatsAvailable} seats left",style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Center(
                        child: RichText(
                            text: TextSpan(
                              text: '',
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                const TextSpan(text: 'Price    ', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.grey)),
                                TextSpan(text: '₹${flight.price}',style: const TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w600),),
                              ],
                            )
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30,left: 40,bottom: 30),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Searchpage()),
                              );
                            },
                            child:Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: const Color(0xFFEC441E))
                              ),
                              child: const Center(child: Text("Cancel",style: TextStyle(fontSize: 20, color: Color(0xFFEC441E)),)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30,left: 80,bottom: 30),
                          child: Center(
                            child: InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Mycart()),
                                );
                              },
                              child:Container(
                                height: 40,
                                width: 150,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Color(0xFFEC441E)
                                ),
                                child: const Center(child: Text("Add to Cart",style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.w600),)),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ]
        )
    );
  }
}