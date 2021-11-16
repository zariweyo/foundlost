import 'package:flutter/material.dart';
import 'package:foundlost/common/index.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum SelectPhotoFieldImageAction {
  empty, current, upload, delete
}

class SelectPhotoFieldImage {
  final String path;
  final SelectPhotoFieldImageAction action;

  SelectPhotoFieldImage({
    required this.path,
    required this.action,
  });

  bool get isEmpty => action == SelectPhotoFieldImageAction.empty;
}

class SelectPhotoField extends StatefulWidget {

  final Function(List<SelectPhotoFieldImage>)? onChange;
  final List<SelectPhotoFieldImage> values;

  const SelectPhotoField({
    Key? key,
    this.onChange,
    required this.values,
  }) : super(key: key);

  @override
  _SelectPhotoFieldState createState() => _SelectPhotoFieldState();
}

class _SelectPhotoFieldState extends State<SelectPhotoField> {
  final TranslateService translateService = GetIt.I.get<TranslateService>();

  late List<SelectPhotoFieldImage> values;

  @override
  void initState() {
    values = widget.values;
    super.initState();
  }

  selectDialogOption({
    required BuildContext ctx, 
    required IconData iconData, 
    required int index, 
    required bool isCamera
  }){
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all()
      ),
      child: IconButton(
        icon: Icon(iconData, size: 30,),
        onPressed: () {
          Navigator.pop(ctx);
          takePhoto(index,isCamera);
        },
      )
    );
  }

  cardSelection(int index){
    showDialog(
      context: context, 
      barrierDismissible: true,
      builder: (ctx){
        return SimpleDialog(
            alignment: Alignment.center,
            title: Text(translateService.translate("select_image_source")),
            children: [
              selectDialogOption(
                ctx: ctx,
                iconData: Icons.camera_alt_outlined,
                index: index,
                isCamera: true
              ),
              selectDialogOption(
                ctx: ctx,
                iconData: Icons.image,
                index: index,
                isCamera: false
              )
            ],
        );
      }
    );
  }

  takePhoto(int index, bool isCamera) async{
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(
      source: isCamera?ImageSource.camera : ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512);
    if(photo!=null){
      setState(() {
        widget.values[index] = SelectPhotoFieldImage( path: photo.path, action: SelectPhotoFieldImageAction.upload);
      });
    }
  }

  showImage(int index){
    SelectPhotoFieldImage photoField = widget.values[index];
    if(!photoField.isEmpty){
      Widget? imgWid;
      if(photoField.action == SelectPhotoFieldImageAction.upload){
        imgWid = Image.file(File(photoField.path), fit: BoxFit.cover,);
      } else if(photoField.action == SelectPhotoFieldImageAction.current){
        imgWid = Image.network(photoField.path, fit: BoxFit.cover,);
      }

      if(imgWid != null){
        return Stack(
          fit: StackFit.expand,
          children: [
            imgWid,
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: IconButton(
                  splashRadius: 10,
                  icon: Icon(Icons.delete_forever, color: Colors.red.shade300,),
                  onPressed: (){
                    setState(() {
                      widget.values[index] = SelectPhotoFieldImage( 
                        path: "", 
                        action: 
                          photoField.action == SelectPhotoFieldImageAction.current ?
                            SelectPhotoFieldImageAction.delete 
                            : SelectPhotoFieldImageAction.empty);
                    });
                  },
                )
              )
            )
          ],
        );
      }
    }

    return const Icon (Icons.camera_enhance_sharp, size: 35,);
  }


  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10
        ),
        itemCount: widget.values.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => widget.values[index].isEmpty? cardSelection(index) : null,
            child:Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5),
              ),
              child: showImage(index)
            )
          );
        }
      ),
    );
  }
}