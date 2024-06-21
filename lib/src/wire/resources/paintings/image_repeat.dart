import 'package:flutter/material.dart' as material;

class ImageRepeat {
  final String value;

  const ImageRepeat(this.value);

  factory ImageRepeat.fromJson(Map<String, dynamic> json) {
    return ImageRepeat(json["value"]);
  }

  material.ImageRepeat build() {
    switch (value) {
      case 'repeat':
        return material.ImageRepeat.repeat;
      case 'repeatX':
        return material.ImageRepeat.repeatX;
      case 'repeatY':
        return material.ImageRepeat.repeatY;
      case 'noRepeat':
        return material.ImageRepeat.noRepeat;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
