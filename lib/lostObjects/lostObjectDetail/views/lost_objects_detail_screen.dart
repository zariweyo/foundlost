import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/widgets/I18nText.dart';
import 'package:foundlost/common/index.dart';
import 'package:foundlost/lostObjects/common/index.dart';
import 'package:foundlost/lostObjects/lostObjectDetail/controllers/index.dart';


class LostObjectDetailScreen extends StatefulWidget {
  const LostObjectDetailScreen({Key? key}) : super(key: key);
  @override
  _LostObjectDetailState createState() => _LostObjectDetailState();
}

class _LostObjectDetailState extends State<LostObjectDetailScreen> {

  late StreamSubscription subscription;
  LostObject? lostObject;

  @override
  void initState() {
    subscription = BlocProvider.of<LostObjectDetailBloc>(context).stream.listen((event) {
      if(event.type == LostObjectDetailActionType.initial){
        setState(() {   
          lostObject = event.data;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Widget body(){
    if(lostObject == null){
      return const Center(child: CircularProgressIndicator());
    }

    return LostObjectCard(
      lostObject: lostObject!,
      onEdit: (_lostObjectEdited){
        BlocProvider.of<LostObjectDetailBloc>(context).add(LostObjectDetailEvent(LostObjectDetailEventType.edit,_lostObjectEdited));
      },
      onDelete: (_lostObjectEdited){
        BlocProvider.of<LostObjectDetailBloc>(context).add(LostObjectDetailEvent(LostObjectDetailEventType.delete,_lostObjectEdited));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: I18nText('lostObject'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => 
            BlocProvider.of<LostObjectDetailBloc>(context).add(LostObjectDetailEvent(LostObjectDetailEventType.backDetail,{})),
        ),
      ),
      body: body(),
    );
  }
}