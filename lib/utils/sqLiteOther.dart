import 'package:sqflite/sqflite.dart';

class SqlListData {
  final sqlFileName = "listData.sql"; // sql数据文件
  Database db; //后面使用 db缩写 表示 Database
  // 建立一个开启数据库的方法
  open() async {
    String path = "${await getDatabasesPath()}/$sqlFileName";
    if (db == null) {
      db = await openDatabase(path, version: 1, onCreate: (db, ver) async {
        // 储存首页轮播数据
        await db.execute("""
        Create Table banner(
         imageUrl text,
         targetId integer,
         adid text,
         targetType integer,
         titleColor char(20),
         typeTitle char(50),
         url char(50),
         exclusive bit,
         monitorImpress char(20),
         monitorClick char(20),
         monitorType char(20),
         monitorImpressList char(20),
         monitorClickList char(20),
         monitorBlackList char(20),
         extMonitor char(20),
         extMonitorInfo char(20),
         adSource char(20),
         adLocation char(20),
         encodeId char(20),
         program char(20),
         event char(20),
         video char(20),
         song char(20),
         scm text
        );
        """);
        await db.execute("""
        Create Table hitokoto(
         id integer,
         hitokoto text,
         type char(20),
         froms char(50),
         creator char(20),
         created_at char(20)
        );
        """);
      });
    }
  }
  // 向表中插入数据
  insertForm(String t, Map<String,dynamic> m)async{
    return await db.insert(t, m);
  }
  // 存储一言
  insertHit(Map<String,dynamic> m)async{
    db.query("hitokoto",where: 'id=${m['id']}').then((e) {
      if(e.length>0){
        m['froms']=m['from'];
        m.remove('from');
        print(m['from']);
        db.update("hitokoto", m, where: 'id=${m['id']}');
      }else{
        m['froms']=m['from'];
        m.remove('from');
        db.insert("hitokoto", m);
      }
    });
  }
  // 读取表全部数据
  queryForm(String t) async {
    return await db.query(t, columns: null);
  }
  // 删除表数据
  delForm(String t) async {
    return await db.delete(t);
  }
}
