import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/src/common/constants/appAnimations.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //  api key
  final _weatherService = WeatherService('d1fce9d00ec210d8e7996de61e153665');
  Weather? _weather;
  //  fetch weather
  _fetchWeather() async {
    //  fetch the current city
    String cityName = await _weatherService.getCurrentCity();
    //  fetch the weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    //  for any error
    catch (e) {
      print(e);
    }
  }

  //  weather animation
  String getWeatherAnimation(String mainCondition) {
    if (mainCondition == null) return 'assets/animations/snow.json';

    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return AppAnimations.sunny;
      case 'clouds':
        return AppAnimations.clouds;
      case 'mist':
        return AppAnimations.mist;
      case 'smoke':
        return AppAnimations.mist;
      case 'haze':
      case 'dust':
      case 'fog':
        return AppAnimations.mist;
      case 'rain':
        return AppAnimations.rain;
      case 'snow':
        return AppAnimations.snow;
      case 'thunderstorm':
        return AppAnimations.thunderstorm;
      default:
        return AppAnimations.sunny;
    }
  }

  // init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "Loading City ..."),
            _weather == null
              ? CircularProgressIndicator() // Show a loading indicator while data is being fetched
              : Lottie.asset(getWeatherAnimation(_weather!.mainCondition)),
            Text('${_weather?.temperature.round().toString()} C'),
            Text('${_weather?.mainCondition}'),
          ],
        ),
      ),
    );
  }
}
