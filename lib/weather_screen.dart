import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Additional_Info_Item.dart';
import 'package:weather_app/Secrets.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityname = 'London';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityname,uk&APPID=$openWeatherAPIKey',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw data['message'] ?? 'Something went wrong';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ~AppBar
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      
      // ~ Body
      //. FutureBuilder widget that is used to asynchronously(in different thread) build a widget tree based on the result of a Future.
      // . snapshot stores the result of the future computation (asynchronous computation) .
      // . snapshot has two properties: data and error.
      // 1. data is the latest data received by the asynchronous computation.
      // 2. error is the latest error object received by the asynchronous computation.
      // . builder is a function that builds the widget tree based on the latest snapshot of interaction with the asynchronous computation.
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          // - Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          // - Error state
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          // - Data State

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final iconUrl =
              "http://openweathermap.org/img/w/${currentWeatherData["weather"][0]["icon"]}.png";
          final pressure = currentWeatherData['main']['pressure'];
          final humidity = currentWeatherData['main']['humidity'];
          final windSpeed = currentWeatherData['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* main card
                SizedBox(
                  width: double.infinity,
                  // . Here we can't use container because it doesn't have elevation property ,so we use card widget .
                  child: Card(
                    elevation: 10,
                    // color: Colors.blueGrey.shade900,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(16),
                    // ),
                    // . ClipRRect is a widget that clips its child with a rounded rectangle.
                    // . we can also use ClipOval() for circular shape.
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              //* Temperature
                              Text(
                                '$currentTemp°K',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 16),

                              // * Icon
                              Image.network(
                                iconUrl,
                                color: Colors.white,
                              ),

                              const SizedBox(height: 16),

                              // * Weather Description
                              Text(
                                '$currentSky',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // * HourlyForcast cards
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // * Layout
                // . constrians go down: widgets get constrained by their parents
                // Ex: SizedBox(height: 150) -> height goes down
                // . size goes up : widgets get sized by their children with the constraints of their parents
                // Ex: SizedBox(height: 150, child: ListView.builder()) -> width,scroldirection goes up
                // . parent sets position : widgets get positioned by their parents with the constraints of their parents and children
                // Ex: Column(children: [SizedBox(height: 150, child: ListView.builder())]) -> crossAxisAlignment (parent) sets position

                SizedBox(
                  height: 150,
                  // . ListView is a widget that displays a scrollable list of children , It renders only those children that are visible on the screen.
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForcast = data['list'][index + 1];
                      final time =
                          DateTime.parse(hourlyForcast['dt_txt'].toString());
                      return HourlyForcastItem(
                        time: DateFormat.j().format(time),
                        iconUrl:
                            "http://openweathermap.org/img/w/${hourlyForcast["weather"][0]["icon"]}.png",
                        temperature: hourlyForcast['main']['temp'].toString(),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // * Additional Information
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      title: 'Humidity',
                      value: humidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      title: 'Wind Speed',
                      value: windSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      title: 'Pressure',
                      value: pressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
