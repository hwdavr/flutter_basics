import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatefulWidget {
  final String imageUri;

  PhotoViewPage(this.imageUri);

  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: FileImage(File(widget.imageUri)),
    ));
  }
}
