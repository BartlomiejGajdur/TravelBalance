import 'dart:ui';

import 'package:flutter/material.dart';

void showBlurDialog({
  required BuildContext context,
  required Widget Function(BuildContext) childBuilder, 
  bool barrierDismissible = true,
  String barrierLabel = '',
  Color barrierColor = Colors.black38,
  Duration transitionDuration = const Duration(milliseconds: 200),
}) {
  showGeneralDialog(
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    transitionDuration: transitionDuration,
    pageBuilder: (ctx, anim1, anim2) => Dialog(
      insetPadding: const EdgeInsets.all(0),
      child: childBuilder(ctx), 
    ),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      child: FadeTransition(
        opacity: anim1,
        child: child,
      ),
    ),
    context: context,
  );
}
