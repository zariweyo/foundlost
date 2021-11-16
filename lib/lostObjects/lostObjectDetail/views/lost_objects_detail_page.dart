import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foundlost/lostObjects/lostObjectDetail/controllers/index.dart';
import 'index.dart';

class LostObjectsDetailPage extends StatelessWidget {
  const LostObjectsDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LostObjectDetailBloc>(
      create: (BuildContext _context) => LostObjectDetailBloc(LostObjectDetailAction(LostObjectDetailActionType.initial,context)),
      child: const LostObjectDetailScreen(),
    );
  }
}