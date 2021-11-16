import 'package:flutter/material.dart';
import 'package:foundlost/common/index.dart';
import 'package:get_it/get_it.dart';

class SelectTileField<T> extends StatefulWidget {

  final Function(T)? onChange;
  final T initialValue;
  final Map<T,IconData> values;

  const SelectTileField({
    Key? key,
    this.onChange,
    required this.initialValue,
    required this.values,
  }) : super(key: key);

  @override
  State<SelectTileField<T>> createState() => _SelectTileFieldState<T>();
}

class _SelectTileFieldState<T> extends State<SelectTileField<T>> {
  final TranslateService translateService = GetIt.I.get<TranslateService>();

  late T initialValue;

  @override
  void initState() {
    initialValue = widget.initialValue;
    super.initState();
  }

  onSelect(T newValue){
    setState(() {
      initialValue = newValue;
    });
    if(widget.onChange!=null){
      widget.onChange!(newValue);
    }
  }

  Color getColor(int index){
    return widget.values.keys.toList()[index]==initialValue? Colors.green[400]! : Colors.grey;
  }

  FontWeight getWeight(int index){
    return widget.values.keys.toList()[index]==initialValue? FontWeight.bold : FontWeight.w400;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (widget.values.length<=4? 2 : 3),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10
        ),
        itemCount: widget.values.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => onSelect(widget.values.keys.toList()[index]),
            child:Container(
              decoration: BoxDecoration(
                
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: getColor(index), 
                )
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Icon(widget.values[widget.values.keys.toList()[index]], color: getColor(index), size:40),
                    const SizedBox(height:10),
                    Text(
                      translateService.translate(widget.values.keys.toList()[index].toString()),
                      style: TextStyle(
                        color: getColor(index),
                        fontWeight: getWeight(index)
                      )
                    )
                  ]
                )
              ),
            )
          );
        }
      ),
    );
  }
}