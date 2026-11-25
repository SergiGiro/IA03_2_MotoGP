import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

class Rider {
  final String name;
  String? imageUrl;
  int? number;
  String? team;
  Color? teamColor;
  String? bike;
  String? country;
  String? countryIso;
  int? age;
  String? birthCity;
  String? nickname;
  bool found = false;

  int rating = 10;

  Rider(this.name);

  // Llista de pilots de l'API. És estàtica perquè només es descarregui
  // una vegada, encara que hi hagi molts pilots a la llista.
  static List? _riders;

  // Treu els accents i passa a minúscules per comparar noms
  // ("Viñales" i "vinales" han de coincidir).
  static String normalitza(String text) {
    const ambAccent = 'àáâäèéêëìíîïòóôöùúûüñç';
    const senseAccent = 'aaaaeeeeiiiioooouuuunc';
    var resultat = text.toLowerCase().trim();
    for (var i = 0; i < ambAccent.length; i++) {
      resultat = resultat.replaceAll(ambAccent[i], senseAccent[i]);
    }
    return resultat;
  }

  // Descarrega tots els pilots de l'API oficial de MotoGP.
  static Future<List> getRiders() async {
    if (_riders != null) {
      return _riders!;
    }
    HttpClient http = HttpClient();
    var uri = Uri.https('api.motogp.pulselive.com', '/motogp/v1/riders');
    var request = await http.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    _riders = json.decode(responseBody);
    return _riders!;
  }

  // Busca el pilot per nom a l'API i omple les seves dades.
  Future getRiderData() async {
    if (imageUrl != null) {
      return;
    }

    try {
      List riders = await getRiders();
      var buscat = normalitza(name);

      // Primer per nom complet i, si no, pel cognom (preferint MotoGP).
      var trobats = riders.where((r) => normalitza('${r["name"]} ${r["surname"]}') == buscat).toList();
      if (trobats.isEmpty) {
        trobats = riders.where((r) => normalitza(r["surname"]) == buscat).toList();
        trobats.sort((a, b) => esMotoGP(b) - esMotoGP(a));
      }
      if (trobats.isEmpty) {
        return;
      }

      var data = trobats[0];
      var carrera = data["current_career_step"];
      found = true;
      number = carrera["number"];
      team = carrera["team"]["name"];
      teamColor = hexColor(carrera["team"]["color"]);
      bike = carrera["team"]["constructor"]["name"];
      nickname = carrera["short_nickname"];
      imageUrl = carrera["pictures"]["profile"]["main"];
      country = data["country"]["name"];
      countryIso = data["country"]["iso"];
      age = data["years_old"];
      birthCity = data["birth_city"];
    } catch (exception) {
      //print(exception);
    }
  }

  static int esMotoGP(dynamic r) => r["current_career_step"]["category"]["name"] == 'MotoGP' ? 1 : 0;

  // Converteix un color de l'API ("#ad0000") a Color de Flutter.
  static Color? hexColor(String? hex) {
    if (hex == null || hex.length != 7) {
      return null;
    }
    return Color(int.parse('FF${hex.substring(1)}', radix: 16));
  }

  // Foto del pilot reduïda a 400 px d'ample. Com que la targeta i la pàgina de detall
  // fan servir la mateixa, només es descarrega una vegada (queda a la memòria cau).
  ImageProvider get photo => ResizeImage(NetworkImage(imageUrl ?? ''), width: 400);

  // Bandera en emoji a partir del codi de país ("ES" -> 🇪🇸).
  String get flag {
    if (countryIso == null) {
      return '';
    }
    return String.fromCharCodes(countryIso!.toUpperCase().codeUnits.map((c) => 0x1F1A5 + c));
  }
}
