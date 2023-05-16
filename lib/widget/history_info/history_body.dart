
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:worktracker/services/models/info.dart';


// widgets

class HistorySheetContainerBody extends StatefulWidget {
  final Datum userInfo;
  final List<LatLng>? positions;
  const HistorySheetContainerBody({
    Key? key,required this.userInfo,required this.positions,
  }) : super(key: key);

  @override
  HistorySheetContainerBodyState createState() => HistorySheetContainerBodyState();
}

class HistorySheetContainerBodyState extends State<HistorySheetContainerBody> {
  final Completer<GoogleMapController> _controller = Completer();

  static late CameraPosition? _kGooglePlex;

 final  _markers = <Marker>[];

String  userStatusInfo(){
  if((widget.positions?[1] != null  && widget.positions?[1].longitude != 0.0 && widget.positions?[1].latitude != 0.0)&& (widget.positions?[2].longitude == 0.0 && widget.positions?[2].latitude == 0.0)) return'ongoing';
  return 'close';
}
  @override
  void initState() {
    super.initState();
    _kGooglePlex =    CameraPosition(
      target: widget.positions![1],
      zoom: 15,
    );
    _markers.addAll( [
      if(widget.userInfo.endLocation == null )  Marker(
        markerId: const MarkerId('1'),
        position:widget.positions![0],
        infoWindow: const InfoWindow(title: 'Current Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
      Marker(
        markerId:const MarkerId('2'),
        position:widget.positions![1],
        infoWindow:const InfoWindow(title: 'Start Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId:const MarkerId('3'),
        position:widget.positions![2],
        infoWindow:const InfoWindow(title: 'End Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    ]);

  }




  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildColumn('First Name', widget.userInfo.user != null ? widget.userInfo.user!.firstName! : ''),
              _buildColumn('Last Name' , widget.userInfo.user != null ? widget.userInfo.user!.lastName! : ''),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildColumn('Status', userStatusInfo()),
              _buildColumn('Date', DateFormat('yyyy-MM-dd').format(DateTime.parse('${widget.userInfo.date}'))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildColumn('Duration', '${widget.userInfo.duration}'),
            ],
          ),
          if(widget.userInfo.times != null) for (var time in widget.userInfo!.times!)
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildColumn('Start Time', time.start.toString()),
              _buildColumn('End Time',time.end.toString()),


            ],
          ),

          const SizedBox(height: 20),

          const Divider(
            thickness: 1,
            color: Color(0xFFEAEDF0),
          ),
          const Text(
            'Current Location',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.014,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 8),
          if (widget.userInfo.currentLocation != null)
            SizedBox(
              height: 500,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: Set<Marker>.of(_markers),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                myLocationEnabled: false,
                initialCameraPosition: _kGooglePlex ?? CameraPosition(
                  target: widget.positions![1],
                  zoom: 15,
                ),
                gestureRecognizers: Set()
                  ..add(
                    Factory<VerticalDragGestureRecognizer>(
                          () => VerticalDragGestureRecognizer(),
                    ),
                  )
                  ..add(
                    Factory<ScaleGestureRecognizer>(
                          () => ScaleGestureRecognizer(),
                    ),
                  ),
              ),
            ),

        ],
      ),
    );



  }
  Widget _buildColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.014,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            letterSpacing: 0.014,
            color: Color(0xFF212121),
          ),
        ),
        SizedBox(height: 20,),
      ],
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}