import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controllers/auth_controller.dart';
import 'config/api_config.dart';
import 'config/app_theme.dart';

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
          Navigator.pop(context);
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
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.runway))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 6, bottom: 60),
              decoration: const BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Edit profile',
                    style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: -0.3),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Manage your account details',
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: Center(
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
                        radius: 52,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: avatarImage,
                          backgroundColor: AppColors.mist,
                          child: avatarImage == null ? const Icon(Icons.person, size: 44, color: AppColors.slate) : null,
                        ),
                      );
                    }),
                    Positioned(
                      bottom: -2,
                      right: 4,
                      child: Material(
                        color: AppColors.runway,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: isUploadingPhoto ? null : () => showImagePickerOption(context),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: isUploadingPhoto
                                ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Obx(() => Text(
                        authController.userName.value,
                        style: GoogleFonts.spaceGrotesk(fontSize: 19, fontWeight: FontWeight.w600, color: AppColors.ink),
                      )),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: nameController,
                      decoration: AppInputs.filled(label: "Name", icon: Icons.person_outline),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: addressController,
                      decoration: AppInputs.filled(label: "Address", icon: Icons.location_on_outlined),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: AppInputs.filled(label: "Phone number", icon: Icons.phone_outlined),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      enabled: false,
                      decoration: AppInputs.filled(label: "Email", icon: Icons.mail_outline),
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      label: "Update profile",
                      isLoading: isSaving,
                      onTap: isSaving ? null : saveProfile,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _picImageFromGallery();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.image_outlined, size: 44, color: AppColors.navy),
                        const SizedBox(height: 10),
                        Text('Gallery', style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: AppColors.ink)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _picImageFromCemra();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.camera_alt_outlined, size: 44, color: AppColors.navy),
                        const SizedBox(height: 10),
                        Text('Camera', style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: AppColors.ink)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _picImageFromGallery() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    await uploadPhoto(selectedIMage!);
  }

  Future _picImageFromCemra() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    await uploadPhoto(selectedIMage!);
  }
}