import 'package:flutter/material.dart';
import 'package:icloudmusic/const/deviceInfo.dart';
class HotPlaylists extends StatefulWidget{
  @override
  _HotPlaylists createState() => _HotPlaylists();
}
class _HotPlaylists extends State<HotPlaylists>{
  // 推荐歌单data
  final List<Map<String,dynamic>> playListData = <Map<String,dynamic>>[{
    "img": "assets/images/playlists1.png",
    "name": "Just rock it",
    "briefing": "All the most recent and coolest new rock",
    "like": 547,
    "tracks": 50
  },{
    "img": "assets/images/playlists2.png",
    "name": "Hype",
    "briefing": "Listen to the most trending tracks in one playlist",
    "like": 647,
    "tracks": 70
  },{
    "img": "assets/images/playlists3.png",
    "name": "Loud new month's",
    "briefing": "Surprises and expected novelties",
    "like": 537,
    "tracks": 76
  },{
    "img": "assets/images/playlists4.png",
    "name": "Alternative",
    "briefing": "The novelties of the current alternative music in one playlist",
    "like": 547,
    "tracks": 56
  }];
  final List<Color> playListColor = <Color>[
    Color.fromRGBO(18, 29, 46, 0.35),
    Color.fromRGBO(12, 71, 202, 0.35),
    Color.fromRGBO(123, 170, 202, 0.35),
    Color.fromRGBO(10, 46, 59, 0.35)
  ];
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
    final List<Widget> _playLists = List();
    for(int i = 0;i < playListData.length;i++){
      final Widget _item = Container(
        width: DeviceInfo.height < 570 ? (DeviceInfo.width/2-25) : 155.0,
        margin: EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned(
                  left: 25.5,
                  right: 25.5,
                  top: 43.0,
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: playListColor[i],
                            blurRadius: 24.0,
                            spreadRadius: 0.0,
                            offset: Offset(0.0, 18.0),
                          )
                        ]
                    ),
                  ),
                ),
                Container(
                  height: DeviceInfo.height < 570 ? (DeviceInfo.width/2-25) : 155.0,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                          image: AssetImage(playListData[i]['img']),
                          alignment: Alignment.center,
                          fit: BoxFit.cover
                      )
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(playListData[i]['name'],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "SF-UI-Display-Semibold",
                  fontSize: 16.0,
                ),
              ),
            ),
            Container(
              width: DeviceInfo.height < 570 ? (DeviceInfo.width/2-25) : 155.0,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(playListData[i]['briefing'],
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: TextStyle(
                    fontFamily: "SF-UI-Display-Regular",
                    fontSize: 13.0,
                    color: Color.fromRGBO(112, 112, 112, 1)
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: Color.fromRGBO(24, 29, 40, 1)
                    ),
                    Text("  ${playListData[i]['like']}",
                      style: TextStyle(
                          fontFamily: "SF-UI-Display-Regular",
                          fontSize: 14.0,
                          color: Color.fromRGBO(24, 29, 40, 1)
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.track_changes,
                      size: 16,
                      color: Color.fromRGBO(24, 29, 40, 1)
                    ),
                    Text("  ${playListData[i]['like']}",
                      style: TextStyle(
                        fontFamily: "SF-UI-Display-Regular",
                        fontSize: 14.0,
                        color: Color.fromRGBO(24, 29, 40, 1)
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      );
      _playLists.add(_item);
    }
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: DeviceInfo.height < 570 ? (DeviceInfo.width-40-250)/2 : (DeviceInfo.width-40-310)/2,
        children: _playLists,
      ),
    );
  }
}

