import 'package:flutter/material.dart';
import 'package:icloudmusic/const/resource.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:ui';

Widget LoadingWidget() => BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
    child: Container(
      height: 150.0,
      width: 150.0,
      child: FlareActor(
        R.ASSET_LOADING_FLR,
        animation: "Untitled",
        fit: BoxFit.contain,
        color: Color.fromRGBO(24, 29, 40, 1),
        shouldClip: false,
      ),
    )
);