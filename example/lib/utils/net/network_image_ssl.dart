import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

/// CustomImageLoader负责忽略证书验证并加载图像，
class CustomImageLoader {
  static Future<Image> loadImage(String url) async {
    // Create a custom HttpClient instance
    HttpClient httpClient = HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    // Use the custom HttpClient to send the request
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();

    // Convert the response to bytes
    List<int> bytes = await response.fold<List<int>>([], (b, data) => b..addAll(data));

    // Convert bytes to Uint8List
    Uint8List uint8List = Uint8List.fromList(bytes);

    // Convert Uint8List to an image widget
    Image image = Image.memory(uint8List);

    return image;
  }
}

/// ImageLoader则负责缓存并显示图像，加入缓存是由于避免每次页面变动都会出现图片重新加载的情况
class ImageLoader extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? height;
  final double? width;

  const ImageLoader({
    Key? key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  late Image image;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    loadImage(widget.imageUrl);
  }

  void loadImage(String imageUrl) async {
    final response = await CustomImageLoader.loadImage(imageUrl);
    setState(() {
      loaded = true;
      image = response;
    });
  }

  @override
  void didUpdateWidget(ImageLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        loaded = false;
      });
      loadImage(widget.imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? Image(
            image: image.image,
            fit: widget.fit,
            width: widget.width,
            height: widget.height,
          )
        : const CircularProgressIndicator();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
