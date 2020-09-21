library mmkv_util;

import 'dart:async';
import 'dart:convert';

import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:synchronized/synchronized.dart';



class MmkvUtil {
  static MmkvUtil _singleton;
  static MmkvFlutter _mmkvs;
  static Lock _lock = Lock();

  static Future<MmkvUtil> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          // keep local instance till it is fully initialized.
          // 保持本地实例直到完全初始化。
          var singleton = MmkvUtil._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton;
  }

  MmkvUtil._();

  Future _init() async {
    _mmkvs = await MmkvFlutter.getInstance();
  }

  /// put object.
  static Future<bool> putObject(String key, Object value) {
    if (_mmkvs == null) return null;
    return _mmkvs.setString(key, value == null ? "" : json.encode(value));
  }

  /// get obj.
  static Future<T> getObj<T>(String key, T f(Map v), {T defValue}) async {
    Map map =await getObject(key);
    return  map == null ? defValue : f(map);
  }

  /// get object.
  static Future<Map> getObject(String key) async {
    if (_mmkvs == null) return null;
    String _data = await _mmkvs.getString(key) ;
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }



  /// get string.
  static Future<String> getString(String key, {String defValue = ''}) async {
    if (_mmkvs == null) return defValue;
    return  await _mmkvs.getString(key) ?? defValue;
  }

  /// put string.
  static Future<bool> putString(String key, String value) {
    if (_mmkvs == null) return null;
    return _mmkvs.setString(key, value);
  }

  /// get bool.
  static Future<bool> getBool(String key, {bool defValue = false}) async {
    if (_mmkvs == null) return defValue;
    return await _mmkvs.getBool(key) ?? defValue;
  }

  /// put bool.
  static Future<bool> putBool(String key, bool value) {
    if (_mmkvs == null) return null;
    return _mmkvs.setBool(key, value);
  }

  /// get int.
  static Future<int> getInt(String key, {int defValue = 0}) async {
    if (_mmkvs == null) return defValue;
    return  await _mmkvs.getInt(key) ?? defValue;
  }

  /// put int.
  static Future<bool> putInt(String key, int value) {
    if (_mmkvs == null) return null;
    return _mmkvs.setInt(key, value);
  }

  /// get double.
  static Future<double> getDouble(String key, {double defValue = 0.0}) async {
    if (_mmkvs == null) return defValue;
    return  await _mmkvs.getDouble(key) ?? defValue;
  }

  /// put double.
  static Future<bool> putDouble(String key, double value) {
    if (_mmkvs == null) return null;
    return _mmkvs.setDouble(key, value);
  }



  /// get dynamic.
  static dynamic getDynamic(String key, {Object defValue}) {
    if (_mmkvs == null) return defValue;
    return _mmkvs.getKeys().contains(key) ?? defValue;
  }

  /// have key.
  static bool haveKey(String key) {
    if (_mmkvs == null) return null;
    return _mmkvs.getKeys().contains(key);
  }

  /// get keys.
  static Set<String> getKeys() {
    if (_mmkvs == null) return null;
    return _mmkvs.getKeys();
  }

  /// remove.
  static Future<bool> remove(String key) {
    if (_mmkvs == null) return null;
    return _mmkvs.removeByKey(key);
  }

  /// clear.
  static Future<bool> clear() {
    if (_mmkvs == null) return null;
    return _mmkvs.clear();
  }

  ///Sp is initialized.
  static bool isInitialized() {
    return _mmkvs != null;
  }
}