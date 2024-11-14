import 'package:TravelBalance/Utils/category_item.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void _emptyCallback() {}

class ChooseCategory extends StatefulWidget {
  final Function() onCategoryClick;
  final TextEditingController? textController;
  final String initialCategoryName;

  const ChooseCategory({
    super.key,
    required this.initialCategoryName,
    this.onCategoryClick = _emptyCallback,
    this.textController,
  });

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategoryName;
    if (widget.textController != null) {
      widget.textController!.text = widget.initialCategoryName;
    }
  }

  bool _isCategoryMatch(Category category) {
    return _selectedCategory == Expense.staticCategoryToString(category);
  }

  Widget _clickableCategoryIcon(Category category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = Expense.staticCategoryToString(category);
        });
        if (widget.textController != null) {
          widget.textController!.text = _selectedCategory;
        }
        widget.onCategoryClick();
      },
      child: SizedBox(
        width: 85.w,
        child: Column(
          children: [
            categoryIcon(category, _isCategoryMatch(category)),
            Text(
              Expense.staticCategoryToString(category),
              style: TextStyle(
                color: _isCategoryMatch(category) ? primaryColor : Colors.black,
                fontSize: 9.sp,
                fontWeight: _isCategoryMatch(category)
                    ? FontWeight.w800
                    : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245.h,
      width: double.infinity,
      color: const Color(0xFFFAFAFA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.h),
          Text(
            "CHOOSE CATEGORY",
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _clickableCategoryIcon(Category.activities),
              _clickableCategoryIcon(Category.accommodation),
              _clickableCategoryIcon(Category.food),
              _clickableCategoryIcon(Category.health),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _clickableCategoryIcon(Category.shopping),
              _clickableCategoryIcon(Category.transport),
              _clickableCategoryIcon(Category.souvenirs),
              _clickableCategoryIcon(Category.others),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
