import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foundlost/common/index.dart';
import 'package:foundlost/lostObjects/lostObjectForm/controllers/index.dart';
import 'package:foundlost/lostObjects/lostObjectForm/views/index.dart';
import 'package:get_it/get_it.dart';

class LostObjectFormBase extends StatefulWidget {
  final LostObjectFormPageData formData;

  const LostObjectFormBase({Key? key, 
    required this.formData
  }) : super(key: key);

  @override
  State<LostObjectFormBase> createState() => _LostObjectFormBaseState();
}

class _LostObjectFormBaseState extends State<LostObjectFormBase> {
  final TranslateService translateService = GetIt.I.get<TranslateService>();

  Color buttonColor = Colors.grey;
  StreamSubscription? subscription;

  @override
  initState(){
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(LostObjectFormBase oldWidget) {
    restartSuscription();
    super.didUpdateWidget(oldWidget);
  }

  restartSuscription() async {
    await subscription?.cancel();
    init();
    setState(() {});
  }

  init(){
    calculateColor();
    if(widget.formData.onChangeValue!=null){
      subscription = widget.formData.onChangeValue!.stream.listen((value) {
        if(mounted){
          setState(() {
            calculateColor();
          });
        }
      });
    }
  }

  calculateColor(){
    if(widget.formData.validation()){
      buttonColor = Colors.blue;
    }else{
      buttonColor = Colors.grey;
    }
  }
 
  @override
  dispose(){
    super.dispose();
    subscription?.cancel();
  }

  pressNext(BuildContext context){
    if(widget.formData.validation()){
      BlocProvider.of<LostObjectFormBloc>(context).add(LostObjectFormEvent(LostObjectFormEventType.nextForm,{}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              translateService.translate(widget.formData.titleKey),
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 18
              ),
            ),
          ),
          Expanded(
            child: widget.formData.formComponent
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: TextButton.icon(
              onPressed: () {
                pressNext(context);
              }, 
              icon: Text(translateService.translate('next').toUpperCase(),
                style: TextStyle(
                  color: buttonColor
                ),
              ),
              label: Icon(Icons.arrow_forward, color: buttonColor)
            )
          ),
        ]
      )
    );
  }
}