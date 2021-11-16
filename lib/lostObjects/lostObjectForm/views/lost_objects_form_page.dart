import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foundlost/lostObjects/lostObjectForm/controllers/index.dart';
import 'index.dart';

class LostObjectsFormPage extends StatelessWidget {
  const LostObjectsFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LostObjectFormBloc>(
      create: (BuildContext _context) => LostObjectFormBloc(LostObjectFormAction(LostObjectFormActionType.initial,context)),
      child: const LostObjectFormScreen(),
    );
  }
}