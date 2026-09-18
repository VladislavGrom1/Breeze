import 'package:breeze/app/theme/custom_text_style.dart';
import 'package:breeze/data/model/current_weather_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WindWeatherWidget extends StatelessWidget {
  final CurrentWeatherInfo? currentWeatherInfo;

  const WindWeatherWidget({super.key, required this.currentWeatherInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 39, 128, 200),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "Ветер", 
                  style: CustomTextStyle.titleMedium.copyWith(
                    color: const Color.fromARGB(221, 116, 188, 247)
                  )
                ),
                SizedBox(width: 5),
                SvgPicture.asset(
                  "assets/weather_icons/ic_wind.svg",
                  colorFilter: ColorFilter.mode(const Color.fromARGB(221, 116, 188, 247), BlendMode.srcIn),
                  width: 15,
                  height: 15,
                )
              ],
            ),
            const SizedBox(height: 10),
            _buildRowInfo(
              "Скорость ветра", 
              "${currentWeatherInfo?.windSpeed10m} м/c"
            ),
            const SizedBox(height: 10),
            _buildRowInfo(
              "Макс. скорость ветра", 
              "${currentWeatherInfo?.windGusts10m} м/c"
            ),
            const SizedBox(height: 10),
            _buildRowInfo(
              "Направление ветра", 
              "${currentWeatherInfo?.windDirection10m}°"
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowInfo(String title, String value) {
    return SizedBox(
      width: 240,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: CustomTextStyle.body.copyWith(
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            value,
            style: CustomTextStyle.body.copyWith(
              color: const Color.fromARGB(221, 116, 188, 247),
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
