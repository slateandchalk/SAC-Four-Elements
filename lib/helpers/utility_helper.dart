import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utility {
  //
  static const String keyImage = "tile_image";

  static Future<List<String>?> getImagesFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyImage);
  }

  static Future<bool> saveImageToPreferences(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? currentImages = prefs.getStringList(keyImage);
    currentImages?.add(value);
    return prefs.setStringList(keyImage, currentImages!);
  }

  static Future<bool> resetImages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(keyImage, []);
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
