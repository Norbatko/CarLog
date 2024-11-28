import 'package:flutter/material.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/widgets/theme/theme_setter.dart';

class ThemeColorPicker extends StatelessWidget {
  const ThemeColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> ShowedColors = Colors.primaries.sublist(0, 15);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Theme:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true, // Allows GridView inside a column
          physics: const NeverScrollableScrollPhysics(), // Disables scrolling
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, // 5 colors per row
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: ShowedColors.length,
          itemBuilder: (context, index) {
            final color = ShowedColors[index];
            return GestureDetector(
              onTap: () => _changeColor(color),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(
                    color: Colors.black.withOpacity(0.2),
                    width: 1.0,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _changeColor(Color color) {
    final themeProvider = get<ThemeProvider>();
    themeProvider.updateTheme(
      ColorScheme.fromSeed(seedColor: color),
    );
  }
}
