import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projectt/models/PlaceModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchMap extends StatefulWidget {
  const SearchMap({super.key, required this.place});
  final PlaceModel place;

  @override
  _SearchMapState createState() => _SearchMapState();
}

class _SearchMapState extends State<SearchMap> {
  @override
  void initState() {

    //getCurrentPosition();
    _searchQuery =widget.place.name!;
    _searchQuery ="اماكن سياحية بجانب شارع المعز لدين الله الفاطمي";
    _search();
   // _suggest();
    super.initState();
  }
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Placemark> _searchResults = [];
  Set<Marker> _markers = {};
  LatLng? currentLocation;
  LatLng? placeLocation;

  Future getCurrentPosition() async
  {
    print("object");
    await Geolocator.getCurrentPosition()
        .then((value)
        {
          print(value.longitude);
          print(value.latitude);
          currentLocation = LatLng(value.latitude, value.longitude);
          _markers.add(Marker(
              markerId: MarkerId("current"),
              position: currentLocation!,
          )
          );
          setState(() {

          });
        }).catchError((error)
        {
          print(error.toString());
        });
  }
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  void _search() async {
    List<Location> locations = await locationFromAddress(_searchQuery);
    print("3333");
    print(locations.length);
    List<Placemark> placeMarks = await placemarkFromCoordinates(locations.first.latitude, locations.first.longitude);

    print("************");
    print(placeMarks.length);
    for (var element in placeMarks)
    {
      print(element.name);
      print(element.name);
    }
    placeLocation = LatLng(locations.first.latitude, locations.first.longitude);
    setState(() {
      _searchResults = placeMarks;
      if (_searchResults.isNotEmpty) {
        _markers.clear();
        _markers.add(Marker(
          markerId: MarkerId('search'),
          position: LatLng(locations.first.latitude,locations.first.longitude),
        ));
      }
    });
    if (_searchResults.isNotEmpty) {
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(locations.first.latitude,locations.first.longitude), 10));
    }
  }

  void _suggest() async {
    _searchQuery = "اماكن سياحية بجانب شارع المعز لدين الله الفاطمي";
    List<LatLng> places=[];
     await locationFromAddress(_searchQuery).then((value)
    {
      print(value.length);
      for (var element in value)
      {
        places.add(LatLng(element.latitude, element.longitude));
      }
      print("6666666666");
      print(places.length);
    });
      if (places.isNotEmpty) {
        _markers.clear();
        for (var element in places)
        {
          _markers.add(Marker(
            markerId: MarkerId('${element.latitude},${element.longitude}'),
            position: LatLng(element.latitude,element.longitude),
          ));
        }
        setState(() {
          placeLocation = LatLng(places.first.latitude,places.first.longitude);
        });
      }
    if (places.isNotEmpty) {
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(places.first.latitude,places.first.longitude), 10)
      );
    }
  }

  Future getPlaceDate() async
  {
    // Obtain the place ID for the desired location
    String placeId = '3726+9J7';

// Set up the URL for the Place Details API
    String url = 'https://maps.googleapis.com/maps/api/place/details/json' +
        '?place_id=$placeId' +
        '&fields=reviews,photos' +
        '&key=AIzaSyBWB1JR4gnnhypAmwDFckN0anoRUTH5SAY';

// Send an HTTP GET request to the API
    var response = await http.get(Uri.parse(url));

// Decode the JSON response
    var jsonResponse = json.decode(response.body);

// Get the reviews and photos from the response
    List reviews = jsonResponse['result']['reviews'];
    List photos = jsonResponse['result']['photos'];

  }
// 3726+9J7, المعز لدين الله, الجمالية، قسم الجمالية، محافظة القاهرة‬ 11311

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          placeLocation == null ?
              const Center(child: CircularProgressIndicator(),)
          :
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: placeLocation!,
              zoom: 13,
            ),
            markers: _markers,
          ),
          if (_searchResults.isNotEmpty)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
                child: ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.purple,),
                  title: Text(widget.place.name?? ""),
                  subtitle: Text('${_searchResults.first.street=="Unnamed Road" ? "":_searchResults.first.street}, ${_searchResults.first.locality}, ${_searchResults.first.administrativeArea} ${_searchResults.first.postalCode}, ${_searchResults.first.country}'),
                ),
              ),
            ),
        ],
      ),
    );
  }

}

/*
appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (value) => _searchQuery = value,
          onSubmitted: (value) => _search(),
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 16),
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _searchResults.clear();
                  _markers.clear();
                });
              },
            ),
          ),
        ),
      ),
 */

