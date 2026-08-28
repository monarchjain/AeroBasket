import 'package:aerobasket/flightdetail.dart';
import 'package:aerobasket/mycart.dart';
import 'package:aerobasket/navigationdrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/flight_search_controller.dart';
import 'models/flight_model.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  final FlightSearchController searchController = Get.find<FlightSearchController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Padding(
          padding: EdgeInsets.only(left: 50),
          child: Text('Available Flights',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
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
      body: Obx(() {
        if (searchController.searchResults.isEmpty) {
          return const Center(child: Text("No flights found"));
        }
        return ListView.builder(
          itemCount: searchController.searchResults.length,
          itemBuilder: (BuildContext context, int index) {
            final Flight flight = searchController.searchResults[index];
            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                        padding: const EdgeInsets.only(left:10 ,top: 20),
                        child: Text(flight.flightNumber,style: const TextStyle(color: Color(0xFF4D4C4C)),),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 100,top: 20),
                          child: Text(flight.duration,style: const TextStyle(color: Colors.grey,),)
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: RichText(
                          text: TextSpan(
                            text: '',
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(text: '${flight.departureTime}\n', style: const TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),
                              TextSpan(text: '${flight.fromCode}(${flight.fromCity})',style: const TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w600),),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Image.asset("assets/trip1.png",width: 120,height: 90),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: RichText(
                          text: TextSpan(
                            text: '',
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(text: '${flight.arrivalTime}\n', style: const TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),
                              TextSpan(text: '${flight.toCode}(${flight.toCity})',style: const TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w600),),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Image.asset("assets/Line.png",width: 360,height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Image.asset("assets/Sofa.png",width: 25,height: 25,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(flight.travelClass,style: const TextStyle(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.w600),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 80),
                        child: RichText(
                          text: TextSpan(
                            text: '',
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(text: 'Price  ', style: TextStyle(fontSize: 16,color: Colors.grey,fontWeight: FontWeight.w600)),
                              TextSpan(text: '₹${flight.price}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
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
                        padding: const EdgeInsets.only(top: 30,left: 20,bottom: 30),
                        child: InkWell(
                          onTap: (){
                            searchController.selectedFlight = flight;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FlightDetail()),
                            );
                          },
                          child:Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: const Color(0xFFEC441E))
                            ),
                            child: const Center(child: Text("Check",style: TextStyle(fontSize: 20, color: Color(0xFFEC441E),fontWeight: FontWeight.w600),)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30,left: 40,bottom: 30),
                        child: Center(
                          child: InkWell(
                            onTap: (){
                              searchController.selectedFlight = flight;
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
            );
          },
        );
      }),
    );
  }
}