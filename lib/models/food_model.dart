import 'package:equatable/equatable.dart';

class Food extends Equatable {
  final String foodId;
  final String foodName;
  final String foodSetId;
  final String foodSetName;
  final int foodSetSorting;
  final String foodCatId;
  final String foodCatName;
  final int foodCatSorting;
  final double foodPrice;
  final String foodDesc;
  final String imageName;
  final bool isOutStock;
  final bool isShow;
  final bool isFree;
  final int foodSorting;

  const Food( {
    required this.foodId,
    required this.foodName,
    required this.foodSetId,
    required this.foodSetName,
    required this.foodSetSorting,
    required this.foodCatId,
    required this.foodCatName,
    required this.foodCatSorting,
    required this.foodPrice,
    required this.foodDesc,
    required this.imageName,
    required this.isOutStock,
    required this.isShow,
    required this.isFree,
    required this.foodSorting,
  });

  factory Food.fromJson(Map<String, dynamic> json,
      {Map<String, dynamic>? foodSetsMap, Map<String, dynamic>? foodCatsMap}) {
    return Food(
      foodId: json['foodId'] ?? '',
      foodName: json['foodName'] ?? '',
      foodSetId: json['foodSetId'] ?? '',
      foodSetName:
          foodSetsMap?[json['foodSetId']]?['foodSetName'] ?? 'Unknown Set',
      foodSetSorting: foodSetsMap?[json['foodSetId']]?['foodSetSorting'] ?? 999,
      foodCatId: json['foodCatId'] ?? '',
      foodCatName:
          foodCatsMap?[json['foodCatId']]?['foodCatName'] ?? 'General Items',
      foodCatSorting: foodCatsMap?[json['foodCatId']]?['foodCatSorting'] ?? 999,
      foodPrice: (json['foodPrice'] as num?)?.toDouble() ?? 0.0,
      foodDesc: json['foodDesc'] ?? '',
      imageName:
          (json['imageName'] != null && json['imageName'].trim().isNotEmpty)
              ? json['imageName']
              : 'assets/no_image.png',

      isOutStock: json['isOutStock'] ?? false,
      isShow: json['isShow'] ?? false,
      isFree: json['isFree'] ?? false,
      foodSorting: json['foodSorting'] ?? 999,
    );
  }

  @override
  List<Object?> get props => [
        foodId,
        foodName,
        foodSetId,
        foodSetSorting,
        foodSetName,
        foodCatId,
        foodCatSorting,
        foodCatName,
        foodPrice,
        foodDesc,
        imageName,
        foodSorting
      ];
}
