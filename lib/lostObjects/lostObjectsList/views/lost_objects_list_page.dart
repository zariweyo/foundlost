import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foundlost/lostObjects/lostObjectsList/controllers/index.dart';
import 'index.dart';

class LostObjectsListPage extends StatelessWidget {
  const LostObjectsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LostObjectListBloc>(
      create: (BuildContext context) => LostObjectListBloc(LostObjectListAction(LostObjectListActionType.initial,context)),
      child: const LostObjectListScreen(),
    );
  }
}