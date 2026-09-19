import 'dart:async';
import 'package:breeze/app/service_provider.dart';
import 'package:breeze/app/theme/app_breakpoints.dart';
import 'package:breeze/data/model/geocode_result.dart';
import 'package:breeze/data/model/weather_location.dart';
import 'package:breeze/presentation/weather_controller.dart';
import 'package:breeze/presentation/widgets/search_panel_widget.dart';
import 'package:breeze/presentation/widgets/weather_background_widget.dart';
import 'package:breeze/presentation/widgets/weather_info_panel_widget.dart';
import 'package:flutter/material.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late final WeatherController _weatherController;
  final _searchController = TextEditingController();
  final _searchScrollController = ScrollController();
  final _weatherScrollController = ScrollController();
  bool _initialized = false;
  Timer? _debounce;
  bool _isSearchOpenOnMobile = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final repository = ServiceProvider.of(context);
      _weatherController = WeatherController(repository);
      _initialized = true;
      _weatherController.getSavedLocations();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    if (value.isEmpty) {
      _weatherController.getSavedLocations();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 200), () {
      _weatherController.searchCities(value);
    });
  }

  Future<void> _onCitySelected(GeocodeResult city) async {
    await _weatherController.selectCity(city);
    _closeSearchOnMobile();
  }

  Future<void> _onLocationSelected(WeatherLocation location) async {
    await _weatherController.getWeather(location);
    _closeSearchOnMobile();
  }

  void _closeSearchOnMobile() {
    if (mounted && _isSearchOpenOnMobile) {
      setState(() => _isSearchOpenOnMobile = false);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _weatherController.dispose();
    _searchController.dispose();
    _searchScrollController.dispose();
    _weatherScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 119, 178, 225),
      body: Stack(
        children: [
          const WeatherBackgroundWidget(),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              if (AppBreakpoints.isCompact(width)) {
                return _buildCompactLayout();
              }
              return _buildWideLayout(
                fixedSearchWidth: AppBreakpoints.isMedium(width) ? 340.0 : null,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCompactLayout() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.03),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: _isSearchOpenOnMobile
          ? SearchPanelWidget(
              key: const ValueKey('search'),
              weatherController: _weatherController,
              searchController: _searchController,
              scrollController: _searchScrollController,
              onSearchChanged: _onSearchChanged,
              onCitySelected: _onCitySelected,
              onLocationSelected: _onLocationSelected,
              padding: const EdgeInsets.all(16),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => setState(() => _isSearchOpenOnMobile = false),
              ),
            )
          : WeatherInfoPanelWidget(
              key: const ValueKey('weather'),
              weatherController: _weatherController,
              scrollController: _weatherScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              topBar: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton.filled(
                    icon: const Icon(Icons.search),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 25, 41, 61).withValues(alpha: 0.6),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => setState(() => _isSearchOpenOnMobile = true),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildWideLayout({double? fixedSearchWidth}) {
    final searchPanel = SearchPanelWidget(
      weatherController: _weatherController,
      searchController: _searchController,
      scrollController: _searchScrollController,
      onSearchChanged: _onSearchChanged,
      onCitySelected: _onCitySelected,
      onLocationSelected: _onLocationSelected,
    );

    final weatherPanel = WeatherInfoPanelWidget(
      weatherController: _weatherController,
      scrollController: _weatherScrollController,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        fixedSearchWidth != null
            ? SizedBox(width: fixedSearchWidth, child: searchPanel)
            : Expanded(flex: 1, child: searchPanel),
        Expanded(flex: 2, child: weatherPanel),
      ],
    );
  }
}
