import 'package:aerobasket/modifydetail.dart';
import 'package:aerobasket/mycart.dart';
import 'package:aerobasket/navigationdrawer.dart';
import 'package:flutter/material.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: const Padding(
            padding: EdgeInsets.only(left: 70),
            child: Text('My Booking',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
          ),
          backgroundColor: const Color(0xFFF88863),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_shopping_cart,size: 30),
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
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 140,top: 20),
                        child: Container(
                          width: 100,
                          height: 50,
                          color: const Color(0xFF4B0082),
                          child: const Center(child: Text("IndiGo",style: TextStyle(color: Colors.white,fontSize: 20),)),
                        ),
                      ),
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
                            children: const <TextSpan>[
                              TextSpan(text: '05:40\n', style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),
                              TextSpan(text: 'IDR(Indore)',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
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
                            children: const <TextSpan>[
                              TextSpan(text: '06:55\n', style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),
                              TextSpan(text: 'BOM(Mumbai)',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
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
                  Image.asset("assets/Line.png",width: 360,height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: RichText(
                          text: TextSpan(
                            text: '',
                            style: DefaultTextStyle.of(context).style,
                            children: const <TextSpan>[
                              TextSpan(text: 'Flight\n', style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w600)),
                              TextSpan(text: '6E-5053',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 90),
                        child: RichText(
                          text: TextSpan(
                            text: '',
                            style: DefaultTextStyle.of(context).style,
                            children: const <TextSpan>[
                              TextSpan(text: 'PNR\n', style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w600)),
                              TextSpan(text: 'JZCB9A',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 90),
                        child: RichText(
                          text: TextSpan(
                            text: '',
                            style: DefaultTextStyle.of(context).style,
                            children: const <TextSpan>[
                              TextSpan(text: 'Class\n', style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w600)),
                              TextSpan(text: 'Economy',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Image.asset("assets/Line.png",width: 360,height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30,bottom: 30,left: 10),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ModifyDetail()),
                              );
                            },
                            child:Container(
                              height: 40,
                              width: 360,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Color(0xFFEC441E)
                              ),
                              child: const Center(child: Text("Modify",style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.w600),)),
                            ),
                          ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        )
    );
  }
}
