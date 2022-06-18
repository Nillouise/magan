import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'fetch_data.dart';

late SharedPreferences __prefs;

class MitbbsConfig {
  // String? __proxyHost = "";
  // String? __authors = ""; //用,分隔

  String get proxyHost => __prefs.getString("MitbbsConfig.proxyHost") ?? "";

  String get authors => __prefs.getString("MitbbsConfig.authors") ?? "";

  set proxyHost(String x) => __prefs.setString("MitbbsConfig.proxyHost", x);

  set authors(String x) => __prefs.setString("MitbbsConfig.proxyHost", x);
}

class MitbbsBackend {
  static final MitbbsBackend _mitbbsBackend = MitbbsBackend._internal();
  Timer? timer; //TODO: timer不应该放在这里，而是应该放在全局那里

  MitbbsBackend._internal();

  factory MitbbsBackend() {
    return _mitbbsBackend;
  }

  List<Tiezi> tiezis = []; //这个状态应该放在数据库，并且不该放在widget的state，毕竟还需要后台运行。
  List<Tiezi> clearedTiezis = []; //这个状态应该放在数据库，并且不该放在widget的state，毕竟还需要后台运行。
  MitbbsConfig? mitbbsConfig = MitbbsConfig();
  DateTime? refreshTime;

  void start() async {
    __prefs = await SharedPreferences.getInstance();
    timer = Timer.periodic(const Duration(hours: 3), (Timer t) async {
      refreshNewData();
    });
    // mitbbsConfig?.proxyHost = __prefs.getString("MitbbsConfig.proxyHost");
    // mitbbsConfig?.authors = __prefs.getString("MitbbsConfig.authors");
  }

  //暂时没用

  void end() async {
    // var config = Configuration([MitbbsConfig.schema])
    // var config = Configuration([MitbbsConfig.schema]);
    // var realm = Realm(config);
    //
    // realm.write(() {
    //   realm.add(mitbbsConfig!);
    // });
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString("MitbbsConfig.proxyHost", mitbbsConfig?.proxyHost ?? "");
    // prefs.setString("MitbbsConfig.authors", mitbbsConfig?.authors ?? "");
    // mitbbsConfig?.proxyHost = prefs.getString("MitbbsConfig.proxyHost");
    // mitbbsConfig?.authors = prefs.getString("MitbbsConfig.authors");
  }

  Future<List<Tiezi>> refreshNewData() async {
    var newTiezis = await fetchData();
    tiezis = __filterClearedTiezi(newTiezis);
    refreshTime = DateTime.now();
    return tiezis;
  }

  Future<List<Tiezi>> clear() async {
    clearedTiezis.addAll(tiezis);
    tiezis = [];
    return tiezis;
  }

  List<Tiezi> __filterClearedTiezi(List<Tiezi> source) {
    List<Tiezi> res = [];
    for (var a in source) {
      int flag = 0;
      for (var b in clearedTiezis) {
        if (b.link == a.link) {
          flag = 1;
          break;
        }
      }
//去重
      for (var b in res) {
        if (b.link == a.link) {
          flag = 1;
          break;
        }
      }

      if (flag == 0) {
        res.add(a);
      }
    }
    return res;
  }
}
