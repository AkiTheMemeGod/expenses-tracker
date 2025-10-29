import 'package:expenses_tracker/pages/categories_page.dart';
import 'package:expenses_tracker/pages/subcategories_page.dart';
import 'package:expenses_tracker/pages/userprofile_page.dart';
import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';
import '../utils/widgets/app_bars.dart';

import 'package:expenses_tracker/theme/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MinimalAppBar(title: 'Settings'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // Theme section
            Card(
              child: AnimatedBuilder(
                animation: ThemeController.instance,
                builder: (context, _) {
                  final current = ThemeController.instance.mode;
                  final dark = current == ThemeMode.dark;
                  return SwitchListTile(
                    title: const Text('Dark Mode'),
                    value: dark,
                    onChanged: (val) => ThemeController.instance.toggle(val),
                    secondary: const Icon(Icons.brightness_6),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Quick links - responsive wrap
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                int columns = 2;
                if (width >= 900) columns = 3; // desktop
                if (width < 360) columns = 1;   // very narrow
                const spacing = 12.0;
                final itemWidth = (width - spacing * (columns - 1)) / columns;

                Widget linkCard(IconData icon, String label, VoidCallback onTap) {
                  return SizedBox(
                    width: itemWidth,
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: onTap,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icon, size: 32),
                              const SizedBox(height: 10),
                              Text(label, textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    linkCard(
                      Icons.person,
                      'User Profile',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserProfilePage()),
                      ),
                    ),
                    linkCard(
                      Icons.category,
                      'Categories',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CategoriesPage()),
                      ),
                    ),
                    linkCard(
                      Icons.subdirectory_arrow_right,
                      'Subcategories',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SubcategoriesPage()),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 60),
            TextScroll(
              textAlign: TextAlign.end,
              'Daily Expenses Tracker developed By Kumar Sundaram. Copyright © 2025. All rights reserved.',
              velocity: const Velocity(pixelsPerSecond: Offset(25, 0)),
              delayBefore: const Duration(milliseconds: 500),
              pauseBetween: const Duration(milliseconds: 50),
              style: Theme.of(context).textTheme.bodySmall,
              selectable: true,
            ),
          ],
        ),
      ),
    );
  }
}
