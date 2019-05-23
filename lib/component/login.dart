import 'package:icloudmusic/const/resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icloudmusic/component/registration.dart';
import 'package:icloudmusic/component/customeRoute.dart';
import 'package:icloudmusic/utils/commotRequest.dart';
import 'package:country_pickers/country_pickers.dart'; //国家码
import 'package:xlive_switch/xlive_switch.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:icloudmusic/component/loading.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _nameController; //用户名控制器
  TextEditingController _pswController; //密码控制器
  bool _passWordVisible = false; //密码是否可见
  bool _rememberMe = false; //记住用户
  bool _load = false; //加载状态
  bool _autoForm = false; // 自动检查表单
  Widget _isCounty;

  Widget oldUserList(d){
    if(d==null||d.length==0){
      return Container();
    }
    List<Widget> _userList = List();
    for (int i = d.length - 1; i >= 0; i--) {
      Widget item = Container(
          width: 175,
          height: 35,
          margin: EdgeInsets.only(bottom: 10.0),
          child: Material(
            color: Colors.deepPurple.shade200,
            borderRadius: BorderRadius.circular(17.5),
            child: InkWell(
              onTap: (){
                formDE['phone'] = d[i]['phone'];
                formDE['password'] = d[i]['password'];
                formDE['countrycode'] = d[i]['countrycode'];
                _rememberMe = false;
                doLogin();
              },
              borderRadius: BorderRadius.circular(17.5,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: (d[i]['avatarUrl']==null)?AssetImage(M.UN):NetworkImage(d[i]['avatarUrl']),
                    backgroundColor: Colors.green.shade200,
                    radius: 17.5,
                  ),
                  Text(" "+d[i]['phone'].toString(),style: TextStyle(
                      color: Colors.white,
                      fontFamily: F.Regular,
                      fontSize: 14.0
                  )),
                  IconButton(
                    onPressed: ()async{
                      await H.sqlLite.db.delete('loginPhone',where: 'phone=${d[i]['phone']}');
                      setState(() {});
                    },
                    iconSize: 17.5,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    color: Colors.white70,
                    icon: Icon(Icons.cancel),
                  )
                ],
              ),
            ),
          )
      );
      _userList.add(item);
    }
    return GroovinExpansionTile(
      inkwellRadius: BorderRadius.circular(8),
      title: Text("There's ${d.length} historical account",
          style: TextStyle(
              color: Color.fromRGBO(24, 29, 40, 0.64),
              fontSize: 14.0,
              fontFamily: F.Medium)),
      children: <Widget>[SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: _userList)
      )],
    );
  }

  doLogin() async {
    // 收起键盘
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() => _load = true);
    Map<String, dynamic> result = await H.loginPhone(formDE,_rememberMe);
    if (result['code'] == 200) {
      setState(() => _load = false);
      if (result['first'] == 1) {
        //首次使用该账号登录
        Navigator.pushNamedAndRemoveUntil(
            context, '/startWelcome', (route) => route == null);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/main', (route) => route == null);
      }
    } else {
      setState(() => _load = false);
      fuToast(result['msg'], "登录失败", false, context);
    }
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _pswController = TextEditingController();
    super.initState();
  }

  // 创建一个Popup组件
  void _openCountryPicker() =>
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return CountryPickerCupertino(
              pickerItemHeight: 50.0,
              pickerSheetHeight: 300.0,
              onValuePicked: (country) =>
                  setState(() {
                    _isCounty = CountryPickerUtils.getDefaultFlagImage(country);
                    formDE['countrycode'] = country.phoneCode;
                  }),
            );
          });

  @override
  void dispose() {
    _nameController.dispose();
    _pswController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "LOGIN",
            style: TextStyle(
                fontSize: 20.0,
                fontFamily: F.Medium,
                color: C.DEF),
          ),
          centerTitle: true,
          elevation: 0.0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          actionsIconTheme: IconThemeData(color: C.DEF),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context, FadeRoute((Registration())));
                },
                icon: Icon(Icons.bubble_chart),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              GestureDetector(
                // 触摸收起键盘
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 50.0),
                    child: Form(
                      onChanged: (){
                        if(!_autoForm){
                          setState(()=>_autoForm = true);
                        }
                      },
                      autovalidate: _autoForm,
                      child: FutureBuilder(
                        future: H.sqlLite.queryForm('loginPhone'),
                        builder: (BuildContext context,AsyncSnapshot snap){
                          print(snap.data);
                          return Column(
                            children: <Widget>[
                              //账号
                              Container(
                                width: 325,
                                child: TextFormField(
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: F.Regular),
                                  controller: _nameController,
                                  keyboardType: TextInputType.phone,
                                  // 限制输入的 最大长度  TextField右下角没有输入数量的统计字符串
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(11)
                                  ],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    focusedBorder: C.inputBorderNone,
                                    focusedErrorBorder: C.inputBorderNone,
                                    enabledBorder: C.inputBorderNone,
                                    errorBorder: C.inputBorderNone,
                                    prefixIcon: IconButton(
                                        onPressed: _openCountryPicker,
                                        padding: EdgeInsets.all(0.0),
                                        icon: _isCounty == null
                                            ? flagImage()
                                            : _isCounty),
                                    labelText: "Phone",
                                    contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 15.0),
                                    hintText: "Enter You Phone Number",
                                    suffix: IconButton(
                                        onPressed: () =>
                                            setState(
                                                    () =>
                                                    _nameController.clear()),
                                        icon: Icon(Icons.highlight_off)),
                                  ),
                                  validator: (String value) {
                                    formDE['phone'] = value;
                                    return value
                                        .trim()
                                        .length > 0
                                        ? null
                                        : '请输入账号';
                                  },
                                ),
                              ),
                              //历史账户
                              oldUserList(snap.data),
                              //  密码
                              Container(
                                width: 325.0,
                                margin: EdgeInsets.only(top: snap.hasData?(snap.data.length > 0
                                    ? 0.0
                                    : 20.0):20.0),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: F.Regular),
                                  obscureText: !this._passWordVisible,
                                  controller: _pswController,
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
                                    focusedBorder: C.inputBorderNone,
                                    focusedErrorBorder: C.inputBorderNone,
                                    enabledBorder: C.inputBorderNone,
                                    errorBorder: C.inputBorderNone,
                                    hintText: "Enter You PassWord",
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          this._passWordVisible =
                                          !this._passWordVisible;
                                        });
                                      },
                                      icon: Icon(_passWordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                  ),
                                  validator: (String value) {
                                    formDE['password'] = value;
                                    return value
                                        .trim()
                                        .length > 5
                                        ? null
                                        : '密码不能少于6位';
                                  },
                                ),
                              ),
                              // 忘记密码
                              Container(
                                width: 325.0,
                                alignment: Alignment.centerLeft,
                                child: FlatButton(
                                  padding: EdgeInsets.all(8.0),
                                  onPressed: () => print("忘记密码"),
                                  textTheme: ButtonTextTheme.primary,
                                  child: Text(
                                    "Forgotten password ?",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 29, 40, 0.64),
                                        fontSize: 14.0,
                                        fontFamily: F.Medium),
                                  ),
                                ),
                              ),
                              // 开启记住用户
                              Container(
                                width: 325.0,
                                child: Row(
                                  children: <Widget>[
                                    Hero(
                                      tag: 'SWITCH',
                                      child: XlivSwitch(
                                        value: _rememberMe,
                                        onChanged: (e) {
                                          setState(() => _rememberMe = e);
                                        },
                                      ),
                                    ),
                                    Text(
                                      "  Remember me?",
                                      style: TextStyle(
                                          color: C.DEF,
                                          fontSize: 16.0,
                                          fontFamily: F.Medium),
                                    )
                                  ],
                                ),
                              ),
                              //登录
                              Hero(
                                tag: 'LOGIN',
                                child: Container(
                                  width: 325.0,
                                  height: 60,
                                  margin: EdgeInsets.only(top: 70.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      gradient: LinearGradient(colors: C.BTN_DEF),
                                      boxShadow: C.btnShadow),
                                  child: Builder(builder: (context) {
                                    return Container(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                            onTap: () =>
                                            Form.of(context).validate()
                                                ? doLogin()
                                                : null,
                                            splashColor:
                                            Color.fromRGBO(28, 224, 218, 0.5),
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text("LOGIN",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18.0,
                                                      fontFamily: F.Regular)),
                                            )),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              // OR
                              Container(
                                width: 304.0,
                                margin: EdgeInsets.only(top: 30.0),
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Divider(
                                      height: 51.0,
                                      indent: 5.0,
                                      color: Color.fromRGBO(84, 102, 174, 0.15),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 66.0,
                                      color: Colors.white,
                                      child: Text(
                                        "OR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: F.Regular,
                                            fontSize: 18.0,
                                            color:
                                            Color.fromRGBO(24, 29, 40, 0.54)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // 第三方登录
                              Container(
                                width: 325.0,
                                margin: EdgeInsets.only(top: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: (D.sWidth-60-325)>0 ? 155.0 : (D.sWidth-70)/2,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                          color: Colors.white,
                                          boxShadow: C.btnShadow),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                            onTap: () {
                                              print("Google");
                                            },
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 18.0, right: 10.0),
                                                    child: Image.asset(M.GG,
                                                      width: 24.0,
                                                      height: 24.0,
                                                    ),
                                                  ),
                                                  Text("Google",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: C.DEF,
                                                          fontSize: 18.0,
                                                          fontFamily: F.Regular))
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                    Container(
                                      width: (D.sWidth-60-325)>0 ? 155.0 : (D.sWidth-70)/2,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                          color: Colors.white,
                                          boxShadow: C.btnShadow),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                            onTap: () {
                                              print("Facebook");
                                            },
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 18.0, right: 10.0),
                                                    child: Image.asset(M.FB,
                                                      width: 24.0,
                                                      height: 24.0,
                                                    ),
                                                  ),
                                                  Text("Facebook",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: C.DEF,
                                                          fontSize: 18.0,
                                                          fontFamily: F.Regular))
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  )),
              _load ? Container(
                height: D.sHeight,
                child: loadingWidget(),
              ) : Container(),
            ],
          ),
        ),
        resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
    );
  }
}

Map<String, dynamic> formDE = {
  'phone': null,
  'password': null,
  'countrycode': "86"
};
