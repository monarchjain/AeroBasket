import 'package:aerobasket/mycart.dart';
import 'package:aerobasket/navigationdrawer.dart';
import 'package:aerobasket/searchpage.dart';
import 'package:flutter/material.dart';

class FlightDetail extends StatefulWidget {
  const FlightDetail({super.key});

  @override
  State<FlightDetail> createState() => _FlightDetailState();
}

class _FlightDetailState extends State<FlightDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Padding(
          padding: EdgeInsets.only(left: 50),
          child: Text('Flight Details',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
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
      body: ListView.builder(
          itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
            return Card(
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
                            width: 50,
                            height: 20,
                            color: const Color(0xFF4B0082),
                            child: const Center(child: Text("IndiGo",style: TextStyle(color: Colors.white),)),
                ),
              ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20,left: 10),
                          child: Text("6E-5054",style: TextStyle(color: Color(0xFF4D4C4C)),),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 130),
                            child: Text("01hr 15min",style: TextStyle(color: Colors.grey,)),
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
                              children: const <TextSpan>[
                              TextSpan(text: '05:40\n', style: TextStyle(fontSize: 35,fontWeight: FontWeight.w600,color: Colors.black)),
                              TextSpan(text: 'IDR(Indore)',style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600,),),
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
                                children: const <TextSpan>[
                                    TextSpan(text: '06:55\n', style: TextStyle(fontSize: 35,fontWeight: FontWeight.w600,color: Colors.black)),
                                    TextSpan(text: 'BOM(Mumbai)',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.black),),
                              ],
                          ),
                      ),
                    )
                  ],
                  ),
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("Indore\nAirport India",style: TextStyle(color: Colors.grey),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 180),
                        child: Text("Mumbai\nAirport India",style: TextStyle(color: Colors.grey),),
                      )
                    ],
                  ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20,left: 20),
                            child: SizedBox(
                              width: 160,
                              child: TextField(
                                decoration: InputDecoration(
                                    labelText: "Date",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    prefixIcon: const Icon(Icons.calendar_month)
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                            child: SizedBox(
                              width: 160,
                              child: TextField(
                                decoration: InputDecoration(
                                    labelText: "Time",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    prefixIcon: const Icon(Icons.access_time)
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: RichText(
                              text: TextSpan(
                                text: '',
                                style: DefaultTextStyle.of(context).style,
                                children: const <TextSpan>[
                                  TextSpan(text: 'Price    ', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.grey)),
                                  TextSpan(text: '5000₹-6000₹',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w600),),
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
            );
          }
    )
    );
  }
}
