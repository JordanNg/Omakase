import 'dart:convert' show jsonDecode;
// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'dart:developer';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: 'Yelp Fetch',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            useMaterial3: true,
          ),
          home: const HomepageRoute(),
          debugShowCheckedModeBanner: false,
        ));
  }
}

class MyAppState extends ChangeNotifier {
  var searchTerm = '';
  var price = 2;
  var radius = 1609;
  var latLong = {'lat': 0.0, 'long': 0.0};
}

// Homepage Route
class HomepageRoute extends StatefulWidget {
  const HomepageRoute({super.key});

  @override
  State<HomepageRoute> createState() => _HomepageRouteState();
}

class _HomepageRouteState extends State<HomepageRoute> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    // Track the selected price state
    var selectedPrice = appState.price;
    var selectedRadius = appState.radius;

    // Attempt to get the user's device location and check for any errors being returned
    _determinePosition().then((value) {
      setState(() {
        appState.latLong['lat'] = value.latitude;
        appState.latLong['long'] = value.longitude;
      });
    }).catchError((error) {
      print(error);
    });

    // ! Probably should wait to see if the location could be set before rendering the page
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  'images/png-transparent-flutter-hd-logo.png',
                  height: 50,
                  fit: BoxFit.contain,
                ),
                Image.asset(
                  'images/Google-Maps-logo.png',
                  height: 50,
                  fit: BoxFit.contain,
                ),
                Image.asset(
                  'images/Yelp_Logo.svg.png',
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search term (optional)',
              ),
              onChanged: (text) {
                setState(() {
                  appState.searchTerm = text;
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            selectedPrice == 1 ? Colors.white : null,
                        backgroundColor:
                            selectedPrice == 1 ? Colors.redAccent : null,
                      ),
                      onPressed: () {
                        setState(() {
                          appState.price = 1;
                        });
                      },
                      child: const Text('\$')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            selectedPrice == 2 ? Colors.white : null,
                        backgroundColor:
                            selectedPrice == 2 ? Colors.redAccent : null,
                      ),
                      onPressed: () {
                        setState(() {
                          appState.price = 2;
                        });
                      },
                      child: const Text('\$\$')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            selectedPrice == 3 ? Colors.white : null,
                        backgroundColor:
                            selectedPrice == 3 ? Colors.redAccent : null,
                      ),
                      onPressed: () {
                        setState(() {
                          appState.price = 3;
                        });
                      },
                      child: const Text('\$\$\$')),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            selectedRadius == 1609 ? Colors.white : null,
                        backgroundColor:
                            selectedRadius == 1609 ? Colors.redAccent : null,
                      ),
                      onPressed: () {
                        setState(() {
                          appState.radius = 1609;
                        });
                      },
                      child: const Text('1 mi')),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            selectedRadius == 8046 ? Colors.white : null,
                        backgroundColor:
                            selectedRadius == 8046 ? Colors.redAccent : null,
                      ),
                      onPressed: () {
                        setState(() {
                          appState.radius = 8046;
                        });
                      },
                      child: const Text('5 mi')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            selectedRadius == 24140 ? Colors.white : null,
                        backgroundColor:
                            selectedRadius == 24140 ? Colors.redAccent : null,
                      ),
                      onPressed: () {
                        setState(() {
                          appState.radius = 24140;
                        });
                      },
                      child: const Text('15 mi')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            selectedRadius == 40000 ? Colors.white : null,
                        backgroundColor:
                            selectedRadius == 40000 ? Colors.redAccent : null,
                      ),
                      onPressed: () {
                        setState(() {
                          appState.radius = 40000;
                        });
                      },
                      child: const Text('25 mi')),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  child: const Text('Locate a restaurant!'),
                  onPressed: () {
                    // Navigate to the Yelp results route
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const YelpResultRoute()),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Result page
class YelpResultRoute extends StatefulWidget {
  const YelpResultRoute({super.key});

  @override
  State<YelpResultRoute> createState() => _YelpResultRouteState();
}

class _YelpResultRouteState extends State<YelpResultRoute> {
  late Future<List> yelpBusinesses;
  late Future<List> yelpBusinessReviews;

