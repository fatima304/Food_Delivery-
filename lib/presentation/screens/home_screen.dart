import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../widgets/app_nav.dart';
import '../widgets/section_list.dart';
import '../widgets/ui_parts.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: const AppNav(index: 0),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        children: [
          Row(
            children: [
              const Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.location_on,
                    color: AppColors.primaryGreen,
                  ),
                  title: Text('Cairo, Egypt'),
                  subtitle: Text('Deliver to your location'),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
                icon: const Icon(Icons.brightness_6_outlined),
              ),
            ],
          ),
          TextField(
            readOnly: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search for meals or vendors',
              filled: true,
              fillColor: AppColors.fieldBackground,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 165,
            child: PageView(
              children: [
                for (final title in [
                  'Special Offers • Up to 50% OFF',
                  'Fresh meals near you',
                  'Street food favourites',
                ])
                  Card(
                    color: AppColors.lightGreen,
                    elevation: 0,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(child: FoodPhoto(height: 150)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SectionHeading('Categories'),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GreenTag('🍔 Burger'),
                SizedBox(width: 8),
                GreenTag('🍕 Pizza'),
                SizedBox(width: 8),
                GreenTag('🍗 Chicken'),
                SizedBox(width: 8),
                GreenTag('🥗 Salad'),
              ],
            ),
          ),
          const SectionHeading('Hot Offers'),
          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < 5; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 145,
                      child: Column(
                        children: [
                          const FoodPhoto(height: 90),
                          Text('Offer ${i + 1} • Save 20%'),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SectionHeading('Popular Meals'),
          const MealGrid(),
        ],
      ),
    ),
  );
}
