import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/widgets/I18nText.dart';
import 'package:foundlost/lostObjects/lostObjectsList/controllers/index.dart';
import 'index.dart';

class LostObjectListScreen extends StatelessWidget {
  const LostObjectListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: I18nText('lostObject')),
      body: Column(
        children: [
          LostObjectsListSearch(),
          const Expanded(
            child: LostObjectListView()
          )
        ]
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            key: const Key('counterView_increment_floatingActionButton'),
            child: const Icon(Icons.add),
            onPressed: () => 
              BlocProvider.of<LostObjectListBloc>(context).add(LostObjectListEvent(LostObjectListEventType.insertNew,{}))
              ,
          ),
        ],
      ),
    );
  }
}