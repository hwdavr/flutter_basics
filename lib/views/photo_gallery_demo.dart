import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';

class PhotoGalleryDemo extends StatefulWidget {
  final String imageUri;

  PhotoGalleryDemo(this.imageUri);

  @override
  _PhotoGalleryDemoState createState() => _PhotoGalleryDemoState();
}

class _PhotoGalleryDemoState extends State<PhotoGalleryDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: FileImage(File(widget.imageUri)),
    ));
  }
}
