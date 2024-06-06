import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:she_connect/MainWidgets/loading.dart';

class carouselFullView extends StatefulWidget {
  final arrImages;
  final index;
  const carouselFullView({Key? key, this.arrImages, this.index})
      : super(key: key);

  @override
  _carouselFullViewState createState() => _carouselFullViewState();
}

class _carouselFullViewState extends State<carouselFullView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            )),
      ),
      body: PhotoViewGallery.builder(
        itemCount: widget.arrImages.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(
              widget.arrImages[index],
            ),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
        ),
        enableRotation: false,
        loadingBuilder: (context, event) => Center(
          child: loading(),
        ),
      ),
    );
  }
}