  late GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();

    // Get the MyappState
    var appState = context.read<MyAppState>();
    // Get the price and the radius
    var price = appState.price;
    var radius = appState.radius;
    var searchTerm = appState.searchTerm;

    // Get the lat and long of the device
    var latLong = appState.latLong;

    yelpBusinesses = fetchYelpBusiness(searchTerm, price, radius, latLong);
  }

  @override
  Widget build(BuildContext context) {
    Widget SelectedYelpBusiness = FutureBuilder<List>(
        future: yelpBusinesses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Get the reviews for the business
            yelpBusinessReviews =
                fetchYelpBusinessDetails(snapshot.data![0].id);

            Widget ReviewSection = FutureBuilder<List>(
              future: yelpBusinessReviews,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildReviewsSection(snapshot.data!);
                } else if (snapshot.hasError) {
                  return const Text('No reviews found...');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            );

            return Column(
              children: [
                _buildImageSection(snapshot.data![0].image_url),
                _buildTitleSection(snapshot.data![0].name),
                _buildCategories(snapshot.data![0].categories),
                _buildAddressSection(
                    snapshot.data![0].location['display_address']),
                _buildMetaDataSection(
                    snapshot.data![0].price,
                    snapshot.data![0].rating.toString(),
                    snapshot.data![0].review_count.toString(),
                    snapshot.data![0].display_phone,
                    snapshot.data![0].is_closed),
                _buildTransactionsSection(snapshot.data![0].transactions),
                SizedBox(
                  height: 150,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(snapshot.data![0].coordinates['latitude'],
                          snapshot.data![0].coordinates['longitude']),
                      zoom: 15.0,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(snapshot.data![0].id),
                        position: LatLng(
                            snapshot.data![0].coordinates['latitude'],
                            snapshot.data![0].coordinates['longitude']),
                        infoWindow: InfoWindow(
                          title: snapshot.data![0].name,
                          snippet: snapshot.data![0].location['display_address']
                              .join(', '),
                        ),
                      ),
                    },
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 16, bottom: 32),
                    child: ReviewSection),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        });

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: SelectedYelpBusiness),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 45),
                child: ElevatedButton(
                  child: const Text('Go back!'),
                  onPressed: () {
                    // Navigate back to the homepage
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(String imageUrl) {
    return Image.network(
      imageUrl,
      width: 600,
      height: 240,
      fit: BoxFit.cover,
    );
  }

  Widget _buildTitleSection(String title) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(List location) {
    String addressString = '';
    // Create the address string
    addressString = location.join(', ');

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16),
                child: Text(
                  addressString,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetaDataSection(
      String price, String rating, String reviewCount, String phone, bool isClosed) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4),
              child: Text(
                '$price | $rating stars | $reviewCount reviews | $phone',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
              child: Container(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  color: isClosed ? Colors.redAccent[100] : Colors.green[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  isClosed ? 'Closed now' : 'Open now',
                  style: TextStyle(
                    color: isClosed ? Colors.redAccent : Colors.green,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildCategories(List categories) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              runSpacing: 4.0,
              children: [
                for (var category in categories)
                  Container(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 4, bottom: 4, left: 8, right: 8),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(category['title'],
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                      )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTransactionsSection(List transactions) {
    return Container(
      alignment: Alignment.centerLeft,
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 4, bottom: 16),
      child: Row(
        children: [
          const Text('Transactions: ',
              style: TextStyle(
                color: Colors.grey,
              )),
          for (var transaction in transactions)
            Container(
                child: Container(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
              child: Text(transaction,
                  style: const TextStyle(
                    color: Colors.redAccent,
                  )),
            )),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(List reviews) {
    return Column(
      children: [
        const Row(children: [
          Text('Recent Reviews', style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
        for (var review in reviews)
          Container(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 16, bottom: 16),
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(review.user['image_url'].toString()),
                    radius: 30,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.text + ' - ${review.user['name']}',
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}

class YelpBusiness {
  final String id;
  final String alias;
  final String name;
  final String image_url;
  final bool is_closed;
  final String url;
  final int review_count;
  final List categories;
  final double rating;
  final Map coordinates;
  final List transactions;
  final String price;
  final Map location;
  final String phone;
  final String display_phone;

  const YelpBusiness({
    required this.id,
    required this.alias,
    required this.name,
    required this.image_url,
    required this.is_closed,
    required this.url,
    required this.review_count,
    required this.categories,
    required this.rating,
    required this.coordinates,
    required this.transactions,
    required this.price,
    required this.location,
    required this.phone,
    required this.display_phone,
  });

  factory YelpBusiness.fromJson(Map<String, dynamic> json) {
    return YelpBusiness(
      id: json['id'],
      alias: json['alias'],
      name: json['name'],
      image_url: json['image_url'],
      is_closed: json['is_closed'],
      url: json['url'],
      review_count: json['review_count'],
      categories: json['categories'],
      rating: json['rating'],
      coordinates: json['coordinates'],
      transactions: json['transactions'],
      price: json['price'],
      location: json['location'],
      phone: json['phone'],
      display_phone: json['display_phone'],
    );
  }
}

Future<List> fetchYelpBusiness(
    String searchTerm, int price, int radius, Map latLong) async {
  var apiEndpoint =
      'https://api.yelp.com/v3/businesses/search?term=$searchTerm&sort_by=best_match&limit=30';

  // If the price is not empty set the query parameter
  if (price > 0) {
    apiEndpoint += '&price=$price';
  }

  if (radius > 0) {
    apiEndpoint += '&radius=$radius';
  }

  if (latLong['lat'] != 0.0 && latLong['long'] != 0.0) {
    apiEndpoint += '&latitude=${latLong['lat']}&longitude=${latLong['long']}';
  }

  print(apiEndpoint);

  const headers = {
    "accept": 'application/json',
    "Authorization":
        'Bearer o68rs5vHugffSzIC4WRHFYFo4z-RB3-QLsYb1YAB1SoXLirNkSd24UuTLE5dIwmeNiHSA_BR8KzarnajjixScclbxOA-ww0FmA5vBztLjYM63m5aVqXxnYtt7DHtZHYx'
  };
  final response = await http.get(Uri.parse(apiEndpoint), headers: headers);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // Iterate though the businesses and create an array of YelpBusiness objects
    var businesses = [];
    // for (var business in jsonDecode(response.body)['businesses']) {
    //     businesses.add(YelpBusiness.fromJson(business));
    // }
    final random = Random();
    final decodedResponse = jsonDecode(response.body)['businesses'];
    final randomIndex = random.nextInt(decodedResponse.length);
    businesses.add(YelpBusiness.fromJson(decodedResponse[randomIndex]));

    return businesses;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load business');
  }
}

class YelpBusinessReview {
  final String id;
  final String url;
  final String text;
  final int rating;
  final Map user;

  const YelpBusinessReview({
    required this.id,
    required this.url,
    required this.text,
    required this.rating,
    required this.user,
  });

  factory YelpBusinessReview.fromJson(Map<String, dynamic> json) {
    return YelpBusinessReview(
      id: json['id'],
      url: json['url'],
      text: json['text'],
      rating: json['rating'],
      user: json['user'],
    );
  }
}

Future<List> fetchYelpBusinessDetails(String businessId) async {
  const apiEndpoint = 'https://api.yelp.com/v3/businesses/';
  const headers = {
    "accept": 'application/json',
    "Authorization":
        'Bearer o68rs5vHugffSzIC4WRHFYFo4z-RB3-QLsYb1YAB1SoXLirNkSd24UuTLE5dIwmeNiHSA_BR8KzarnajjixScclbxOA-ww0FmA5vBztLjYM63m5aVqXxnYtt7DHtZHYx'
  };
  final response = await http.get(
      Uri.parse('$apiEndpoint$businessId/reviews?limit=20&sort_by=yelp_sort'),
      headers: headers);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // Iterate though the businesses and create an array of YelpBusiness objects
    var reviews = [];
    for (var review in jsonDecode(response.body)['reviews']) {
      reviews.add(YelpBusinessReview.fromJson(review));
    }

    return reviews;
    // return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load business details');
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
