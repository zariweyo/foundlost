import 'package:flutter/material.dart';
import 'package:foundlost/common/index.dart';
import 'package:get_it/get_it.dart';

class LostObjectCardOptions extends StatelessWidget {
  final LostObject lostObject;
  final TranslateService translateService = GetIt.I.get<TranslateService>();
  final Function(LostObject) onDelete; 
  final Function(LostObject) onEdit; 
  
  LostObjectCardOptions({Key? key,
    required this.onDelete,
    required this.onEdit,
    required this.lostObject}) : super(key: key);

  Widget optionText({
    required BuildContext context, 
    required IconData iconData, 
    required Color color, 
    required Function() action,
    required String textKey
  }){
    return InkWell(
      onTap: () => {
        action(),
        Navigator.pop(context)
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(iconData, color: color,),
            Expanded(
              child: Text(translateService.translate(textKey))
            )
          ],
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    GetIt.I.get<TranslateService>().translate("null");
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          optionText(
            context: context,
            color: Colors.red,
            iconData: Icons.delete,
            action: () => onDelete(lostObject),
            textKey: "delete_lostobject"
          ),
          optionText(
            context: context,
            color: Colors.black,
            iconData: Icons.delete,
            action: () => onEdit(lostObject),
            textKey: "edit_lostobject"
          ),
        ],
      ),
    );
  }
}