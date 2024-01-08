import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/components/my_button.dart';
import 'package:weather_app/components/my_text_field.dart';

class TextPage extends StatefulWidget {
  final String city;
  final String country;
  final void Function()? onPressed;
  const TextPage(
      {super.key, required this.city, required this.country, this.onPressed});

  @override
  State<TextPage> createState() => _Text();
}

class _Text extends State<TextPage> {
  double maxTemp = 0.0;
  double minTemp = 0.0;
  double currTemp = 0.0;
  Future<List> callWeatherAPI(String city, String country) async {
    try {
      String api_key = "cad31c7091c048b1ae88e949b5167636";

      String api =
          'http://api.weatherbit.io/v2.0/current?city=${city}&country=${country}=US&key=${api_key}&include=minutely';
      final resp = await http.get(Uri.parse(api));
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

  void getWeatherInfo(String city, String country) async {
    List weather_info = await callWeatherAPI(widget.city, widget.country);
    List<double> temps = collectTemps(weather_info[1]);

    maxTemp = max_elem(temps);
    minTemp = min_elem(temps);
    print("in get info, $minTemp");
    currTemp = weather_info[1][0]['temp'];
    print(city + minTemp.toString() + currTemp.toString());
  }

  void showRecent() {}
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String city = widget.city;
    String country = widget.country;
    final title = "$city, $country";
    print("In bild $maxTemp");
    getWeatherInfo(widget.city, widget.country);
    final results =
        "city: $city\ncountry: $country\nMax Temp today:$maxTemp•C\nMin Temp today:$minTemp•C\nCur temp:$currTemp•C";
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Center(child: Text(results)),
          MyButton(onTap: showRecent, text: "Get Latest Search"),
        ],
      ),
    );
  }
}
