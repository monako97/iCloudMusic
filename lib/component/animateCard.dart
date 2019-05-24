import 'package:flutter/material.dart';
import 'package:icloudmusic/const/resource.dart';
class AnimateCard extends StatefulWidget{
  final String title;
  final int number;
  final Color color;
  AnimateCard({Key key,@required this.title,@required this.number,@required this.color}):super(key:key);
  @override
  _AnimateCardState createState()=> _AnimateCardState();
}
class _AnimateCardState extends State<AnimateCard> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    // 创建 AnimationController 对象
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    // 通过 Tween 对象 创建 Animation 对象
    animation = Tween(begin: 50.0, end: 115.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    // 执行动画
    controller.forward();
  }
  @override
  void dispose() {
    // 资源释放
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      // 获取动画的值赋给 widget 的宽高
      width: D.sHeight < 570 ? (D.sWidth/2-25) : 155,
      height: animation.value,
      decoration: BoxDecoration(
          color: widget.color,
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              child: Text(widget.title,
                style: TextStyle(
                  fontFamily: F.SemiBold,
                  fontSize: D.sHeight < 570 ? 16.0 : 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(60))
              ),
              height: 60,
              alignment: Alignment.center,
              child: Text(widget.number.toString(),
                style: TextStyle(
                  fontFamily: F.SemiBold,
                  fontSize: D.sHeight < 570 ? 16.0 : 20.0,
                  color: widget.color,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}