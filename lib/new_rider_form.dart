import 'package:flutter/material.dart';
import 'rider_model.dart';

class AddRiderFormPage extends StatefulWidget {
  const AddRiderFormPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddRiderFormPageState createState() => _AddRiderFormPageState();
}

class _AddRiderFormPageState extends State<AddRiderFormPage> {
  TextEditingController nameController = TextEditingController();

  void submitRider(BuildContext context) {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Has oblidat escriure el nom del pilot'),
      ));
    } else {
      var newRider = Rider(nameController.text);
      Navigator.of(context).pop(newRider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Afegeix un pilot'),
        backgroundColor: const Color(0xFFE10600),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Column(children: [
          TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Nom del pilot (ex: Fabio Quartararo)',
              labelStyle: TextStyle(color: Colors.white70),
              prefixIcon: Icon(Icons.sports_motorsports, color: Color(0xFFE10600)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE10600), foregroundColor: Colors.white),
                  onPressed: () => submitRider(context),
                  child: const Text('Afegeix el pilot'),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
