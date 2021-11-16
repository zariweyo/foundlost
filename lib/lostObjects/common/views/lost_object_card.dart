import 'package:flutter/material.dart';
import 'package:foundlost/common/index.dart';
import 'package:get_it/get_it.dart';
import 'index.dart';

class LostObjectCard extends StatelessWidget {
  final LostObject lostObject;
  final TranslateService translateService = GetIt.I.get<TranslateService>();
  final Function(LostObject) onDelete; 
  final Function(LostObject) onEdit; 
  Function(LostObject)? onView;
  
  LostObjectCard({
    Key? key, 
    required this.lostObject,
    required this.onDelete,
    required this.onEdit,
    this.onView
  }) : super(key: key);

  void showModalBottom(BuildContext context){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext _ctx) {
        return LostObjectCardOptions(
          lostObject: lostObject,
          onDelete: onDelete,
          onEdit: onEdit,
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    GetIt.I.get<TranslateService>().translate("null");
    return Card(
      key: Key(lostObject.id),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if(onView!=null) onView!(lostObject);
            },
            child:ListTile(
              leading: Icon(Icons.remove_red_eye_outlined, color: Colors.green[400],),
              trailing: IconButton(
                    onPressed: () => showModalBottom(context),
                    icon: const Icon(Icons.more_vert, size: 24),
              ),
              title: Text(lostObject.name),
              subtitle: Text(
                lostObject.lostDate.toIso8601String(),
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            )
          ),
          lostObject.images.isEmpty? Container() : Row(
            children: [
              Expanded(
                child: MImageCache.loadImage(lostObject.images[0], fit: BoxFit.cover,height: 150),
              )
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Text(lostObject.description, textAlign: TextAlign.start,)
          )
        ],
      )
    );
  }
}