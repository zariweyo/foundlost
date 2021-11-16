import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foundlost/common/index.dart';
import 'package:foundlost/lostObjects/lostObjectsList/controllers/index.dart';

class LostObjectsListSearch extends StatelessWidget {

  const LostObjectsListSearch({Key? key}) : super(key: key);

  onChange(BuildContext context, String text){
    BlocProvider.of<LostObjectListBloc>(context)
      .add(LostObjectListEvent(LostObjectListEventType.search,text.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      child: InputField(
        placeholderKey: 'enter_search',
        onChange: (text) => onChange(context,text),
      )
    );
  }
}