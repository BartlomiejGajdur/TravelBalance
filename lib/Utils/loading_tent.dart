import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LoadingTent extends StatefulWidget {
  @override
  _LoadingTentState createState() => _LoadingTentState();
}

class _LoadingTentState extends State<LoadingTent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Inicjalizacja kontrolera animacji
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    // Powtarzanie animacji w obie strony
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse(); // Cofanie animacji
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward(); // Ponowne odtwarzanie do przodu
      }
    });

    // Start animacji
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Zwolnienie zasobów
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 100.h,
          child: Lottie.asset(
            'lib/assets/lottie/LoadingTentAnimation.json',
            controller: _controller, // Powiązanie kontrolera
            onLoaded: (composition) {
              _controller.duration = composition.duration;
            },
            fit: BoxFit.contain, // Dopasowanie do kontenera
          ),
        ),
      ],
    );
  }
}
