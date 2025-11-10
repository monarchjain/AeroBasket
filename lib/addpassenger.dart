import 'package:flutter/material.dart';

class AddPassenger extends StatefulWidget {
  const AddPassenger({super.key});

  @override
  State<AddPassenger> createState() => _AddPassengerState();
}

class _AddPassengerState extends State<AddPassenger> {
  int _selectedIndex = 0;
  List<String> names = ['Mr. Monarch Jain', 'Ms. Wagisha Jain', 'Ms. Nancy Patel', 'Mr. Yash Manani', 'Mr. Kshitij Kharve'];
  List<int> ages = [22, 50, 21, 22, 22];

  void _editPassenger(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _deletePassenger(int index) {
    setState(() {
      names.removeAt(index);
      ages.removeAt(index);
      // Adjust selected index if necessary
      if (_selectedIndex >= names.length) {
        _selectedIndex = names.isNotEmpty ? names.length - 1 : 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Select Passenger',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25))),
        backgroundColor: const Color(0xFFF88863),
      ),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: Radio<int>(
                  value: index,
                  groupValue: _selectedIndex,
                  onChanged: (value) {
                    setState(() {
                      _selectedIndex = value!;
                    });
                  },
                ),
                title: Text(names[index]),
                subtitle: Text('${ages[index]}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editPassenger(index);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deletePassenger(index);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
              const Divider(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          addNewPassengerOption(context);
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}

void addNewPassengerOption(BuildContext context) {
  showModalBottomSheet( backgroundColor: const Color(0xFFF88863),

      context: context, builder: (builder){
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const Text("Add New Passengers",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                Row(
                    children: [
                       TextField(
                          decoration: InputDecoration(
                              labelText: "Full name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Enter your Name"
                          ),
                        ),
                    ]
                ),
              ],
            ),
          ),
        );
      });
}
