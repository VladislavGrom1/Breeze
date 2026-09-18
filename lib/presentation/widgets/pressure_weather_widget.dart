import 'package:breeze/app/theme/custom_text_style.dart';
import 'package:breeze/data/model/current_weather_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PressureWeatherWidget extends StatelessWidget {
  final CurrentWeatherInfo? currentWeatherInfo;
  
  const PressureWeatherWidget({
    super.key,
    required this.currentWeatherInfo
  });

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
                  "Давление", 
                  style: CustomTextStyle.titleMedium.copyWith(
                    color: const Color.fromARGB(221, 116, 188, 247)
                  )
                ),
                SizedBox(width: 5),
                SvgPicture.asset(
                  "assets/weather_icons/ic_pressure.svg",
                  colorFilter: ColorFilter.mode(const Color.fromARGB(221, 116, 188, 247), BlendMode.srcIn),
                  width: 10,
                  height: 10,
                )
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Text(
                  "${currentWeatherInfo?.pressureMsl}",
                  style: CustomTextStyle.titleRegular.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  "мм рт. ст.",
                  style: CustomTextStyle.body.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}