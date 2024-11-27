import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:car_log/widgets/theme/theme_setter.dart';

class ThemeColorPicker extends StatelessWidget {
  const ThemeColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: Colors.primaries.map((color) {
        return GestureDetector(
          onTap: () => _changeColor(color),
          child: CircleAvatar(
            backgroundColor: color,
            radius: 18,
          ),
        );
      }).toList(),
    );
  }

  void _changeColor(Color color) {
    final themeProvider = get<ThemeProvider>();
    themeProvider.updateTheme(
      ColorScheme.fromSeed(seedColor: color),
    );
  }
}
