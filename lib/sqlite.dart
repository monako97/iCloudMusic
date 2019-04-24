import 'package:sqflite/sqflite.dart';

class SqlLite {
  final sqlFileName = "icm.sql"; // sql数据文件
  final userInfo = "userInfo"; // 用户信息
  Database db; //后面使用 db缩写 表示 Database
  // 建立一个开启数据库的方法
  open() async {
    String path = "${await getDatabasesPath()}/$sqlFileName";
    print("数据表：$db");
    if (db == null) {
      print("绅士手");
      db = await openDatabase(path, version: 1, onCreate: (db, ver) async {
        await db.execute("""
        Create Table userInfo(
        userId integer primary key,
        nickname text,
        avatarUrl text,
        birthday text,
        userType integer,
        djStatus integer
        );
        """);
      });
    }
  }

  // 往userInfo表插入数据
  insertUserInfo(Map<String, dynamic> m) async {
    return await db.insert(userInfo, m);
  }

  // 读取userInfo表全部数据
  queryUserInfo() async {
    // columns 为 null 的时候，取出所有
    return await db.query(userInfo, columns: null);
  }

  // 删除userInfo表数据
  delUserInfo() async {
    // 根据传回来的id 删除相应的数据
    return await db.delete(userInfo);
  }
}
