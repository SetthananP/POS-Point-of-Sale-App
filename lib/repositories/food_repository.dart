import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/food_model.dart';

class FoodRepository {
  Future<List<Food>> loadFoodData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/data_test.json');
      debugPrint("✅ JSON Loaded Successfully");

      final Map<String, dynamic>? data = json.decode(response);

      if (data == null || !data.containsKey('result')) {
        throw Exception("❌ Invalid JSON structure: Missing 'result' key");
      }

      Map<String, dynamic> foodSetsMap = {};
      if (data['result'].containsKey('foodSet')) {
        List<dynamic> foodSetList = data['result']['foodSet'] as List;

        foodSetList.sort((a, b) =>
            (a['foodSetSorting'] ?? 999).compareTo(b['foodSetSorting'] ?? 999));

        for (var foodSet in foodSetList) {
          foodSetsMap[foodSet['foodSetId']] = foodSet;
        }
      }

      Map<String, dynamic> foodCatsMap = {};
      if (data['result'].containsKey('foodCategory')) {
        List<dynamic> foodCatList = data['result']['foodCategory'] as List;

        foodCatList.sort((a, b) =>
            (a['foodCatSorting'] ?? 999).compareTo(b['foodCatSorting'] ?? 999));

        for (var foodCat in foodCatList) {
          foodCatsMap[foodCat['foodCatId']] = foodCat;
        }
      }

      List<Food> foods = (data['result']['food'] as List?)
              ?.map((e) => Food.fromJson(e,
                  foodSetsMap: foodSetsMap, foodCatsMap: foodCatsMap))
              .toList() ??
          [];
      return foods;
    } catch (e) {
      debugPrint("❌ JSON Load Error: $e");
      throw Exception("Failed to load food data: $e");
    }
  }
}
