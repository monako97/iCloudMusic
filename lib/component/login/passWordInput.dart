import 'package:flutter/material.dart';
class PassWordInput extends StatefulWidget{
  final setPassWord;
  final double marginTop;
  PassWordInput({
    Key key,
    @required this.setPassWord,
    this.marginTop
  }) : super(key : key);
  @override
  _PassWordInput createState() => _PassWordInput();
}
class _PassWordInput extends State<PassWordInput>{
  final TextEditingController _textEditingController = TextEditingController();
  bool _passWordVisible = false; //密码是否可见
  final OutlineInputBorder inputBorderNone = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  );
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325.0,
      margin: EdgeInsets.only(
        top: widget.marginTop??0
      ),
      child: TextFormField(
        style: TextStyle(
            fontSize: 20.0,
            fontFamily: "SF-UI-Display-Regular"),
        obscureText: !this._passWordVisible,
        controller: _textEditingController,
        cursorColor: Colors.pinkAccent,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: "PassWord",
          filled: true,
          contentPadding: EdgeInsets.only(
              left: 20.0,
              right: 0.0,
              top: 20.0,
              bottom: 20.0),
          focusedBorder: inputBorderNone,
          focusedErrorBorder: inputBorderNone,
          enabledBorder: inputBorderNone,
          errorBorder: inputBorderNone,
          hintText: "Enter You PassWord",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                this._passWordVisible = !this._passWordVisible;
              });
            },
            icon: Icon(_passWordVisible
                ? Icons.visibility
                : Icons.visibility_off),
          ),
        ),
        validator: (String value) {
          widget.setPassWord(value);
          return value.trim().length > 5 ? null : '密码不能少于6位';
        },
      ),
    );
  }
}