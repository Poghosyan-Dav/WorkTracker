
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:worktracker/services/models/user_info.dart';


// widgets

class InfoSheetBody extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userName;
  final String date;
  final String startTime;
  final String endTime;
  final bool? isInfo;
  final InfoLocation? startLocation;
  final InfoLocation? endLocation;
  final InfoLocation? currentLocation;

  const InfoSheetBody({
    Key? key,
    this.isInfo,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.date,
    required this.startLocation,
    required this.endLocation,
    required this.currentLocation,
    required this.startTime,
    required this.endTime
  }) : super(key: key);

  @override
  InfoSheetBodyState createState() => InfoSheetBodyState();
}

class InfoSheetBodyState extends State<InfoSheetBody> {

  final Completer<GoogleMapController> _controller = Completer();
 // Location _location = Location();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.4018, 44.6434),
    zoom: 15,
  );



  final  _markers = <Marker>[];
  final List<Marker> _list = const [
    Marker(markerId: MarkerId('1'),position: LatLng(40.4018, 44.6434),
      infoWindow: InfoWindow(title: 'Current Location'),
    ),
    Marker(markerId: MarkerId('2'),position: LatLng(40.4030, 44.6470),
      infoWindow: InfoWindow(title: 'Start Location'),
    ),
    Marker(markerId: MarkerId('3'),position: LatLng(40.4080, 44.6500),
      infoWindow: InfoWindow(title: 'End Location'),
    ),
  ];
  final List<LatLng> _latLen = [];

  @override
  void initState() {
    super.initState();

    loadData();
    _markers.addAll(_list);
  }
  loadData() async{
    _latLen.addAll([
      if(widget.startLocation!=null)  LatLng(double.parse(widget.startLocation!.lat!), double.parse(widget.startLocation!.lng!)),
      if(widget.endLocation!=null)  LatLng(double.parse(widget.endLocation!.lat!), double.parse(widget.endLocation!.lng!)),
      if(widget.currentLocation!=null)  LatLng(double.parse(widget.currentLocation!.lat!), double.parse(widget.currentLocation!.lng!)),
    ]);
    for(int i=0 ;i<_latLen.length; i++){
      // makers added according to index
      _markers.add(
          Marker(
            // given marker id
            markerId: MarkerId(i.toString()),
            position: _latLen[i],
            infoWindow: InfoWindow(
              title: i == 0 ?  'Current Location' : i == 1 ? 'Start Location' : 'End Location',
            ),
          )
      );
      setState(() {
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    debugPrint(widget.startLocation?.lat);
    return Scaffold(
      body: Container(

        padding: const EdgeInsets.only(top: 27.0 + 56.0, right: 20.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('First name',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(widget.firstName,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),

                  ],),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Last name',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(widget.lastName,
                      style:const TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),

                  ],),
              ],),
            // first name input
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('User name',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(widget.userName,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),

                  ],),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('End Time',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text( DateFormat.yMMMd().format(DateTime.now()),
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        letterSpacing: 0.014,
                        color: Color(0xFF212121),
                      ),
                    ),

                  ],),
              ],),
            // last name input
            // const  SizedBox(height: 20,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const  Text('Start Time',
            //           style: TextStyle(
            //             fontFamily: 'Roboto',
            //             decoration: TextDecoration.none,
            //             fontWeight: FontWeight.w600,
            //             fontSize: 14.0,
            //             letterSpacing: 0.014,
            //             color: Color(0xFF212121),
            //           ),
            //         ),
            //         const SizedBox(height: 3),
            //         Text(widget.startTime ?? '',
            //           style: TextStyle(
            //             fontFamily: 'Roboto',
            //             decoration: TextDecoration.none,
            //             fontWeight: FontWeight.w400,
            //             fontSize: 14.0,
            //             letterSpacing: 0.014,
            //             color: Color(0xFF212121),
            //           ),
            //         ),
            //
            //       ],),
            //
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text('End Time',
            //           style: TextStyle(
            //             fontFamily: 'Roboto',
            //             decoration: TextDecoration.none,
            //             fontWeight: FontWeight.w600,
            //             fontSize: 14.0,
            //             letterSpacing: 0.014,
            //             color: Color(0xFF212121),
            //           ),
            //         ),
            //         const SizedBox(height: 3),
            //         Text(widget.endTime ?? '',
            //           style:const TextStyle(
            //             fontFamily: 'Roboto',
            //             decoration: TextDecoration.none,
            //             fontWeight: FontWeight.w400,
            //             fontSize: 14.0,
            //             letterSpacing: 0.014,
            //             color: Color(0xFF212121),
            //           ),
            //         ),
            //
            //       ],),
            //   ],),
            const SizedBox(height: 15),
            const Divider(
              thickness: 1.0,
              color: Color(0xFFEAEDF0),
            ),
            const  Text('User Location',
              style: TextStyle(
                fontFamily: 'Roboto',
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
                letterSpacing: 0.014,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 15),
            if(widget.currentLocation !=null || widget.startLocation != null || widget.endLocation != null )
              SizedBox(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(_markers),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  mapToolbarEnabled:true,
                  myLocationButtonEnabled: false,


                ),),

            const SizedBox(height: 10
            ),const SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}