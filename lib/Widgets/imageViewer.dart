import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final img;
  const ImageViewer({Key? key, this.img}) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.1),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          Container(
              child: PhotoView(
                  maxScale: PhotoViewComputedScale.covered * 1.5,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  initialScale: PhotoViewComputedScale.contained,
                  basePosition: Alignment.center,
                  imageProvider: NetworkImage(widget.img.toString()))),
          Positioned(
            top: 15,
            left: 15,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_outlined, color: Colors.black)),
            ),
          )
        ],
      ),
    );
    ;
  }
}
