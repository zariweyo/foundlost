import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:foundlost/common/utils/image_utils.dart';

import 'm_loading.dart';

class MImageCache extends StatefulWidget {
  final String pathImage;
  final bool cached;
  final Reference? imageReference;
  final BoxFit fit;
  final double height;

  const MImageCache({Key? key, 
    this.pathImage = "", 
    this.fit=BoxFit.cover, 
    this.cached = true, 
    this.imageReference, 
    this.height=200
  }) : super(key: key);

  @override
  _MImageCacheState createState() => _MImageCacheState();

  static void deleteCached(String pathImage) {
    DefaultCacheManager().removeFile(pathImage);
  }

  static  Widget loadImage(_path,{BoxFit fit=BoxFit.cover, double height=200}){
    if(ImageUtils.imageIsCDN(Uri.parse(_path))){
      return MImageCache(pathImage: _path,fit: fit, height: height);
    }

    Reference refImage = FirebaseStorage.instance
        .ref()
        .child(_path);

    return MImageCache(imageReference: refImage,fit: fit, height: height,);

  }

  static  Future<ImageProvider> loadImageProvider(_path){
    Completer<ImageProvider> completer = Completer<ImageProvider>();

    if(ImageUtils.imageIsCDN(Uri.parse(_path))){
      completer.complete(CachedNetworkImageProvider(_path));
      return completer.future;
    }

    Reference refImage = FirebaseStorage.instance
        .ref()
        .child(_path);
    ImageUtils.pathFileLoadFromStorage(refImage, true)
            .then((_pathImage) {

            completer.complete(CachedNetworkImageProvider(_pathImage));
    }).catchError((onError) {
          log(onError);
    });

    return completer.future;
  }
}

class _MImageCacheState extends State<MImageCache> {
  String? pathImage;

  @override
  initState() {
    load();
    super.initState();
  }

  @override
  void didUpdateWidget(MImageCache oldWidget) {
    load();
    super.didUpdateWidget(oldWidget);
  }

  load() {
    pathImage = widget.pathImage;
    if (pathImage == "" && widget.imageReference != null) {
      _pathImageLoadFromStorage(widget.imageReference!, widget.cached);
    }
  }

  Widget _empty(){
    return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[300]
        ),
    ); 
  }

  Widget _imageWidget() {
    if (pathImage == "") {
      return _empty();
    }

    Widget _imageWidget;

    if (!widget.cached) {
      _imageWidget = Image.network(
        pathImage!,
        fit: widget.fit,
        height: widget.height,
      );
    }else{
      _imageWidget = CachedNetworkImage(
        placeholder: (context, url) => _empty(),
        imageUrl: pathImage!,
        fit: widget.fit,
        height: widget.height,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        
      );
    }

    return _imageWidget;

  }

  _pathImageLoadFromStorage(Reference imageReference, bool cached) {

    ImageUtils.pathFileLoadFromStorage(imageReference, cached)
        .then((_pathImage) {
      if(mounted){
        setState(() {
          pathImage = _pathImage;
        });
      }
    }).catchError((onError) {
      log(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _imageWidget();
  }
}
