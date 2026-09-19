import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherBackgroundWidget extends StatefulWidget {
  const WeatherBackgroundWidget({super.key});

  @override
  State<WeatherBackgroundWidget> createState() => _WeatherBackgroundWidgetState();
}

class _WeatherBackgroundWidgetState extends State<WeatherBackgroundWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(vsync: this);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.25,
        child: Lottie.asset(
          'assets/animations/sunrise.json',
          controller: _animationController,
          onLoaded: (composition) {
            _animationController
              ..duration = composition.duration
              ..repeat(period: composition.duration * 1.5);
          },
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
