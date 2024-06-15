import 'package:flutter/material.dart' as material;

import 'painting.dart';
import 'box_decoration.dart';

abstract class AbstractDecoration implements Painting {
  material.Decoration? build();
}

class Decoration {
  static findElement(dynamic json) {
    if (json["type"] == "BoxDecoration") {
      return json["data"] == null ? null : BoxDecoration.fromJson(json["data"]);
    }

    throw Exception("Invalid type");
  }
}