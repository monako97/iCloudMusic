import 'package:flutter/cupertino.dart';
import 'package:icloudmusic/component/selectionsComponent.dart';
import 'package:icloudmusic/component/home/chart.dart';
import 'package:icloudmusic/component/home/hotPlaylists.dart';
import 'package:icloudmusic/component/home/newRelease.dart';
import 'package:icloudmusic/component/home/bannerHome.dart';
import 'package:icloudmusic/component/home/SearchMiddleButton.dart';
import 'package:icloudmusic/component/home/SearchLeadingButton.dart';
import 'package:icloudmusic/component/home/homeTitleBox.dart';
import 'package:icloudmusic/widget/loading.dart';
import 'package:icloudmusic/widget/messageButton.dart';
import 'package:icloudmusic/widget/hitokoto.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
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
    super.build(context);
    Loading.context = context;
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.7),
          border: null,
          middle: SearchMiddleButton(),
          leading: SearchLeadingButton(),
          trailing: MessageButton()
      ),
      child: Container(
        child: EasyRefresh(
          header: BezierCircleHeader(
              color: CupertinoColors.white,
              backgroundColor: CupertinoColors.systemPink
          ),
          footer: BezierBounceFooter(
            color: CupertinoColors.white,
            backgroundColor: CupertinoColors.systemPink
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // banner
                BannerHome(),
                Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 25.0),
                  child: Text("Dark side Breaking Benjamin",
                    style: TextStyle(
                        fontFamily: "SF-UI-Display-Bold",
                        fontSize: 20.0,
                        color: Color.fromRGBO(24, 29, 40, 1)
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 5.0,bottom: 25.0),
                  child: Text("The new album by the American Alt-rockers",
                    style: TextStyle(
                        fontFamily: "SF-UI-Display-Regular",
                        fontSize: 15.0,
                        color: Color.fromRGBO(24, 29, 40, 0.64)
                    ),
                  ),
                ),
                // 标题
                HomeTitleBox(title: "New release"),
                // 新歌推荐
                NewRelease(),
                // 标题
                HomeTitleBox(title: "Chart"),
                // 榜单
                ChartHome(),
                // 标题
                HomeTitleBox(title: "Hot playlists"),
                // 推荐歌单
                HotPlaylists(),
                // 标题
                HomeTitleBox(title: "Selections"),
                selectionsComponent(),
                // 一言
                HitOKOto()
              ],
            ),
          ),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2), () {
              setState(() {});
            });
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 2), () {
              setState(() {});
            });
          },
        ),
      )
    );
  }
  @override
  bool get wantKeepAlive => true;
}
