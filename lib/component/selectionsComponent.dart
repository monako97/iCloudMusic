import 'package:flutter/material.dart';
import 'package:icloudmusic/const/deviceInfo.dart';
Widget selectionsComponent() {
  final List<Widget> _selectType = List();
  for (int i = 0; i < selectionsType.length; i++) {
    final Widget _item = Container(
        width: DeviceInfo.height < 570 ? (DeviceInfo.width/2-25) : 155.0,
        height: 90.0,
        margin: EdgeInsets.only(top: 20.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.red,
            image: DecorationImage(
                image: AssetImage(selectionsType[i]['img']),
                fit: BoxFit.cover,
                alignment: Alignment.center),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  blurRadius: 12.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 2.0))
            ]),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: selectionsType[i]['colors']),
            borderRadius: BorderRadius.circular(8.0),
          ),
          alignment: Alignment.center,
          child: Text(
            "${selectionsType[i]['name']}",
            style: TextStyle(
                fontSize: 20.0, fontFamily: "SF-UI-Display-Medium", color: Colors.white),
          ),
        ));
    _selectType.add(_item);
  }
  return Wrap(
      alignment: WrapAlignment.center,
      spacing: DeviceInfo.height < 570 ? (DeviceInfo.width-40-250)/2 : (DeviceInfo.width - 40 - 310) / 2,
      children: _selectType);
}

