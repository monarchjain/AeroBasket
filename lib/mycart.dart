import 'package:aerobasket/addpassenger.dart';
import 'package:aerobasket/flightdetail.dart';
import 'package:aerobasket/navigationdrawer.dart';
import 'package:aerobasket/payment.dart';
import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

class Mycart extends StatefulWidget {
  const Mycart({super.key});

  @override
  State<Mycart> createState() => _MycartState();
}

class _MycartState extends State<Mycart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: const Padding(
            padding: EdgeInsets.only(left: 70),
            child: Text('My Cart',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
          ),
          backgroundColor: const Color(0xFFF88863),
        ),
        drawer: const Navigationdrawer(),
        body: SingleChildScrollView(
        child:Column(
            children:[
              Column(
                children:[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
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
                                  padding: const EdgeInsets.only(left: 40,top: 20),
                                  child: Container(
                                    width: 50,
                                    height: 20,
                                    color: const Color(0xFF4B0082),
                                    child: const Center(child: Text("IndiGo",style: TextStyle(color: Colors.white),)),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left:10 ,top: 20),
                                  child: Text("6E-5054",style: TextStyle(color: Color(0xFF4D4C4C)),),
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
                                        TextSpan(text: 'Class\n', style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w600)),
                                        TextSpan(text: 'Economy',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
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
                                        TextSpan(text: 'Traveller\n', style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w600)),
                                        TextSpan(text: '1 Adult',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
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
                                        TextSpan(text: 'Price\n', style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w600)),
                                        TextSpan(text: '₹5000',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
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
                                  padding: const EdgeInsets.only(top: 30,left: 20,bottom: 30),
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const FlightDetail()),
                                      );
                                      },
                                    child:Container(
                                      height: 40,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(color: const Color(0xFFEC441E))
                                      ),
                                      child: const Center(child: Text("Cancel",style: TextStyle(fontSize: 20, color: Color(0xFFEC441E),fontWeight: FontWeight.w600),)),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: const Icon(Icons.delete_forever),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (
                                            context) => const Mycart()),
                                      );
                                    }
                                    ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30,bottom: 30),
                                  child: Center(
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => const AddPassenger()),
                                        );
                                        },
                                      child:Container(
                                        height: 40,
                                        width: 200,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: Color(0xFFEC441E)
                                        ),
                                        child: const Center(child: Text("Choose Passenger",style: TextStyle(fontSize: 14, color: Colors.white,fontWeight: FontWeight.w600),)),
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
                  ),
                ]
              ),
              Center(child: SliderButton(
                  action: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Payment()),
                    );
                    return null;
                    },
                  label: const Text("Slide For Payment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),),
                  icon: const Icon(Icons.arrow_forward,size: 35),
                  backgroundColor: const Color(0xFFEC441E)
              )
              )
            ],
        ),
        )
    );
  }
}