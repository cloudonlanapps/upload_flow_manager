import 'package:flutter/foundation.dart';

@immutable
abstract class UploadableItem {
  /*  final String path;
  const Item(this.path); */

  //String get path;

  String toJSON();
}
