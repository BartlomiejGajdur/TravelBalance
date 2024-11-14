import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TravelBalance/models/expense.dart';

Color localActivityColor = const Color(0xFF800080);
Color accommodationColor = const Color(0xFFFCAC12);
Color foodColor = const Color(0xFF008000);
Color healthColor = const Color(0xFFFF0000);
Color shoppingColor = const Color(0xFFFFA0B1);
Color transportColor = const Color(0xFF0077FF);
Color souvenirsColor = const Color(0xFF9C8B71);
Color othersColor = const Color(0xFF7F3DFF);

Color getCategoryColor(Category category) {
  Map<Category, Color> categoryColors = {
    Category.activities: localActivityColor,
    Category.accommodation: accommodationColor,
    Category.food: foodColor,
    Category.health: healthColor,
    Category.shopping: shoppingColor,
    Category.transport: transportColor,
    Category.souvenirs: souvenirsColor,
    Category.others: othersColor,
  };
  return categoryColors[category] ?? Colors.grey;
}

Widget categoryIcon(Category category, bool? selected,
    [double sizeMultiplier = 1]) {
  Map<Category, MapEntry<IconData, Color>> categoryIcon = {
    Category.activities: MapEntry(Icons.local_activity, localActivityColor),
    Category.accommodation: MapEntry(Icons.hotel, accommodationColor),
    Category.food: MapEntry(Icons.restaurant, foodColor),
    Category.health: MapEntry(Icons.local_hospital, healthColor),
    Category.shopping: MapEntry(Icons.shopping_bag, shoppingColor),
    Category.transport: MapEntry(Icons.directions_car, transportColor),
    Category.souvenirs: MapEntry(Icons.card_giftcard, souvenirsColor),
    Category.others: MapEntry(Icons.category, othersColor),
  };

  IconData icon = categoryIcon[category]?.key ?? Icons.error;
  Color color = categoryIcon[category]?.value ?? Colors.grey;

  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 60.w * sizeMultiplier,
        height: 60.h * sizeMultiplier,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: color.withOpacity(0.2),
            border:
                selected ?? false ? Border.all(color: color, width: 2) : null),
      ),
      Icon(
        icon,
        size: 40.h * sizeMultiplier,
        color: color,
      ),
    ],
  );
}
