import 'package:flutter/material.dart';
import 'package:icloudmusic/utils/sound.dart';
class LinearGradientBar extends StatefulWidget{
  final ValueNotifierData maxDuration;
  final ValueNotifierData value;
  final callback;
  LinearGradientBar({Key key,
    @required this.maxDuration,
    @required this.value,
    @required this.callback
  }):super(key:key);
  _LinearGradientBar createState() => _LinearGradientBar();
}
class _LinearGradientBar extends State<LinearGradientBar>{
  void _handleValueChanged() {
    try{
      setState(() {});
    }catch (e){}
  }
  @override
  void initState() {
    super.initState();
    widget.value.addListener(_handleValueChanged);
    widget.maxDuration.addListener(_handleValueChanged);
  }
  @override
  void dispose() {
    widget.value.removeListener(_handleValueChanged);
    widget.maxDuration.removeListener(_handleValueChanged);
    widget.maxDuration.dispose();
    widget.value.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
    Container(
    width: double.infinity,
      height: 50,
      alignment: Alignment.bottomLeft,
      child: Container(
        width: (widget.value.value / widget.maxDuration.value) * 414.0,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[
                Color.fromRGBO(204, 171, 218, 0.8),
                Color.fromRGBO(233, 136, 124, 0.8)
              ]
          ),
        ),
      ),
    ),

        Slider(
            onChanged: (double value) {
              if(PlaySound.flutterSound.isPlaying){
                widget.callback(value);
              }
            },
            onChangeEnd: (double value) async {
              if(PlaySound.flutterSound.isPlaying){
                PlaySound.seek(value.toInt());
              }
            },
            value: widget.value.value,
            min: 0.0,
            max: widget.maxDuration.value,
            activeColor: Colors.transparent,
            inactiveColor: Colors.transparent
        )
      ],
    );
  }
}