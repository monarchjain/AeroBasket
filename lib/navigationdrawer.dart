import 'package:aerobasket/changepassword.dart';
import 'package:aerobasket/mybooking.dart';
import 'package:aerobasket/updateprofile.dart';
import 'package:flutter/material.dart';

class Navigationdrawer extends StatefulWidget {
  const Navigationdrawer({super.key});

  @override
  State<Navigationdrawer> createState() => _NavigationdrawerState();
}

class _NavigationdrawerState extends State<Navigationdrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              accountName: const Text("Monarch",style: TextStyle(color: Colors.black)),
              accountEmail: const Text('monarch123jain@gmail.com',style: TextStyle(color: Colors.black)),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset("assets/profilepic.png"),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.white
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit Account"),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdateProfile()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change Password"),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePassword()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_copy_sharp),
            title: const Text("My Bookings"),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyBooking()),
              );
            },
          ),
          const ListTile(
            leading: Icon(Icons.headset_mic_outlined),
            title: Text("Support"),
          ),
          const ListTile(
            leading: Icon(Icons.star),
            title: Text("Rate Us"),
          ),
        ],
      ),
    );
  }
}
