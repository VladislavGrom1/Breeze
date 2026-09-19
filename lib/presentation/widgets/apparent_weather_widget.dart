import 'package:breeze/app/theme/custom_text_style.dart';
import 'package:breeze/data/model/current_weather_info.dart';
import 'package:flutter/material.dart';

class ApparentWeatherWidget extends StatelessWidget {
  final CurrentWeatherInfo? currentWeatherInfo;
  
  const ApparentWeatherWidget({
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
                    "Ощущ. как",
                    style: CustomTextStyle.titleMedium.copyWith(
                      color: const Color.fromARGB(221, 116, 188, 247)
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.thermostat, 
                  color: Color.fromARGB(221, 116, 188, 247),
                  size: 15,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Text(
                  "${currentWeatherInfo?.apparentTemperature}°С",
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