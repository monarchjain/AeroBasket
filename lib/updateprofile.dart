import 'dart:convert';
import 'dart:io';
import 'package:aerobasket/homepage.dart';
import 'package:flutter/foundation.dart';
import 'package:aerobasket/searchpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'config/api_config.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});
  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final AuthController authController = Get.find<AuthController>();

  Uint8List? _image;
  File? selectedIMage;
  bool isUploadingPhoto = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      var response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token.value}',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = data['user'];
        setState(() {
          nameController.text = user['name'] ?? '';
          addressController.text = user['address'] ?? '';
          phoneController.text = user['phone'] ?? '';
          emailController.text = user['email'] ?? '';
          isLoading = false;
        });
        authController.profilePhotoUrl.value = user['profilePhotoUrl'] ?? '';
      } else {
        setState(() { isLoading = false; });
      }
    } catch (e) {
      setState(() { isLoading = false; });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not connect to server. Is the backend running?')),
        );
      }
    }
  }

  Future<void> uploadPhoto(File imageFile) async {
    setState(() { isUploadingPhoto = true; });
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/api/user/profile/photo'),
      );
      request.headers['Authorization'] = 'Bearer ${authController.token.value}';
      request.files.add(await http.MultipartFile.fromPath('photo', imageFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        authController.profilePhotoUrl.value = data['profilePhotoUrl'];
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile photo updated')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Could not upload photo')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not connect to server. Is the backend running?')),
        );
      }
    } finally {
      if (mounted) {
        setState(() { isUploadingPhoto = false; });
      }
    }
  }

  Future<void> saveProfile() async {
    setState(() { isSaving = true; });

    try {
      var response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token.value}',
        },
        body: jsonEncode({
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
          "address": addressController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        authController.userName.value = data['user']['name'];
        authController.userPhone.value = data['user']['phone'];

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Homepage()));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Update failed')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not connect to server. Is the backend running?')),
        );
      }
    } finally {
      if (mounted) {
        setState(() { isSaving = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Text("Personal Info",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
                Center(
                  child: Stack(
                      children: [
                        Obx(() {
                          ImageProvider? avatarImage;
                          if (_image != null) {
                            avatarImage = MemoryImage(_image!);
                          } else if (authController.profilePhotoUrl.value.isNotEmpty) {
                            avatarImage = NetworkImage('${ApiConfig.baseUrl}${authController.profilePhotoUrl.value}');
                          }
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: avatarImage,
                            child: avatarImage == null ? const Icon(Icons.person, size: 50) : null,
                          );
                        }),
                        Positioned(
                          bottom: -5,
                          left: 65,
                          child: IconButton(
                            onPressed: isUploadingPhoto ? null : () {
                              showImagePickerOption(context);
                            },
                            icon: isUploadingPhoto
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.add_a_photo),
                          ),
                        ),
                      ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(child: Obx(() => Text(authController.userName.value,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                  child: TextField(
                    controller: nameController,
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
                    controller: addressController,
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
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
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
                    controller: emailController,
                    enabled: false,
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
                        onTap: isSaving ? null : saveProfile,
                        child: Container(
                          height: 40,
                          width: 150,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Color(0xFFEC441E)
                          ),
                          child: Center(
                            child: isSaving
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text("Update Profile",style: TextStyle(fontSize: 20,color: Colors.white),),
                          ),
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
                    Navigator.pop(context);
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
                    Navigator.pop(context);
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
    await uploadPhoto(selectedIMage!);
  }
  Future _picImageFromCemra() async {
    final returnImage =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if(returnImage == null)return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    await uploadPhoto(selectedIMage!);
  }
}