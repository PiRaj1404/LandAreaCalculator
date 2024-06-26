import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as Math;
import 'package:flutter/foundation.dart';
import 'package:connectivity/connectivity.dart';

void main() => runApp(MyApp());

// Main application widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get area by strolling',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

// Home widget that manages the state of the app
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

// State class for Home widget
class _HomeState extends State<Home> {
  Position _currentPosition;
  List<double> latitudelist = [];
  List<double> longitudelist = [];
  List<double> distancelist = [];

  int positionno, currentstateofwalk, timefortimer, ship;
  double distanceInMeters, areainsqmeter, perimeterinmeter;
  String ip = "", timetodisplay;
  Timer timer;
  bool endbuttonenabled = true,
      startbuttonenabled = true,
      timerforendbutton = false,
      internetenabled = true,
      locationpermissiondenied = false;

  @override
  void initState() {
    checkforLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Get Area by Strolling"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (currentstateofwalk == 0)
              SpinKitRing(
                color: Colors.green[700],
                size: 50,
              ),
            if (currentstateofwalk == 1)
              Image.asset('assets/w1.gif', height: 75, width: 75),
            if (currentstateofwalk == 2)
              Image.asset('assets/amongus.jpeg', height: 75, width: 75),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '$ip',
                style: TextStyle(fontStyle: FontStyle.normal, fontSize: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                color: Colors.lightGreen,
                child: Text(
                  'START',
                  style: TextStyle(
                      fontStyle: FontStyle.normal, color: Colors.white),
                ),
                onPressed: startbuttonenabled ? _getCurrentLocation : null,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: RaisedButton(
                color: Colors.red,
                child: Text(
                  'END',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: endbuttonenabled ? endwalk : null,
              ),
            ),
            if (timerforendbutton)
              Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  'END button will get activated in $timetodisplay seconds',
                ),
              ),
          ],
        ),
      ),
    );
  }

 // Check for location permission and internet connectivity
  void checkforLocationPermission() async {
    LocationPermission permission;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile)
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.grey[900],
          builder: (context) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Mobile Data is Off',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            );
          });

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.grey[900],
            builder: (context) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Location Permissions are denied',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              );
            });
        locationpermissiondenied = true;
      }
    }
    if (permission == LocationPermission.deniedForever)
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.grey[900],
          builder: (context) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Location Permissions are denied',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            );
          });
    locationpermissiondenied = true;

    if (!internetenabled && locationpermissiondenied)
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.grey[900],
          builder: (context) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Mobile Data is Off and Location Permissions are denied',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            );
          });
  }

// Get current location and start the walk
  void _getCurrentLocation() {
    startbuttonenabled = false;
    latitudelist.clear();
    longitudelist.clear();
    distancelist.clear();
    endbuttonenabled = false;
    ship = 0;
    distanceInMeters = 0;
    areainsqmeter = 0;
    perimeterinmeter = 0;
    positionno = 0;
    timefortimer = 30;

    setState(() {
      currentstateofwalk = 0; 
      ip = "Catching your current location";
    });
    startwalk();

    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => startwalk());
  }

// Start the walk by getting location periodically
  void startwalk() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        if (_currentPosition != null) {
          if (positionno == 0)
            setState(() {
              currentstateofwalk = 1; //walk started
              ip = "Start walking now";
              timerforendbutton = true;
            });

          setState(() {
            timetodisplay = timefortimer.toString();
          });

          latitudelist.add(_currentPosition.latitude);
          longitudelist.add(_currentPosition.longitude);
          if (positionno > 0)
            distanceInMeters = Geolocator.distanceBetween(
                latitudelist.elementAt(positionno - 1),
                longitudelist.elementAt(positionno - 1),
                latitudelist.elementAt(positionno),
                longitudelist.elementAt(positionno));
          distancelist.add(distanceInMeters.abs());
          positionno++;
          timefortimer = timefortimer - 10;
        }
        if (positionno == 4)
          setState(() {
            endbuttonenabled = true;
            timerforendbutton = false;
          });
      });
    }).catchError((e) {});
  }

// End the walk and calculate area and perimeter
  void endwalk() {
    timer.cancel();
    setState(() {
      currentstateofwalk = 2; 
      ip = "Walk over";
      startbuttonenabled = true;
    });

    if (ship == 0) {
      calculateareaandperimeter();
      latitudelist.removeLast();
      longitudelist.removeLast();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => showMap(
          latlist: latitudelist,
          longlist: longitudelist,
          areainmetersq: areainsqmeter,
          perimeterinmtr: perimeterinmeter,
        ),
      ),
    );
  }

  double convertToRadian(double input) {
    return input * Math.pi / 180;
  }

  void calculateareaandperimeter() {
    latitudelist.add(latitudelist.elementAt(0));
    longitudelist.add(longitudelist.elementAt(0));
    if (latitudelist.length > 2) {
      for (int i = 0; i < latitudelist.length - 1; i++) {
        areainsqmeter += convertToRadian(
                longitudelist.elementAt(i + 1) - longitudelist.elementAt(i)) *
            (2 +
                Math.sin(convertToRadian(latitudelist.elementAt(i))) +
                Math.sin(convertToRadian(latitudelist.elementAt(i + 1))));
      }
      areainsqmeter = areainsqmeter * 6378137 * 6378137 / 2;
      areainsqmeter = areainsqmeter.abs();
    }

    for (int i = 0; i < distancelist.length; i++)
      perimeterinmeter += distancelist.elementAt(i);
    ship = 2;
  }
}

