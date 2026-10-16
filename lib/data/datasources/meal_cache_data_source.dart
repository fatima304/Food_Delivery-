import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal_model.dart';
import '../models/meal_category_model.dart';

/// Best-effort persistent cache. Each menu category has a separate key.
class MealCacheDataSource {
  static const _prefix = 'streetbite_menu_v1_';

  Future<List<MealModel>?> readMeals(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('$_prefix$key');
      if (raw == null) return null;
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map(
            (item) =>
                MealModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } catch (_) {
      await _clear('$_prefix$key');
      return null;
    }
  }

  Future<void> saveMeals(String key, List<MealModel> meals) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        '$_prefix$key',
        jsonEncode(meals.map((e) => e.toJson()).toList()),
      );
    } catch (_) {
      /* Cache failures must not block live meals. */
    }
  }

  Future<List<MealCategoryModel>?> readCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('${_prefix}categories');
      if (raw == null) return null;
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map(
            (item) => MealCategoryModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } catch (_) {
      await _clear('${_prefix}categories');
      return null;
    }
  }

  Future<void> saveCategories(List<MealCategoryModel> categories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        '${_prefix}categories',
        jsonEncode(categories.map((e) => e.toJson()).toList()),
      );
    } catch (_) {
      /* Best effort. */
    }
  }

  Future<void> _clear(String key) async {
    try {
      (await SharedPreferences.getInstance()).remove(key);
    } catch (_) {}
  }
}
