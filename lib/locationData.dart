import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hostel_management/constants/utils.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mtKit;
import 'package:hostel_management/models/user.dart';
import 'package:hostel_management/providers/user_provider.dart';
import 'package:hostel_management/features/auth/services/auth_service.dart';
// import 'package:permission_handler/permission_handler.dart';

import 'package:hostel_management/theme/colors.dart';
import 'package:hostel_management/theme/text_theme.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Location _location = Location();
  // late StreamSubscription<LocationData> _locationSubscription;
  late MapController _mapController;
  late LatLng currentUserLocation;
  bool _hasPermission = false;
  User? user;
  final AuthService authService = AuthService();

  late bool isWithinThePolygon;
  List<LatLng> points = [
    const LatLng(13.01504, 80.23789),
    const LatLng(13.01499, 80.23831),
    const LatLng(13.01459, 80.23826),
    const LatLng(13.01466, 80.23783)
  ];

  List<LatLng> points1 = [
    const LatLng(13.01251, 80.23581),
    const LatLng(13.01273, 80.23582),
    const LatLng(13.01270, 80.23606),
    const LatLng(13.01246, 80.23604),
  ];
  List<Marker> markers = [];
  List<Polygon> polygons = [];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    initializeUserProvider(context);
    _mapController = MapController();
  }

  @override
  void dispose() {
    // _locationSubscription.cancel();
    super.dispose();
  }

  void initializeUserProvider(context) async {
    try {
      await authService.getUserData(context);
      final userProvider =
          Provider.of<UserProvider>(context, listen: false).user;
      setState(() {
        user = userProvider;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void _checkLocationPermission() async {
    final locationStatus = await _location.hasPermission();
    if (locationStatus == PermissionStatus.denied) {
      final status = await _location.requestPermission();
      setState(() {
        _hasPermission = status == PermissionStatus.granted;
      });
    } else {
      setState(() {
        _hasPermission = locationStatus == PermissionStatus.granted;
      });
    }

    moveToCurrentLocation();
  }

  void checkUpdatedLocation(LatLng pointLatLng) async {
    List<mtKit.LatLng> convertedPolygonPoints = [];
    if (user?.block == 'A') {
      convertedPolygonPoints = points
          .map((point) => mtKit.LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      convertedPolygonPoints = points1
          .map((point) => mtKit.LatLng(point.latitude, point.longitude))
          .toList();
    }
    setState(() {
      isWithinThePolygon = mtKit.PolygonUtil.containsLocation(
          mtKit.LatLng(pointLatLng.latitude, pointLatLng.longitude),
          convertedPolygonPoints,
          false);
    });

    if (isWithinThePolygon) {
      authService.addAttendance(context);
      Fluttertoast.showToast(
          msg: "Attendence Marked Successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Get inside the hostel premise and try again!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    print("yes Within the polygon $isWithinThePolygon");
  }

  void moveToCurrentLocation() async {
    if (!_hasPermission) return;
    final locationData = await _location.getLocation();

    setState(() {
      currentUserLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
      _hasPermission = true;
      // checkUpdatedLocation(currentUserLocation);
      markers.clear();
      markers.add(Marker(
          point: currentUserLocation,
          width: 40,
          height: 40,
          child: const UserMarker(),
          alignment: Alignment.center));

      polygons.clear();
      polygons.add(Polygon(
          points: (user?.block == 'A') ? points : points1,
          isFilled: true,
          color: const Color(0xff006491).withOpacity(0.2),
          borderStrokeWidth: 2,
          borderColor: const Color(0xff006491)));
      _mapController.moveAndRotate(
          LatLng(locationData.latitude!, locationData.longitude!), 17.5, 0);
    });
  }

  void markAttendance() async {
    if (!_hasPermission) return;
    final locationData = await _location.getLocation();
    setState(() {
      currentUserLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
      checkUpdatedLocation(currentUserLocation);
    });
  }

  void findYourHostel() {
    setState(() {
      if (user?.block == 'A') {
        _mapController.moveAndRotate(const LatLng(13.01483, 80.23807), 17, 0);
      } else {
        _mapController.moveAndRotate(const LatLng(13.01259, 80.23595), 17, 0);
      }
    });
  }

  Future<LatLng> printUserLocation() async {
    final locationData = await _location.getLocation();
    print(LatLng(locationData.latitude!, locationData.longitude!));
    return (LatLng(locationData.latitude!, locationData.longitude!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Location Details",
          style: AppTextTheme.kLabelStyle.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.kGreenColor,
      ),
      body: _hasPermission
          ? Stack(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: FlutterMap(
                  mapController: _mapController,
                  options: const MapOptions(
                    initialCenter: LatLng(13.01, 80.23),
                    initialZoom: 17.2,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),
                    MarkerLayer(markers: markers),
                    PolygonLayer(polygons: polygons)
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 1.3,
                left: 32,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(top: 14, bottom: 14),
                          backgroundColor:
                              // Theme.of(context).colorScheme.primaryContainer,
                              const Color.fromARGB(255, 52, 159, 99),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          )),
                      onPressed: () {
                        moveToCurrentLocation();
                        markAttendance();
                      },
                      child: Text(
                        'Mark Attendance',
                        style: AppTextTheme.kLabelStyle
                            .copyWith(color: AppColors.kLight, fontSize: 16),
                      )),
                ),
              ),
              Positioned(
                bottom: 130.0,
                right: 20.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      backgroundColor: const Color.fromARGB(223, 52, 159, 98),
                      onPressed: moveToCurrentLocation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: const Icon(Icons.my_location, color: Colors.white),
                    ),
                    const SizedBox(height: 15.0),
                    FloatingActionButton(
                      backgroundColor: const Color.fromARGB(223, 52, 159, 98),
                      onPressed: findYourHostel,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ])
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Location permission is required to display the map.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: _checkLocationPermission,
                    child: const Text('Request permission'),
                  ),
                ],
              ),
            ),
    );
  }
}

class UserMarker extends StatefulWidget {
  const UserMarker({Key? key}) : super(key: key);

  @override
  State<UserMarker> createState() => _UserMarkerState();
}

class _UserMarkerState extends State<UserMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    sizeAnimation = Tween<double>(
      begin: 35,
      end: 40,
    ).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    animationController.repeat(
      reverse: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sizeAnimation,
      builder: (context, child) {
        return Center(
          child: Container(
            width: sizeAnimation.value,
            height: sizeAnimation.value,
            decoration: const BoxDecoration(
              color: Color.fromARGB(176, 119, 213, 239),
              shape: BoxShape.circle,
            ),
            child: child,
          ),
        );
      },
      child: const Icon(
        Icons.person_pin,
        color: Color.fromARGB(255, 19, 87, 197),
        size: 31,
      ),
    );
  }
}
