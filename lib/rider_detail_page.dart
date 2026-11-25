import 'dart:async';

import 'package:flutter/material.dart';
import 'rider_model.dart';

class RiderDetailPage extends StatefulWidget {
  final Rider rider;
  const RiderDetailPage(this.rider, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RiderDetailPageState createState() => _RiderDetailPageState();
}

class _RiderDetailPageState extends State<RiderDetailPage> {
  late double _sliderValue = widget.rider.rating.toDouble();

  Rider get rider => widget.rider;
  Color get teamColor => rider.teamColor ?? const Color(0xFFE10600);

  void updateRating() {
    if (_sliderValue < 5) {
      _ratingErrorDialog();
    } else {
      setState(() {
        rider.rating = _sliderValue.toInt();
      });
    }
  }

  Future<void> _ratingErrorDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error!'),
            content: Text("Vinga! ${rider.name} és un crack!"),
            actions: <Widget>[
              TextButton(
                child: const Text('Torna-ho a provar'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  // Foto del pilot de cos sencer, amb la mateixa Hero tag que a la targeta.
  Widget get riderImage {
    return Hero(
      tag: rider,
      child: Image(
        height: 320,
        fit: BoxFit.contain,
        image: rider.photo,
        // Si la foto encara s'està descarregant, mostrem un indicador de càrrega.
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : const SizedBox(height: 320, child: Center(child: CircularProgressIndicator(color: Colors.white))),
      ),
    );
  }

  Widget get riderProfile {
    return Container(
      padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [teamColor, const Color(0xFF121212)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Número gegant darrere del pilot.
          Text(
            '${rider.number ?? ''}',
            style: TextStyle(
              fontSize: 220,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          Column(
            children: <Widget>[
              riderImage,
              const SizedBox(height: 12),
              Text(rider.name, style: const TextStyle(color: Colors.white, fontSize: 32.0, fontWeight: FontWeight.bold)),
              Text('${rider.flag} ${rider.country ?? ''}  ·  #${rider.number ?? ''}',
                  style: const TextStyle(color: Colors.white70, fontSize: 18.0)),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoRow(IconData icona, String titol, String? valor) {
    return ListTile(
      leading: Icon(icona, color: teamColor),
      title: Text(titol, style: const TextStyle(color: Colors.white54, fontSize: 13)),
      subtitle: Text(valor ?? '-', style: const TextStyle(color: Colors.white, fontSize: 17)),
    );
  }

  Widget get riderInfo {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          infoRow(Icons.groups, 'Equip', rider.team),
          infoRow(Icons.two_wheeler, 'Moto', rider.bike),
          infoRow(Icons.cake, 'Edat', rider.age != null ? '${rider.age} anys' : null),
          infoRow(Icons.place, 'Lloc de naixement', rider.birthCity),
          infoRow(Icons.badge, 'Sobrenom', rider.nickname),
        ],
      ),
    );
  }

  Widget get rating {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(Icons.star, size: 40.0, color: Color(0xFFFFC107)),
        Text(' ${rider.rating}/10', style: const TextStyle(color: Colors.white, fontSize: 30.0)),
      ],
    );
  }

  Widget get addYourRating {
    return Column(
      children: <Widget>[
        rating,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Slider(
                  activeColor: teamColor,
                  min: 0.0,
                  max: 10.0,
                  divisions: 10,
                  value: _sliderValue,
                  onChanged: (newRating) {
                    setState(() {
                      _sliderValue = newRating;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 50.0,
                child: Text('${_sliderValue.toInt()}',
                    textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 25.0)),
              ),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: teamColor, foregroundColor: Colors.white),
          onPressed: () => updateRating(),
          child: const Text('Puntua'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: teamColor,
        foregroundColor: Colors.white,
        title: Text(rider.nickname ?? rider.name),
      ),
      body: ListView(
        children: <Widget>[riderProfile, riderInfo, addYourRating],
      ),
    );
  }
}
