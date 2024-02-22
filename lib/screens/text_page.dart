import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/components/my_button.dart';
import 'package:weather_app/components/my_text_field.dart';

class TextPage extends StatefulWidget {
  final String city;
  final String state;
  final void Function()? onPressed;
  const TextPage(
      {super.key, required this.city, required this.state, this.onPressed});

  @override
  State<TextPage> createState() => _Text();
}

class _Text extends State<TextPage> {
  double currTemp = 0.0;
  Future<Map<String, dynamic>?>? callWeatherAPI(
      String city, String state) async {
    try {
      String api_key = "818b5abb87b94f2c8464ecc5168d5a0b";

      String api =
          'https://api.weatherbit.io/v2.0/current?city=${city}&state=${state}&key=${api_key}&include=minutely';
      final resp = await http.get(Uri.parse(api));
      if (resp.statusCode == 200) {
        Map<String, dynamic> result = json.decode(resp.body);
        print("returning result\n");
        return result;
      } else {
        print("returning  ${resp.statusCode}null\n");
        return null;
      }
    } catch (e) {
      return null;
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

  Future<Map<String, dynamic>?> getWeatherInfo(
      String city, String country) async {
    return await callWeatherAPI(widget.city, widget.state);
    //List<double> temps = collectTemps(weather_info[1]);

    //maxTemp = max_elem(temps);
    //minTemp = min_elem(temps);
    //print("in get info, $minTemp");
    //currTemp = weather_info[1][0]['temp'];
    //print(city + minTemp.toString() + currTemp.toString());
  }

  void showRecent() {}
  @override
  Widget build(BuildContext context) {
    String city = widget.city;
    String state = widget.state;
    final title = "$city, $state";

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getWeatherInfo(widget.city, widget.state),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final currTemp = snapshot.data!["data"][0]['temp'];

          final results = "city: $city\nstate: $state\nCur temp: $currTemp °C";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: MediaQuery.of(context)
                  .size
                  .width, // Set the width to the screen width
              child: Text(results),
            ),
          );
        },
      ),
    );
  }

  /*Widget build(BuildContext context) {

    return FutureBuilder<Map<String, dynamic>?>(
        future: getWeatherInfo(widget.city, widget.country),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the future is still loading, return a loading indicator
            return Center(child: CircularProgressIndicator());
          }
          final Map<String, dynamic> recent = snapshot.data!;
          print(recent[0]['temp']);
          //${snapshot.data!['data'][0]['temp']}
          final results =
              "city: city\ncountry: $widget.country\nMax Temp today: \n";
          return Scaffold(
            appBar: AppBar(title: const Text("Weather Results", maxLines: 1)),
            body: SingleChildScrollView(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(results)),
            ),
          );
        });
  }*/
}
