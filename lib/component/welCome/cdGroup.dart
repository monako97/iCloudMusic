import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:icloudmusic/const/deviceInfo.dart';
import 'package:icloudmusic/utils/sound.dart';
class CDName extends StatefulWidget{
  final ValueNotifierData text; // 监听
  final String fontFamily;
  final double size;
  CDName({
    Key key,
    @required this.text,
    @required this.fontFamily,
    @required this.size
  }):super(key:key);
  CDNames createState() => CDNames();
}
class CDNames extends State<CDName>{
  @override
  initState() {
    super.initState();
    widget.text.addListener(_handleValueChanged);
  }
  @override
  void dispose() {
    widget.text.removeListener(_handleValueChanged);
    widget.text.dispose();
    super.dispose();
  }
  void _handleValueChanged(){
    try{
      setState(() {});
    }catch (e){}
  }
  @override
  Widget build(BuildContext context) {
    return Text(widget.text.value, style: TextStyle(
        fontSize: widget.size,
        fontFamily: widget.fontFamily,
        color: Color.fromRGBO(24, 29, 40, 1)
    ));
  }
}
class CdGroup extends StatefulWidget{
  final List data;
  final callback;
  final getData;
  final ValueNotifierData state;
  CdGroup({
    Key key,
    @required this.callback,
    @required this.data,
    @required this.getData,
    @required this.state
}):super(key:key);
  @override
  _CdGroup createState() =>_CdGroup();
}
class _CdGroup extends State<CdGroup>{
  final ValueNotifierData playIndex = ValueNotifierData(0);
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    widget.state.dispose();
    playIndex.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            height: DeviceInfo.height < 570 ? 250.0 : 300.0,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return CDContainer(
                  img: widget.data[index]['img1v1Url'],
                  playIndex: playIndex,
                  idx: index,
                  state: widget.state,
                );
              },
              onIndexChanged: (i) {
                widget.getData(widget.data[i], i);
                PlaySound.startPlay(widget.data[i]['url'], (state,value,maxDuration){
                  widget.callback(state,value,maxDuration);
                  if(state!="play"){
                    playIndex.value = i;
                  }
                });
                playIndex.value = i;
              },
              itemCount: widget.data.length,
              viewportFraction: 0.70,
              scale: 0.6,
            )
        )
      ],
    );
  }
}
// ignore: must_be_immutable
class CDContainer extends StatefulWidget{
  final ValueNotifierData playIndex;
  final ValueNotifierData state;
  final int idx;
  final String img;
  CDContainer({
    Key key,
    @required this.img,
    @required this.playIndex,
    @required this.idx,
    @required this.state
}):super(key:key);
  @override
  _CDContainer createState() => _CDContainer();
}
class _CDContainer extends State<CDContainer> with SingleTickerProviderStateMixin{
  // with 是dart的关键字，意思是混入，就是说可以将一个或者多个类的功能添加到自己的类，无需继承这些类，避免多重继承导致的问题
  AnimationController _controller;
  _repeat(){
    try{
      setState(() {
        if(widget.state.value == "play" && widget.idx == widget.playIndex.value){
          _controller.repeat();
        }else{
          _controller.stop();
        }
      });
    }catch(e){}
  }

  @override
  void initState() {
    _controller = AnimationController(
        duration: Duration(seconds: 15),
        vsync: this
    );
    widget.playIndex.addListener(_repeat);
    widget.state.addListener(_repeat);
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    widget.playIndex.removeListener(_repeat);
    widget.state.removeListener(_repeat);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: DeviceInfo.height < 570 ? 118.0 : 137.5,
      backgroundColor: Colors.grey[100],
      child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget child) {
            return Transform.rotate(
                angle: _controller.value * 2 * pi,
                child: child
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: DeviceInfo.height < 570 ? 112.0 : 139.5,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                widget.img,
              ),
              backgroundColor: Colors.white,
              radius: 130.0,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 27.5,
                child: CircleAvatar(
                  backgroundColor: Color.fromRGBO(
                      192, 193, 193, 0.35),
                  radius: 23.0,
                ),
              ),
            ),
          )
      ),
    );
  }
}