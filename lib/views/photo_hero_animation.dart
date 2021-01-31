import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_basics/models/gallery_image.dart';

class PhotoHeroPage extends StatefulWidget {
  final GalleryImage image;

  PhotoHeroPage(this.image);

  @override
  _PhotoHeroPageState createState() => _PhotoHeroPageState();
}

class _PhotoHeroPageState extends State<PhotoHeroPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Hero(
      tag: widget.image.tag,
      child: Image.file(File(widget.image.path)),
    ));
  }
}
