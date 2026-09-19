import 'package:breeze/app/theme/custom_text_style.dart';
import 'package:breeze/data/model/geocode_result.dart';
import 'package:breeze/data/model/weather_location.dart';
import 'package:breeze/presentation/city_search_state.dart';
import 'package:breeze/presentation/weather_controller.dart';
import 'package:flutter/material.dart';


class SearchPanelWidget extends StatelessWidget {
  final WeatherController weatherController;
  final TextEditingController searchController;
  final ScrollController scrollController;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<GeocodeResult> onCitySelected;
  final ValueChanged<WeatherLocation> onLocationSelected;

  final EdgeInsets padding;
  final Widget? leading;

  const SearchPanelWidget({
    super.key,
    required this.weatherController,
    required this.searchController,
    required this.scrollController,
    required this.onSearchChanged,
    required this.onCitySelected,
    required this.onLocationSelected,
    this.padding = const EdgeInsets.all(20),
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 25, 41, 61).withValues(alpha: 0.5),
      child: SafeArea(
        child: Padding(
          padding: padding,
          child: Column(
            children: [
              if (leading != null) ...[
                Align(alignment: Alignment.centerLeft, child: leading),
                const SizedBox(height: 8),
              ],
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 51, 63, 70),
                  label: Text(
                    "Поиск",
                    style: CustomTextStyle.titleMedium.copyWith(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: searchController,
                    builder: (context, value, _) {
                      if (searchController.text.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          searchController.clear();
                          onSearchChanged('');
                        },
                      );
                    },
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 20),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                style: CustomTextStyle.titleMedium,
                textInputAction: TextInputAction.search,
                onChanged: onSearchChanged,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ValueListenableBuilder<CitySearchState>(
                  valueListenable: weatherController.searchState,
                  builder: (context, searchState, _) {
                    switch (searchState.status) {
                      case CitySearchStatus.initial:
                        return const SizedBox.shrink();
                      case CitySearchStatus.loading:
                        return const Center(child: CircularProgressIndicator());
                      case CitySearchStatus.error:
                        return Center(
                          child: SelectableText('Ошибка: ${searchState.errorMessage}'),
                        );
                      case CitySearchStatus.loaded:
                        return _buildResultsList(searchState);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList(CitySearchState searchState) {
    final query = searchController.text.trim();
    final hasQuery = query.isNotEmpty;
    final items = hasQuery ? searchState.searchResults : searchState.savedLocations;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasQuery ? Icons.not_listed_location : Icons.location_off,
              size: 80,
              color: Colors.white,
            ),
            Text(
              hasQuery ? "Локации не найдены" : "Нет сохранённых локаций",
              style: CustomTextStyle.titleRegular,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              hasQuery ? "Измените запрос" : "Введите название локации в поиске",
              style: CustomTextStyle.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverList.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (hasQuery) {
                final city = searchState.searchResults[index];
                return Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    title: Text(city.name, style: CustomTextStyle.titleMedium),
                    subtitle: city.country != null
                        ? Text(
                            city.country!,
                            style: CustomTextStyle.titleMedium.copyWith(fontSize: 12, color: Colors.white),
                          )
                        : null,
                    trailing: const Icon(Icons.chevron_right, color: Colors.white),
                    onTap: () => onCitySelected(city),
                  ),
                );
              } else {
                final location = searchState.savedLocations[index];
                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    tileColor: const Color.fromARGB(255, 51, 63, 70),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Text(
                      location.label ?? "Имя отсутствует",
                      style: CustomTextStyle.titleBold.copyWith(fontSize: 20),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ш:${location.latitude} Д:${location.longitude}", style: CustomTextStyle.subtitle),
                        const SizedBox(height: 20),
                        Text(location.timezone ?? "-", style: CustomTextStyle.subtitle),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async => weatherController.deleteSavedLocation(location),
                    ),
                    onTap: () => onLocationSelected(location),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
