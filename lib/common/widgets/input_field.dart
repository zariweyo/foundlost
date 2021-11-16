import 'package:flutter/material.dart';
import 'package:foundlost/common/index.dart';
import 'package:get_it/get_it.dart';

class InputField extends StatelessWidget {

  final TranslateService translateService = GetIt.I.get<TranslateService>();
  final TextEditingController controller = TextEditingController();
  final String placeholderKey;
  final bool area;
  final Function(String)? onChange;
  final String initialValue;


  InputField({
    Key? key,
    this.placeholderKey = "",
    this.onChange,
    this.initialValue = "",
    this.area = false
  }) : super(key: key){
    init();
  }

  init(){
    controller.text = initialValue;
    controller.addListener(() {
      if(onChange!=null) onChange!(controller.value.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        minLines: area? 5: 1,
        maxLines: area? 5: 1,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: translateService.translate(placeholderKey)
        )
    );
  }
}