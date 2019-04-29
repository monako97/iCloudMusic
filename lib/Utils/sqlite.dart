import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class SqlLite {
  final sqlFileName = "icloudmusic.sql"; // sql数据文件
  final userInfo = "userInfo"; // 用户信息
  final loginState = "loginState"; // 用户信息
  final loginPhone = "loginPhone"; //使用手机登录过的用户
  final loginEmail = "loginEmail"; //使用邮箱登录过的用户
  Database db; //后面使用 db缩写 表示 Database
  // 建立一个开启数据库的方法
  open() async {
    String path = "${await getDatabasesPath()}/$sqlFileName";
    if (db == null) {
      db = await openDatabase(path, version: 1, onCreate: (db, ver) async {
        // 用户表
        await db.execute("""
        Create Table userInfo(
        province integer primary key,
        avatarImgId integer,
        experts text,
        nickname text,
        birthday integer,
        defaultAvatar bit,
        avatarUrl text,
        userId integer,
        backgroundImgId integer,
        userType integer,
        djStatus integer,
        mutual bit,
        remarkName text,
        expertTags text,
        authStatus integer,
        accountStatus integer,
        vipType integer,
        gender integer,
        city integer,
        detailDescription text,
        followed bit,
        avatarImgIdStr text,
        backgroundImgIdStr text,
        description text,
        backgroundUrl text,
        signature text,
        authority integer,
        avatarImgId_str text,
        followeds integer,
        follows integer,
        eventCount integer,
        playlistCount integer,
        playlistBeSubscribedCount integer
        );
        """);
        // 登录状态
        await db.execute("""
        Create Table loginState(
         login bit primary key,
         first bit
        );
        """);
        await db.insert("loginState", {'login': 0, 'first': 1});
        // 记住使用手机号登录过的账户
        await db.execute("""
        Create Table loginPhone(
         phone integer primary key,
         password char(20),
         countrycode char(10)
        );
        """);
        // 记住使用手机号登录过的账户
        await db.execute("""
        Create Table loginEmail(
         email char(50) primary key,
         password char(20)
        );
        """);
      });
    }
  }

  // 登录成功存储相关部分登录信息，方便以后调用
  // m 用户信息
  // l 账号信息 根据 f 决定是否保存
  // f 是否记住登录账号 0不 1手机登录 2邮箱登录
  insertLoginInfo(
      bool n, Map<String, dynamic> m, Map<String, dynamic> l, bool f) async {
    // 账户基本信息，头像等
    return await db.update(loginState, {'login': 1}).then((e) {
      if (f) {
        print("保存账号");
        switch (l.keys.length) {
          case 2:
            db.query(loginEmail, columns: null).then((e) {
              e.forEach((i) {
                l['email'] == i['email']
                    ? db.update(loginEmail, l, where: 'email=${l['email']}')
                    : db.insert(loginEmail, l);
              });
            });
            break;
          case 3:
            db.query(loginPhone, columns: null).then((e) {
              e.forEach((i) {
                l['phone'] == i['phone']
                    ? db.update(loginPhone, l, where: 'phone=${l['phone']}')
                    : db.insert(loginPhone, l);
              });
            });
            break;
        }
      } else {
        print("不保存账号");
      }
      //账号信息存在时，更新信息
      n ? db.update(userInfo, m) : db.insert(userInfo, m);
    });
  }

  // 删除用户数据
  delLoginInfo() async {
    return await db.delete(userInfo).then((e) {
      // 修改登录状态
      db.update(loginState, {'login': 0}).then((e) {
        print("退出成功");
      });
    });
  }

  // 读取userInfo表全部数据
  queryUserInfo() async {
    // columns 为 null 的时候，取出所有
    return await db.query(userInfo, columns: null);
  }

  // 读取login表全部数据
  queryLogin() async {
    return await db.query(loginState, columns: null);
  }

  // 读取表全部数据
  queryForm(String t) async {
    return await db.query(t, columns: null);
  }
}
