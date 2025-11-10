import 'dart:io';
import 'package:aerobasket/homepage.dart';
import 'package:flutter/foundation.dart';
import 'package:aerobasket/searchpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});
  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
 Uint8List? _image;
 File? selectedIMage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text("Personal Info",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
            Center(
              child: Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                      radius: 50,
                      backgroundImage: MemoryImage(_image!))
                      : const  CircleAvatar(
                    radius: 50,
                  ),
                  Positioned(
                    bottom: -5,
                    left: 65,
                    child: IconButton(onPressed: (){
                      showImagePickerOption(context);
                    },icon:const Icon(Icons.add_a_photo),)
              ),
                  ]
                  ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(child: Text("Monarch",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    hintText: "Enter your Name"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    hintText: "Enter your Addresss"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    hintText: "Enter your Phone Number"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    hintText: "Enter your Email",
                  prefixIcon: const Icon(Icons.email_outlined)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: InkWell(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const Homepage()));
                  },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFFEC441E)
                      ),
                      child: const Center(child: Text("Update Profile",style: TextStyle(fontSize: 20,color: Colors.white),)),
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: CupertinoButton(
                  child: const Text('Skip',style: TextStyle(color: Color(0xFFEC441E)),),
                  onPressed: (){
                    Navigator.push(
                        context,
                        CupertinoPageRoute(builder :(context) => const Searchpage())
                    );
                  },
                ),
              ),
            ),
          ],

      )
      )
    );
  }
 void showImagePickerOption(BuildContext context){
   showModalBottomSheet(
       backgroundColor: const Color(0xFFF88863),
       context: context, builder: (builder){
     return Padding(
       padding: const EdgeInsets.all(18.0),
       child: SizedBox(
         width: MediaQuery.of(context).size.width,
         height: MediaQuery.of(context).size.height/4.5,
         child: Row(
           children: [
             Expanded(
               child: InkWell(
                 onTap: (){
                   _picImageFromGallery();
                 },
                 child:const SizedBox(
                   child: Column(
                     children: [
                       Padding(
                         padding: EdgeInsets.only(top: 50),
                         child: Icon(Icons.image,size: 70,),
                       ),
                       Text('Gallery')
                     ],
                   ),
                 ),
               ),
             ),
             Expanded(
               child: InkWell(
                 onTap: (){
                   _picImageFromCemra();
                 },
                 child: const SizedBox(
                   child: Column(
                     children: [
                       Padding(
                         padding: EdgeInsets.only(top: 50),
                         child: Icon(Icons.camera_alt,size: 70,),
                       ),
                       Text('Camera')
                     ],
                   ),
                 ),
               ),
             )
           ],
         ),
       ),
     );

   });
 }
 Future _picImageFromGallery() async {
   final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
   if(returnImage == null)return;
   setState(() {
     selectedIMage = File(returnImage.path);
     _image = File(returnImage.path).readAsBytesSync();
   });

 }
 Future _picImageFromCemra() async {
   final returnImage =
   await ImagePicker().pickImage(source: ImageSource.camera);
   if(returnImage == null)return;
   setState(() {
     selectedIMage = File(returnImage.path);
     _image = File(returnImage.path).readAsBytesSync();
     });
  }
}
