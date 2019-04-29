import 'package:flutter/cupertino.dart';
import 'dart:ui';

Widget LoadingWidget() => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: CupertinoActivityIndicator(
        radius: 10.0,
        animating: true,
      ),
    );
