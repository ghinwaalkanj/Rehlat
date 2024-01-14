import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

class DataStore {
  DataStore._internal();
  static final DataStore _instance = DataStore._internal();
  static DataStore get instance => _instance;
  // String boxName='recordingVoiceList';

  late Box<dynamic> box;

  Future<void> init() async {
    await Hive.initFlutter();
   // Hive.registerAdapter(RecordingVoiceModelAdapter());
    box = await Hive.openBox("default_box");
    log("Datastore initialized", name: "$runtimeType");

  }
  bool get isFirstTime => box.get("isFirstTime",)??true;
  Future<void> setIsFirstTime(bool value) => box.put("isFirstTime", value);

  bool get isDarkModeEnabled => box.get(
        "theme",
        defaultValue: false,
      )!;

  Future<void> switchTheme({required bool isDark}) => box.put(
        "theme",
          isDark,
      );


  String get lang => box.get("lang", defaultValue: "en")!;

  Future<void> setLang(String value) => box.put("lang", value);

  bool get hasToken => box.containsKey("token");

  String? get token {
    if (!box.containsKey("token")) return null;
    return "${box.get("token")}";
  }
  String? get fcmToken {
    return "${box.get("fcmToken")}";
  }
  String? get name {
    if (!box.containsKey("name")) return null;
    return "${box.get("name")}";
  }
  int? get age {
    if (!box.containsKey("age")) return null;
    return box.get("age");
  }
  String? get phone {
    if (!box.containsKey("phone")) return null;
    return box.get("phone");
  }

  Future<void> setToken(String? value) => box.put("token", value);
  Future<void> setFcmToken(String? value) => box.put("fcmToken", value);
  Future<void> setName(String value) => box.put("name", value);
  Future<void> setAge(String? value) => box.put("age", value);
  Future<void> setPhone(String? value) => box.put("phone", value);

  Future<void> setStartTime(DateTime? value) => box.put("startTime", value);
  Future<void> setResumeTime(DateTime? value) => box.put("resumeTime", value);

  DateTime? get startTime {
    if (!box.containsKey("startTime")) return null;
    return box.get("startTime");
  }
  DateTime? get resumeTime {
    if (!box.containsKey("resumeTime")) return null;
    return box.get("resumeTime");
  }

  void deleteCertificates() {
    box.deleteAll({"token"});
    box.delete("token");
  }

}