// Widget to display the map with the walked path
class showMap extends StatefulWidget {
  final List<double> latlist;
  final List<double> longlist;
  final double areainmetersq, perimeterinmtr; 
  showMap({
    Key key,
    @required this.latlist,
    @required this.longlist,
    @required this.areainmetersq,
    @required this.perimeterinmtr,
  }) : super(key: key);
  @override
  _showMapState createState() => _showMapState();
}

class _showMapState extends State<showMap> {
  List<Marker> allMarkers = [];
  String displayarea = 'AREA';
  String displayperimeter = "PERIMETER";
  Completer<GoogleMapController> _controller = Completer();
  final Set<Polygon> lines = {};
  @override
  void initState() {
    allMarkers.add(Marker(
        markerId: MarkerId("origin"),
        icon: BitmapDescriptor.defaultMarkerWithHue(190),
        position:
            LatLng(widget.latlist.elementAt(0), widget.longlist.elementAt(0))));
    for (int j = 1; j < widget.latlist.length - 1; j++) {
      allMarkers.add(Marker(
          markerId: MarkerId("Middle Points"),
          icon: BitmapDescriptor.defaultMarkerWithHue(30),
          position: LatLng(
              widget.latlist.elementAt(j), widget.longlist.elementAt(j))));
    }
    allMarkers.add(Marker(
        markerId: MarkerId("Destination"),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(widget.latlist.elementAt(widget.latlist.length - 1),
            widget.longlist.elementAt(widget.latlist.length - 1))));

    lines.add(Polygon(
        polygonId: PolygonId('PathofWalk'),
        points: [
          for (int i = 0; i < widget.latlist.length; i++)
            LatLng(widget.latlist.elementAt(i), widget.longlist.elementAt(i)),
        ],
        fillColor: Colors.transparent,
        strokeColor: Colors.blue));
    super.initState();
  }
  
// Plotting coordinates from the positions received on Google Map and converting units
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 750,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    widget.latlist.elementAt(0), widget.longlist.elementAt(0)),
                zoom: 18,
              ),
              markers: Set.from(allMarkers),
              polygons: lines,
              onMapCreated: mapCreated,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 5, left: 15, bottom: 20),
              child: DropdownButton<String>(
                items: [
                  DropdownMenuItem<String>(
                    child: Center(
                      child: Text('Square Meter'),
                    ),
                    value: (widget.areainmetersq).toStringAsFixed(2) + ' m2',
                  ),
                  DropdownMenuItem<String>(
                    child: Center(
                      child: Text('Square Feet'),
                    ),
                    value: (widget.areainmetersq * 10.7639).toStringAsFixed(2) +
                        ' ft2',
                  ),
                  DropdownMenuItem<String>(
                    child: Center(
                      child: Text('Square Inches'),
                    ),
                    value: (widget.areainmetersq * 1550).toStringAsFixed(2) +
                        ' in2',
                  ),
                  DropdownMenuItem<String>(
                    child: Center(
                      child: Text('Acres'),
                    ),
                    value: (widget.areainmetersq * 0.000247105)
                            .toStringAsFixed(2) +
                        ' acres',
                  ),
                  DropdownMenuItem<String>(
                    child: Center(
                      child: Text('Hectares'),
                    ),
                    value: (widget.areainmetersq * 0.0001).toStringAsFixed(2) +
                        ' ha',
                  ),
                ],
                onChanged: (_value) => {
                  setState(() {
                    displayarea = _value.toString();
                  })
                },
                hint: Text('$displayarea '),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(top: 5, right: 15, bottom: 20),
              child: DropdownButton<String>(
                items: [
                  DropdownMenuItem<String>(
                    child: Center(
                      child: Text('Meter'),
                    ),
                    value: (widget.perimeterinmtr).toStringAsFixed(2) + ' m',
                  ),
                  DropdownMenuItem<String>(
                    child: Center(
                      child: Text('Feet'),
                    ),
                    value:
                        (widget.perimeterinmtr * 3.28084).toStringAsFixed(2) +
                            ' ft',
                  ),
                  DropdownMenuItem<String>(
                    child: Center(
                      child: Text('Inches'),
                    ),
                    value: (widget.perimeterinmtr * 39.37).toStringAsFixed(2) +
                        ' in',
                  ),
                  DropdownMenuItem<String>(
                    child: Center(
                      child: Text('Kilometer'),
                    ),
                    value: (widget.perimeterinmtr * 0.001).toStringAsFixed(2) +
                        ' km',
                  ),
                ],
                onChanged: (_value) => {
                  setState(() {
                    displayperimeter = _value.toString();
                  })
                },
                hint: Text('$displayperimeter '),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void mapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }
}
