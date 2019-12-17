import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:icloudmusic/const/deviceInfo.dart';
import 'package:icloudmusic/component/nativeWeb.dart';
import 'package:icloudmusic/utils/httpUtil.dart';
import 'package:icloudmusic/utils/sqLiteUser.dart';
class BannerHome extends StatefulWidget{
  _BannerHome createState()=> _BannerHome();
}
class _BannerHome extends State<BannerHome>{
  SwiperController _swipeController;
  final sqlLite = SqlLite();
  @override
  void initState(){
    super.initState();
    _swipeController = SwiperController();
  }
  @override
  void dispose(){
    super.dispose();
    _swipeController.dispose();
  }
  MaterialColor colorString(str){
    switch(str){
      case 'red':
        return Colors.red;
        break;
      case 'blue':
        return Colors.blue;
        break;
      case 'yellow':
        return Colors.yellow;
        break;
      case 'pink':
        return Colors.pink;
        break;
      default:
        return Colors.white;
        break;
    }
  }
  // 从服务端获取banner
  Future<List<Map<String, dynamic>>> getBanners() async {
    int device;
    if (Platform.isIOS) { //ios
      device = 2;
    } else if (Platform.isAndroid) { //android
      device = 1;
    } else {
      device = 0;
    }
    Map<String,dynamic> response = await HttpUtils.request('/banner',data: {"type": device});
    await sqlLite.open();
    if (response['code'] == 200) {
      await sqlLite.delForm("banner");
      response['banners'].forEach((e)async{
        await sqlLite.insertForm("banner", e);
      });
    }
    return await sqlLite.queryForm("banner");
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getBanners(),
      builder: (BuildContext context, snap) {
        if (snap.hasData&&snap.data.length>0) {
          return Container(
            height: 150.0,
            margin: EdgeInsets.only(top: DeviceInfo.padding + 50),
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(left: 18.0, right: 18.0),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(
                          Random().nextInt(60) + 180,
                          Random().nextInt(60) + 180,
                          Random().nextInt(60) + 180, 1),
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(
                            snap.data[index]['imageUrl']),
                        fit: BoxFit.cover,
                      )),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                    decoration: BoxDecoration(
                        color: colorString(
                            snap.data[index]['titleColor']),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0))),
                    child: Text(
                      snap.data[index]['typeTitle'],
                      style: TextStyle(
                          color: CupertinoColors.white,
                          fontFamily: "SF-UI-Display-Regular",
                          fontSize: 12.0),
                    ),
                  ),
                );
              },
              itemCount: snap.data.length,
              autoplay: true,
              controller: _swipeController,
              autoplayDelay: 5000,
              onTap: (i) {
                // 如果url不为null，则跳转页面
                if (snap.data[i]['url'] != null) {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) {
                        return NativeWebView(
                            urls: snap.data[i]['url']);
                      }));
                }else{
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) {
                        return NativeWebView(urls: "http://www.bilibili.com");
                      }));
                }
              },
              pagination: SwiperPagination(
                margin: EdgeInsets.all(0.0),
                builder: SwiperPagination(
                    margin: EdgeInsets.all(5.0),
                    builder: const DotSwiperPaginationBuilder(
                        size: 6.0,
                        activeSize: 6.0,
                        space: 2.5,
                        activeColor: Color.fromRGBO(150, 150, 150, 0.1),
                        color: Color.fromRGBO(255, 255, 255, 0.8))),
              ),
            ),
          );
        } else {
          return Container(
            height: 150.0,
            margin: EdgeInsets.only(
                left: 20.0, right: 20.0, top: DeviceInfo.padding + 50),
            decoration: BoxDecoration(
                color: Color.fromRGBO(
                    Random().nextInt(60) + 180,
                    Random().nextInt(60) + 180,
                    Random().nextInt(60) + 180, 1),
                borderRadius: BorderRadius.circular(8.0)),
          );
        }
      },
    );
  }
}