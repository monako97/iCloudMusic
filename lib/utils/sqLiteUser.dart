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
        province integer,
        avatarImgId integer,
        experts text,
        nickname text,
        birthday integer,
        defaultAvatar bit,
        avatarUrl text,
        userId integer primary key,
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
         first bit,
         code int
        );
        """);
        await db.insert("loginState", {'login': 0, 'first': 1,'code': 200});
        // 记住使用手机号登录过的账户
        await db.execute("""
        Create Table loginPhone(
         phone integer primary key,
         password char(20),
         countrycode char(10),
         avatarUrl text
        );
        """);
        // 记住使用邮箱登录过的账户
        await db.execute("""
        Create Table loginEmail(
         email char(50) primary key,
         password char(20),
         avatarUrl text
        );
        """);
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
         adDispatchJson char(20),
         encodeId char(20),
         program char(20),
         event char(20),
         video char(20),
         song char(20),
         scm text
        );
        """);
        // yi一言
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

  // 登录成功存储相关部分登录信息，方便以后调用
  // m 用户信息
  // l 账号信息 根据 f 决定是否保存
  // f 是否记住登录账号 0不 1手机登录 2邮箱登录
  insertLoginInfo(Map<String, dynamic> m, Map<String, dynamic> l, bool f) async {
    // 账户基本信息，头像等
    return await db.update(loginState, {'login': 1}).then((e) {
      if (f) {
        l['avatarUrl'] = m['avatarUrl'];
        switch (l.keys.length) {
          case 3:
            db.query(loginEmail,where: 'email=${l['email']}').then((e) {
              if(e.length > 0){
                db.update(loginEmail, l, where: 'email=${l['email']}');
              }else{
                db.insert(loginEmail, l);
              }
            });
            break;
          case 4:
            db.query(loginPhone,where: 'phone=${l['phone']}').then((e) {
              if(e.length>0){
                db.update(loginPhone, l, where: 'phone=${l['phone']}');
              }else{
                db.insert(loginPhone, l);
              }
            });
            break;
        }
      } else {
        print("不保存账号");
      }
      //账号信息存在时，更新信息
      db.query(userInfo,where: 'userId=${m['userId']}').then((e){
        print(e);
        if(e.length>0){
          db.update(userInfo, m, where: 'userId=${m['userId']}');
        }else{
          db.insert(userInfo, m);
        }
      });
    });
  }

  // 删除用户数据
  delLoginInfo() async {
    return await db.delete(userInfo).then((e) {
      // 修改登录状态
      db.update(loginState, {'login': 0}).then((e) {});
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
  // 删除表数据
  delForm(String t) async {
    return await db.delete(t);
  }
}
