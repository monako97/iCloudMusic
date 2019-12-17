import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:icloudmusic/utils/sound.dart';
// ignore: must_be_immutable
class LikeMaterialButton extends StatefulWidget {
  final bool type;
  bool like;
  final callback;
  LikeMaterialButton({
    Key key,
    @required this.type,
    @required this.like,
    @required this.callback
  }) : super(key: key);
  @override
  _LikeMaterialButton createState() => _LikeMaterialButton();
}
class _LikeMaterialButton extends State<LikeMaterialButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.like =! widget.like;
          widget.callback();
          setState(() {});
        },
        splashColor: Colors.pinkAccent[100],
        borderRadius: BorderRadius.circular(84.0),
        child: Container(
          width: 65.0,
          height: 65.0,
          padding: EdgeInsets.all(21.0),
          child: widget.type ? FlareActor(
              "assets/flare/love.flr",
              animation: widget.like ? "Favorite" : "Unfavorite",
              shouldClip: false
          ) : Icon(Icons.close),
        )
    );
  }
}
class PlayButton extends StatefulWidget{
  final ValueNotifierData state; // 监听
  final callback;
  PlayButton({
    Key key,
    this.callback,
    @required this.state
}):super(key:key);
  @override
  _PlayButton createState() => _PlayButton();
}
class _PlayButton extends State<PlayButton>{
  bool _state;
  @override
  initState() {
    super.initState();
    widget.state.addListener(_handleValueChanged);
  }
  @override
  void dispose() {
    widget.state.removeListener(_handleValueChanged);
    super.dispose();
  }
  void _handleValueChanged() {
        try{
          print("播放按钮状态改变: ${widget.state.value}");
          setState(() {});
        }catch (e){}
  }
  @override
  Widget build(BuildContext context) {
    _state = widget.state.value == "play";
    return  GestureDetector(
        onTap: () {
          PlaySound.play(null,(value,maxDuration,state){
            widget.callback(value,maxDuration,state);
          });
        },
        child: Stack(
          children: <Widget>[
            FlareActor(
              "assets/flare/playpause.flr",
              animation: _state ? "play" : "pause",
              color: Color.fromRGBO(176, 139, 227, 1.0),
              fit: BoxFit.fitHeight,
            ),
            FlareActor(
              "assets/flare/counter.flr",
              animation: _state ? "play" : "",
              isPaused: _state ? false : true,
            ),
          ],
        )
    );
  }
}

