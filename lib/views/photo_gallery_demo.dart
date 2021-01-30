import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_basics/models/gallery_image.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoGalleryDemo extends StatefulWidget {
  final String imageUri;

  PhotoGalleryDemo({this.imageUri});

  @override
  _PhotoGalleryDemoState createState() => _PhotoGalleryDemoState();
}

class _PhotoGalleryDemoState extends State<PhotoGalleryDemo> {
  List<GalleryImage> galleryItems = [];

  @override
  void initState() {
    super.initState();

    _listofFiles();
  }

  void _listofFiles() async {
    io.Directory cacheDir = await getTemporaryDirectory();
    setState(() {
      List<io.FileSystemEntity> files = cacheDir.listSync();
      files.forEach((element) {
        String mimeStr = lookupMimeType(element.path);
        final fileType = mimeStr.split('/');
        if (fileType.first == 'image') {
          final image =
              GalleryImage(element.path, id: element.path.split('/').last);
          galleryItems.add(image);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        print("Load Image: " + galleryItems[index].path);
        return PhotoViewGalleryPageOptions(
          imageProvider: FileImage(io.File(galleryItems[index].path)),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
        );
      },
      itemCount: galleryItems.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes,
          ),
        ),
      ),
      // backgroundDecoration: widget.backgroundDecoration,
      // pageController: widget.pageController,
      // onPageChanged: onPageChanged,
    ));
  }
}
