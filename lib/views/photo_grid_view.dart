import 'dart:collection';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_basics/models/gallery_image.dart';
import 'package:flutter_basics/views/photo_view_page.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

class PhotoGridView extends StatefulWidget {
  PhotoGridView();

  @override
  _PhotoGridViewState createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<PhotoGridView> {
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
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Image Gallery'),
      ),
      body: _buildGrid(),
    );
  }

  Widget _buildGrid() {
    return GridView.extent(
        maxCrossAxisExtent: 150.0,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: _buildGridTileList(galleryItems.length));
  }

  List<Widget> _buildGridTileList(int count) {
    return List<Widget>.generate(
        count,
        (index) => GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PhotoViewPage(galleryItems[index].path))),
              child: Container(
                  child: new Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.file(
                    io.File(galleryItems[index].path),
                    width: 120.0,
                    height: 100.0,
                    fit: BoxFit.contain,
                  ),
                ],
              )),
            ));
  }
}
