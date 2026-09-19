import 'package:breeze/app/theme/custom_text_style.dart';
import 'package:breeze/data/model/current_weather_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HumidityWeatherWidget extends StatelessWidget {
  final CurrentWeatherInfo? currentWeatherInfo;
  
  const HumidityWeatherWidget({
    super.key,
    required this.currentWeatherInfo
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 39, 128, 200).withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    "Влажность",
                    style: CustomTextStyle.titleMedium.copyWith(
                      color: const Color.fromARGB(221, 116, 188, 247)
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 5),
                SvgPicture.asset(
                  "assets/weather_icons/ic_drop.svg",
                  colorFilter: ColorFilter.mode(const Color.fromARGB(221, 116, 188, 247), BlendMode.srcIn),
                  width: 15,
                  height: 15,
                )
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Text(
                  "${currentWeatherInfo?.relativeHumidity2m}%",
                  style: CustomTextStyle.titleRegular.copyWith(
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