import 'package:country_pickers/country_picker_cupertino.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icloudmusic/widget/myCountry.dart';
// ignore: must_be_immutable
class LoginUserInput extends StatefulWidget{
  final setPhone;
  final setCountry;
  LoginUserInput({
    Key key,
    @required this.setCountry,
    @required this.setPhone
  }) : super(key : key);
  @override
  _LoginUserInput createState() => _LoginUserInput();
}
class _LoginUserInput extends State<LoginUserInput>{
  TextEditingController _textEditingController;
  Widget _isCounty;
  final OutlineInputBorder inputBorderNone = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none
  );
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }
  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325,
      child: TextFormField(
        style: TextStyle(
            fontSize: 20.0,
            fontFamily: "SF-UI-Display-Regular"),
        controller: _textEditingController,
        keyboardType: TextInputType.phone,
        // 限制输入的 最大长度  TextField右下角没有输入数量的统计字符串
        inputFormatters: [
          LengthLimitingTextInputFormatter(11)
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          focusedBorder: inputBorderNone,
          focusedErrorBorder: inputBorderNone,
          enabledBorder: inputBorderNone,
          errorBorder: inputBorderNone,
          prefixIcon: IconButton(
              onPressed: () => showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return CountryPickerCupertino(
                      pickerItemHeight: 50.0,
                      pickerSheetHeight: 300.0,
                      onValuePicked: (country) =>
                          setState(() {
                            _isCounty = CountryPickerUtils.getDefaultFlagImage(country);
                            widget.setCountry(country.phoneCode);
                          }),
                    );
                  }),
              padding: EdgeInsets.all(0.0),
              icon: _isCounty == null
                  ? MyCountry()
                  : _isCounty),
          labelText: "Phone",
          contentPadding:
          EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 15.0),
          hintText: "Enter You Phone Number",
          suffix: IconButton(
              onPressed: (){
                // 保证在组件build的第一帧时才去触发取消清空内容
                WidgetsBinding.instance.addPostFrameCallback((_) => _textEditingController.clear());
              },
              icon: Icon(Icons.highlight_off)),
        ),
        validator: (String value) {
          widget.setPhone(value);
          return value.trim().length > 0 ? null : '请输入账号';
        },
      ),
    );
  }
}

