import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';

Future<Uint8List> compressImage(Uint8List list) async {
  var result = await FlutterImageCompress.compressWithList(
    list,
    minHeight: 40,
    minWidth: 40,
    quality: 80,
    rotate: 0,
  );
  print(list.length);
  print(result.length);
  return result;
}

Future<bool> getImageDimensions(Uint8List thumbnailData, int width, int height) async {
  final Completer<Size> completer = Completer<Size>();
  final Image? image = decodeImage(thumbnailData);
  if (image != null) {
    completer.complete(Size(image.width.toDouble(), image.height.toDouble()));
  } else {
    completer.complete(Size.zero);
  }
  final Size imageSize = await completer.future;
  print('-------Image width: ${imageSize.width}, height: ${imageSize.height}');
  if (imageSize.width == width && imageSize.height == height) return true;
  return false;
}
// 异步方法，压缩图片到指定大小
// Future<Uint8List?> compressImage(Uint8List imageBytes) async {
//   try {
//     print("------图片初始大小：${imageBytes.length / 1024 / 1024}MB");
//
// // 控制压缩后图片大小,不得超过0.5MB
//     int quality = 90;
//     while (imageBytes.length > 40 * 40 * 0.5 && quality > 0) {
//       imageBytes = await FlutterImageCompress.compressWithList(
//         imageBytes,
//         quality: quality,
//       );
//       print('压缩后大小: ${imageBytes.length / 1024 / 1024}MB');
//       quality -= 2;
//     }
//
//     return imageBytes;
//   } catch (e) {
// // 处理异常情况
//     print('------压缩图片出错：$e');
//     return null;
//   }
// }
