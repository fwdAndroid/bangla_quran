import 'dart:convert';
import 'package:bangla_quran/model/dua_model.dart';
import 'package:flutter/services.dart' as rootBundle;

class ReadJSON {
  Future<List<DuaModel>> ReadJsonDua() async {
    //read json file
    final jsondata = await rootBundle.rootBundle.loadString(
      'assets/json/dua_list.json',
    );
    //decode json data as list
    final list = json.decode(jsondata) as List<dynamic>;

    //map json and initialize using DataModel
    return list.map((e) => DuaModel.fromJson(e)).toList();
  }
}
