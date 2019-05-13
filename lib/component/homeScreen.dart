import 'package:icloudmusic/const/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:icloudmusic/Utils/sqlite.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final sqlLites = SqlLite();
  SwiperController _swiperController;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
            Container(
              height: 180.0,
              margin: EdgeInsets.only(top: 15.0),
              child: new Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                          image: AssetImage(M.SP),
                          fit: BoxFit.fitWidth
                      ),
                    ),
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(9.0, 5.0, 9.0, 5.0),
                      decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(4.0)
                      ),
                      child: Text(
                        "ALBUM",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: F.Regular,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: 3,
                viewportFraction: 0.85,
                scale: 0.9,
                autoplay: true,
                controller: _swiperController,
                onIndexChanged: (i) {
                  print(i);
                },
              ),
            ),
          Column(
            children: <Widget>[
              Container(
                child: Text("Dark side Breaking Benjamin", style: TextStyle(
                    color: Color.fromRGBO(24, 29, 40, 0.87),
                    fontSize: 20.0,
                    fontFamily: F.Bold
                )),
              ),
              Container(
                child: Text("The new album by the American Alt-rockers",
                    style: TextStyle(
                        color: Color.fromRGBO(24, 29, 40, 0.64),
                        fontSize: 15.0,
                        fontFamily: F.Regular
                    )),
              ),
            ],
            )
        ],
      ),
    );
  }
}
