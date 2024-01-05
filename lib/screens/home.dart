import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  Future<List> callPython() async {
    try {
      String api = 'http://127.0.0.1:5000/weather_post';
      final resp = await http.post(Uri.parse(api),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'city': 'Cupertino', 'country': 'USA'}));
      if (resp.statusCode == 200) {
        Map<String, dynamic> result = json.decode(resp.body);
        return [result['data'], result['minutely']];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  List<double> collectTemps(List weatherData) {
    List<double> temp = [];
    for (var i = 0; i < weatherData.length; i++) {
      // TO DO

      double tem = weatherData[i]['temp'].toDouble();

      temp.add(tem);
    }
    return temp;
  }

  double min_elem(List temps) {
    double min_v = temps[0];
    for (var i = 0; i < temps.length; i++) {
      if (temps[i] < min_v) {
        min_v = temps[i];
      }
    }
    return min_v;
  }

  double max_elem(List temps) {
    double max_v = 0;
    for (var i = 0; i < temps.length; i++) {
      if (temps[i] > max_v) {
        max_v = temps[i];
      }
    }
    return max_v;
  }

  @override
  Widget build(BuildContext context) {
    String cityName = "Santa Cruz"; //city name
    double currTemp = 30.1; // current temperature
    double maxTemp = 30.1; // today max temperature
    double minTemp = 2.1; // today min temperature

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            List weatherData = await callPython();
            cityName = weatherData[0][0]['city_name'];
            List<double> temps = collectTemps(weatherData[1]);
            maxTemp = max_elem(temps);
            minTemp = min_elem(temps);
            currTemp = weatherData[1][0]['temp'];
            print(cityName + minTemp.toString() + currTemp.toString());
          },
          child: Text('Call Python Function'),
        ),
      ),
    );
  }
}
