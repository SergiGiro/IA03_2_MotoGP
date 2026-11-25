import 'dart:async';

import 'package:flutter/material.dart';
import 'new_rider_form.dart';
import 'rider_list.dart';
import 'rider_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotoGP Riders',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE10600), brightness: Brightness.dark),
      ),
      home: const MyHomePage(title: 'MotoGP Riders 2026'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Pilots inicials: només posem el nom, la resta de dades vénen de l'API.
  List<Rider> initialRiders = [
    Rider('Marc Marquez'),
    Rider('Francesco Bagnaia'),
    Rider('Jorge Martin'),
    Rider('Pedro Acosta'),
    Rider('Alex Marquez'),
    Rider('Fabio Quartararo'),
  ];

  Future _showNewRiderForm() async {
    Rider? newRider = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return const AddRiderFormPage();
    }));
    if (newRider != null) {
      setState(() {
        initialRiders.add(newRider);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
        centerTitle: true,
        backgroundColor: const Color(0xFFE10600),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showNewRiderForm,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B0000), Color(0xFF0D0D0D)],
          ),
        ),
        child: RiderList(initialRiders),
      ),
    );
  }
}
