import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/widgets/I18nText.dart';
import 'package:foundlost/common/index.dart';
import 'package:foundlost/lostObjects/lostObjectForm/controllers/index.dart';
import 'package:foundlost/lostObjects/lostObjectForm/views/forms/lost_object_form_base.dart';
import 'package:foundlost/lostObjects/lostObjectForm/views/index.dart';


class LostObjectFormScreen extends StatefulWidget {
  const LostObjectFormScreen({Key? key}) : super(key: key);
  @override
  _LostObjectFormState createState() => _LostObjectFormState();
}

class _LostObjectFormState extends State<LostObjectFormScreen> {

  bool loading = true;

  late StreamSubscription subscription;
  LostObjectFormPageData formData = LostObjectFormPageData(
    data: LostObject(),
    validation: () => true
  );

  @override
  void initState() {
    loading = true;
    subscription = BlocProvider.of<LostObjectFormBloc>(context).stream.listen((event) {
      if(event.type == LostObjectFormActionType.nextFormSuccess){
        setState(() {   
          formData = event.data;
          loading = false;
        });
      }else if(event.type == LostObjectFormActionType.loadingForm){
        setState(() {
          loading = true;
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
    if(loading){
      return const Center(
        child: CircularProgressIndicator()
      );
    }

    return LostObjectFormBase(
      formData: formData
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
            BlocProvider.of<LostObjectFormBloc>(context).add(LostObjectFormEvent(LostObjectFormEventType.backForm,{})),
        ),
      ),
      body: body(),
    );
  }
}