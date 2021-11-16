import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foundlost/common/index.dart';
import 'package:get_it/get_it.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';

class GeoLocationFieldOption {
  Key key = const Key("");
  Location? location;
  Placemark? place;

  GeoLocationFieldOption();

  factory GeoLocationFieldOption.create(Location _location, Placemark? _placemark){
    GeoLocationFieldOption newOption = GeoLocationFieldOption();
    newOption.location = _location;
    newOption.place = _placemark;
    newOption.key = Key(_placemark.toString() + _location.latitude.toString() + _location.longitude.toString());
    return newOption;
  }

  String placemarkToString(){
    if(place==null) return "";

    String placemarkStr = "";
    if(place!.street != null) placemarkStr += place!.street! + " ";
    if(place!.name != null) placemarkStr += place!.name! + " ";
    if(place!.postalCode != null) placemarkStr += place!.postalCode! + " ";
    if(place!.subLocality != null) placemarkStr += place!.subLocality! + " ";
    if(place!.locality != null) placemarkStr += place!.locality! + " ";
    if(place!.country != null) placemarkStr += place!.country! + " ";
    return placemarkStr;
  }
}

class GeoLocationField extends StatefulWidget {

  final Function(GeoLocationFieldOption)? onChange;
  final String initialValue;

  const GeoLocationField({
    Key? key,
    this.onChange,
    this.initialValue = ""
  }) : super(key: key);

  @override
  State<GeoLocationField> createState() => _GeoLocationFieldState();
}

class _GeoLocationFieldState extends State<GeoLocationField> {
  final TranslateService translateService = GetIt.I.get<TranslateService>();
  final GeolocationService geolocationService = GetIt.I.get<GeolocationService>();

  final TextEditingController controller = TextEditingController();

  List<GeoLocationFieldOption> places = [];
  GeoLocationFieldOption selected = GeoLocationFieldOption();
  bool geoLocationEnabled = true;
  bool loading = true;

  @override
  initState(){
    super.initState();
    controller.text = widget.initialValue;
    if(controller.value.text.isNotEmpty){
      GeoLocationFieldOption basicGeo = GeoLocationFieldOption();
      basicGeo.place = Placemark(
        street: widget.initialValue
      );
      places.add(basicGeo);
      searchAddress();
    }
    controller.addListener(() {
      if(selected.key==const Key("")){
        if(widget.onChange!=null) widget.onChange!(selected);
      }
      if(controller.value.text.length%5 != 0) return;
      places = [];
      searchAddress();
    });
  }

  searchAddress(){
    setState(() {
      loading = true; 
    });
    locationFromAddress(controller.value.text).then((locations){
      for (Location location in locations) {
        placesFromLocation(location.latitude,location.longitude,location);
      }
    }).catchError((err){
      setState(() {
        loading = false; 
      });
    });
  }

  placesFromLocation(double latitude, double longitude, Location location){
    placemarkFromCoordinates(
      latitude, longitude, 
      localeIdentifier: Platform.localeName
    ).then((placesFrom){
      setState(() {
        for(Placemark place in placesFrom){
          places.add(GeoLocationFieldOption.create(location, place));
        }
        loading = false;
      });
    }).catchError((err){
      setState(() {
        loading = false; 
      });
    });
  }

  printCard(String text, Key key ){
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical:3),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        children:[
          const Icon(Icons.location_on_outlined, color: Colors.grey),
          Expanded( 
            child:Text(text)
          ),
          selected.key!=key && key!=const Key("") ? 
            const Icon( Icons.check_box_outline_blank, color: Colors.grey) :
            Icon( Icons.check_box, color: Colors.green.shade300),
        ]
      )
    );
  }

  Widget notCurrentLocation(){
    return Container(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined),
            Expanded(
              child: Text(translateService.translate("no_current_location"),
                textAlign: TextAlign.center,
              )
            )
          ]
        )
      );
  }

  Widget buttonGetCurrentGeolocation(){
    return InkWell(
      onTap: (){
        geolocationService.determinePosition().then((position) {
          placesFromLocation(position.latitude, position.longitude, Location(
            latitude:position.latitude,
            longitude:position.longitude,
            timestamp: DateTime.now().toUtc()
          ));
        })
        .onError((error, stackTrace){
          setState(() {
              geoLocationEnabled = false;
          });
        });
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined),
            Expanded(
              child: Text(translateService.translate("search_places_by_my_location"),
                textAlign: TextAlign.center,
              )
            )
          ]
        )
      )
    );
  }

  Widget listPlaces(){
    return Expanded(
      child:ListView.builder(
        itemCount: places.length,
        itemBuilder: (BuildContext ctx, int index){
          if(places.sublist(0,index).where((element) => element.key==places[index].key).isNotEmpty){
            return Container();
          }
          return InkWell(
            onTap: () {
              setState(() {
                selected = places[index];
                places = places.where((element) => element.key!=const Key("")).toList();
              });
              if(widget.onChange!=null) widget.onChange!(selected);
            },
            child: printCard(places[index].placemarkToString(), places[index].key)
          );
        }
      )
    );
  }

  Widget zoneList(){
    if(places.isNotEmpty) {
      return listPlaces();
    }else if(geoLocationEnabled){
      return buttonGetCurrentGeolocation();
    }

    return notCurrentLocation();
  }

  Widget loadingField(){
    if(loading){
      return const Center(
        child: LinearProgressIndicator()
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: translateService.translate("search_place")
          )
        ),
        loadingField(),
        zoneList()
      ]
    );
  }
}