import 'package:aerobasket/mybooking.dart';
import 'package:aerobasket/mycart.dart';
import 'package:aerobasket/navigationdrawer.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: const Padding(
            padding: EdgeInsets.only(left: 70),
            child: Text('Payment',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
          ),
          backgroundColor: const Color(0xFFF88863),
          ),
        drawer: const Navigationdrawer(),
          body:SafeArea(
            child: SingleChildScrollView(
              child:Column(
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
                                padding: EdgeInsets.only(left: 180,top: 20),
                                child: Text("06/07/20203",style: TextStyle(color: Colors.grey,)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Image.asset('assets/Line.png'),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Image.asset('assets/Line.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child:  Center(
                              child: RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: DefaultTextStyle.of(context).style,
                                      children: const <TextSpan>[
                                        TextSpan(text: 'Price                                  ', style: TextStyle(fontSize: 20)),
                                        TextSpan(text: '5,000₹', style: TextStyle(color: Color(0xFFEC441E),fontSize: 25,fontWeight: FontWeight.w600,),),
                                      ],
                                    )),
                            ),
                            ),

                        ],
                      ),
                    );
                  }
                  ),
               Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Image.asset('assets/Line.png'),
              ),
               const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children:[
                Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text("Total",style: TextStyle(fontSize: 20),),
                ),
                    Padding(
                      padding: EdgeInsets.only(left: 170),
                      child: Text("10,000₹",style:TextStyle(color: Color(0xFFEC441E),fontSize: 25,fontWeight: FontWeight.w600,),),
                    )
                    ]
                ),
              ),
                   const Row(
                     children: [
                       Padding(
                         padding: EdgeInsets.only(left: 20,top: 10),
                         child: Text("Card Number",style: TextStyle(fontSize: 18),),
                       ),
                     ],
                   ),
                   const Padding(
                     padding: EdgeInsets.only(left: 20,right: 50),
                     child: TextField(
                       decoration: InputDecoration(
                         hintText: "5300 0000 0000 0000",
                       ),
                     ),
                   ),
                   const Row(
                       children: [Padding(
                         padding: EdgeInsets.only(left: 20,top: 10),
                         child: Text("Card Holder Name",style: TextStyle(fontSize: 18),),
                       ),
                       ],
                   ),
                   const Padding(
                     padding: EdgeInsets.only(left: 20,right: 50),
                     child: TextField(
                       decoration: InputDecoration(
                         hintText: "Monarch Jain",
                       ),
                     ),
                   ),
                   const Row(
                       children: [
                         Padding(
                           padding: EdgeInsets.only(left: 20,top: 10),
                           child: Text("CVV",style: TextStyle(fontSize: 18),),
                         ),
                         Padding(
                           padding: EdgeInsets.only(left: 150,top: 10),
                           child: Text("Expiry Date",style: TextStyle(fontSize: 18),),
                         ),
                       ],
                   ),
                   const Row(
                     children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: SizedBox(
                                   width: 150,
                                   child: TextField(
                                     decoration: InputDecoration(
                                       hintText: "123",
                                     ),
                                   ),
                                 ),
                        ),
                       Padding(
                         padding: EdgeInsets.only(left: 40),
                         child: SizedBox(
                             width: 150,
                             child: TextField(
                               decoration: InputDecoration(
                                 hintText: "07/25",
                               ),
                             ),
                           ),
                       ),
                     ],
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left: 20,right: 200),
                     child: Image.asset("assets/payment.png"),
                   ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30,left: 30),
                      child: Center(
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyBooking()),
                            );
                          },
                          child:Container(
                            height: 40,
                            width: 150,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: Color(0xFFEC441E)
                            ),
                            child: const Center(child: Text("Confirm",style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.w600),)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30,left: 40),
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
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: const Color(0xFFEC441E))
                          ),
                          child: const Center(child: Text("Cancel",style: TextStyle(fontSize: 20, color: Color(0xFFEC441E),fontWeight: FontWeight.w600),)),
                        ),
                      ),
                    ),
                 ]
              ),
              ]
            ),
          )
    )
    );
  }
}
