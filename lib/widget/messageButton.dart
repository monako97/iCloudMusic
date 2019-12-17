import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
class MessageButton extends StatefulWidget{
  @override
  _MessageButton createState()=> _MessageButton();
}
class _MessageButton extends State<MessageButton>{
  bool _msgNew = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this._msgNew = !(this._msgNew ?? false);
        setState(() {});
      },
      child: Container(
        width: 35.0,
        alignment: Alignment.centerRight,
        child: FlareActor(
          "assets/flare/msg.flr",
          animation: this._msgNew ? "Notification Loop" : "",
          isPaused: this._msgNew,
          fit: BoxFit.cover,
          shouldClip: false,
        ),
      ),
    );
  }

}