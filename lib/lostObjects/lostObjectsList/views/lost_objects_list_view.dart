import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foundlost/common/index.dart';
import 'package:foundlost/lostObjects/lostObjectsList/controllers/index.dart';
import 'index.dart';

class LostObjectListView extends StatefulWidget {
  const LostObjectListView({Key? key}) : super(key: key);

  @override
  _LostObjectListViewState createState() => _LostObjectListViewState();

}

class _LostObjectListViewState extends State<LostObjectListView> {

  List<LostObject> lostObjects = [];
  late StreamSubscription subscription;
  ScrollController controller = ScrollController();
  String lastObjectIndex = "";
  bool loading = false;
  StreamController<bool> refreshing = StreamController<bool>();

  @override
  initState(){
    super.initState();
    controller.addListener(_scrollListener);
    subscription = BlocProvider.of<LostObjectListBloc>(context).stream.listen((event) {
      if(event.type == LostObjectListActionType.replaceListSuccess){
        setState(() {
          lastObjectIndex = "";
          loading = false;
          lostObjects.clear();
          lostObjects.addAll(event.data);        
        });
        if(!refreshing.isClosed) refreshing.add(false);
      }else if(event.type == LostObjectListActionType.moreListSuccess){
        setState(() {
          Future.delayed(const Duration(milliseconds: 400), () {
            loading = false;
          }); 
          lostObjects.addAll(event.data);        
        });
        if(!refreshing.isClosed) refreshing.add(false);
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  _scrollListener() {
    if (!loading && lostObjects.isNotEmpty && lostObjects.last.id != lastObjectIndex && controller.position.extentAfter <= 100) {
      loading = true;
      BlocProvider.of<LostObjectListBloc>(context).add(LostObjectListEvent(LostObjectListEventType.getMore,lostObjects.last));
    }
  }

  Future<void> _refreshList() async {
    refreshing = StreamController();
    BlocProvider.of<LostObjectListBloc>(context).add(LostObjectListEvent(LostObjectListEventType.refresh,{}));
    await refreshing.stream.firstWhere((isRefreshing) => !isRefreshing);
    refreshing.close();
  }

  @override
  Widget build(BuildContext context) {
    return 
    RefreshIndicator(
      onRefresh: _refreshList,
      backgroundColor: Colors.blueGrey,
      color: Colors.white,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: lostObjects.length,
        controller: controller,
        itemBuilder: (BuildContext ctx, int index) {
          return LostObjectCard(
            lostObject: lostObjects[index],
            onDelete: (LostObject _lostObject) {
              BlocProvider.of<LostObjectListBloc>(context).add(
                LostObjectListEvent(LostObjectListEventType.delete,_lostObject.id)
              );
            },
            onEdit: (LostObject _lostObject) {
              BlocProvider.of<LostObjectListBloc>(context).add(
                LostObjectListEvent(LostObjectListEventType.edit,_lostObject)
              );
            },
            onView: (LostObject _lostObject) {
              BlocProvider.of<LostObjectListBloc>(context).add(
                LostObjectListEvent(LostObjectListEventType.view,_lostObject)
              );
            },
          );
        })
    );
  }
}