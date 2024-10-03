import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TravelBalance/models/expense.dart';

Widget categoryIcon(Category category, [double sizeMultipier = 1]) {
  Map<Category, MapEntry<IconData, Color>> categoryIcon = {
    Category.activities:
        const MapEntry(Icons.local_activity, Color(0xFF800080)),
    Category.accommodation: const MapEntry(Icons.hotel, Color(0xFFFCAC12)),
    Category.food: const MapEntry(Icons.restaurant, Color(0xFF008000)),
    Category.health: const MapEntry(Icons.local_hospital, Color(0xFFFF0000)),
    Category.shopping: const MapEntry(Icons.shopping_bag, Color(0xFFFFA0B1)),
    Category.transport: const MapEntry(Icons.directions_car, Color(0xFF0077FF)),
    Category.souvenirs: const MapEntry(Icons.card_giftcard, Color(0xFF9C8B71)),
    Category.others: const MapEntry(Icons.category, Color(0xFF7F3DFF)),
  };

  IconData icon = categoryIcon[category]?.key ?? Icons.error;
  Color color = categoryIcon[category]?.value ?? Colors.grey;

  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 60.w * sizeMultipier,
        height: 60.h * sizeMultipier,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: color.withOpacity(0.2),
        ),
      ),
      Icon(
        icon,
        size: 40.h * sizeMultipier,
        color: color,
      ),
    ],
  );
}