const List<Map<String, dynamic>> selectionsType = <Map<String, dynamic>>[
  {
    'name': 'Genre day',
    'img': 'assets/images/genreday.png',
    'colors': [
      Color.fromRGBO(245, 81, 157, 0.32),
      Color.fromRGBO(154, 67, 203, 0.32)
    ],
    'type': 1
  },
  {
    'name': 'Spring',
    'img': 'assets/images/spring.png',
    'colors': [
      Color.fromRGBO(245, 149, 131, 0.32),
      Color.fromRGBO(251, 216, 137, 0.32)
    ],
    'type': 2
  },
  {
    'name': 'Trend',
    'img': 'assets/images/trend.png',
    'colors': [
      Color.fromRGBO(245, 81, 157, 0.32),
      Color.fromRGBO(154, 67, 203, 0.32)
    ],
    'type': 3
  },
  {
    'name': 'Eternal hits',
    'img': 'assets/images/eternalhits.png',
    'colors': [Color.fromRGBO(28, 224, 218, 0.3), Color.fromRGBO(0, 0, 0, 0.3)],
    'type': 4
  },
  {
    'name': 'Soul',
    'img': 'assets/images/soul.png',
    'colors': [
      Color.fromRGBO(245, 149, 131, 0.3),
      Color.fromRGBO(49, 34, 0, 0.3)
    ],
    'type': 5
  },
  {
    'name': 'Rock',
    'img': 'assets/images/rock.png',
    'colors': [
      Color.fromRGBO(24, 29, 40, 0.3),
      Color.fromRGBO(24, 29, 40, 0.3)
    ],
    'type': 6
  },
  {
    'name': 'POP',
    'img': 'assets/images/pop.png',
    'colors': [
      Color.fromRGBO(24, 29, 40, 0.3),
      Color.fromRGBO(24, 29, 40, 0.3)
    ],
    'type': 7
  },
  {
    'name': 'Sad',
    'img': 'assets/images/sad.png',
    'colors': [
      Color.fromRGBO(28, 224, 218, 0),
      Color.fromRGBO(71, 157, 228, 0)
    ],
    'type': 8
  },
  {
    'name': 'Dance',
    'img': 'assets/images/dance.png',
    'colors': [
      Color.fromRGBO(28, 224, 218, 0),
      Color.fromRGBO(71, 157, 228, 0)
    ],
    'type': 9
  },
  {
    'name': 'Energetic',
    'img': 'assets/images/energetic.png',
    'colors': [
      Color.fromRGBO(20, 36, 156, 0.3),
      Color.fromRGBO(20, 36, 156, 0.3)
    ],
    'type': 10
  },
  {
    'name': 'Rap',
    'img': 'assets/images/rap.png',
    'colors': [
      Color.fromRGBO(95, 26, 28, 0.3),
      Color.fromRGBO(95, 26, 28, 0.3)
    ],
    'type': 11
  },
  {
    'name': 'Relax',
    'img': 'assets/images/relax.png',
    'colors': [
      Color.fromRGBO(59, 181, 182, 0.3),
      Color.fromRGBO(66, 226, 151, 0.3)
    ],
    'type': 12
  },
  {
    'name': 'Background',
    'img': 'assets/images/background.png',
    'colors': [
      Color.fromRGBO(24, 29, 40, 0.3),
      Color.fromRGBO(24, 29, 40, 0.32)
    ],
    'type': 13
  },
  {
    'name': '90',
    'img': 'assets/images/90.png',
    'colors': [
      Color.fromRGBO(245, 81, 157, 0.3),
      Color.fromRGBO(154, 67, 203, 0.3)
    ],
    'type': 14
  },
  {
    'name': 'Alternative',
    'img': 'assets/images/alternative.png',
    'colors': [
      Color.fromRGBO(28, 224, 218, 0),
      Color.fromRGBO(71, 157, 228, 0)
    ],
    'type': 15
  },
  {
    'name': 'Road',
    'img': 'assets/images/road.png',
    'colors': [
      Color.fromRGBO(28, 224, 218, 0),
      Color.fromRGBO(71, 157, 228, 0)
    ],
    'type': 16
  },
  {
    'name': '80',
    'img': 'assets/images/80.png',
    'colors': [
      Color.fromRGBO(245, 149, 131, 0.3),
      Color.fromRGBO(116, 80, 0, 0.3)
    ],
    'type': 17
  },
  {
    'name': 'Classic',
    'img': 'assets/images/classic.png',
    'colors': [
      Color.fromRGBO(85, 125, 139, 0.3),
      Color.fromRGBO(85, 125, 139, 0.3)
    ],
    'type': 18
  },
  {
    'name': 'Party',
    'img': 'assets/images/party.png',
    'colors': [
      Color.fromRGBO(28, 224, 218, 0),
      Color.fromRGBO(71, 157, 228, 0)
    ],
    'type': 19
  },
  {
    'name': '00',
    'img': 'assets/images/00.png',
    'colors': [Color.fromRGBO(181, 3, 0, 0.3), Color.fromRGBO(181, 3, 0, 0.3)],
    'type': 20
  },
  {
    'name': 'Sport',
    'img': 'assets/images/sport.png',
    'colors': [
      Color.fromRGBO(245, 149, 131, 0.3),
      Color.fromRGBO(193, 149, 50, 0.3)
    ],
    'type': 21
  },
  {
    'name': 'Metal',
    'img': 'assets/images/metal.png',
    'colors': [
      Color.fromRGBO(162, 133, 78, 0.3),
      Color.fromRGBO(162, 133, 78, 0.3)
    ],
    'type': 22
  },
  {
    'name': 'Love',
    'img': 'assets/images/love.png',
    'colors': [
      Color.fromRGBO(245, 149, 131, 0.3),
      Color.fromRGBO(0, 0, 0, 0.3)
    ],
    'type': 23
  },
  {
    'name': 'Soundtrack',
    'img': 'assets/images/soundtrack.png',
    'colors': [
      Color.fromRGBO(180, 159, 120, 0.3),
      Color.fromRGBO(180, 159, 120, 0.3)
    ],
    'type': 24
  },
  {
    'name': 'Run',
    'img': 'assets/images/run.png',
    'colors': [
      Color.fromRGBO(245, 149, 131, 0.3),
      Color.fromRGBO(0, 0, 0, 0.3)
    ],
    'type': 25
  },
  {
    'name': 'Sleep',
    'img': 'assets/images/sleep.png',
    'colors': [
      Color.fromRGBO(245, 149, 131, 0.3),
      Color.fromRGBO(0, 0, 0, 0.3)
    ],
    'type': 26
  }
];
