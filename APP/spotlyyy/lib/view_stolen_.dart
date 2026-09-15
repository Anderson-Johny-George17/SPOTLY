// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'Home_page.dart';
//
// void main() {
//   runApp(const ViewHouseApp());
// }
//
// class ViewHouseApp extends StatelessWidget {
//   const ViewHouseApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: UserViewHouse(title: 'View Stolen Vehicles'),
//     );
//   }
// }
//
// class UserViewHouse extends StatefulWidget {
//   const UserViewHouse({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   State<UserViewHouse> createState() => _UserViewHouseState();
// }
//
// class _UserViewHouseState extends State<UserViewHouse> {
//   List<Map<String, dynamic>> users = [];
//   bool isLoading = true;
//   String imgurl = '';
//
//   @override
//   void initState() {
//     super.initState();
//     viewUsers();
//   }
//
//   Future<void> viewUsers() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String baseUrl = sh.getString('url') ?? '';
//       String imgUrl = sh.getString('img_url') ?? '';
//       String lid = sh.getString('lid') ?? '';
//
//       if (baseUrl.isEmpty) {
//         Fluttertoast.showToast(msg: "Base URL not found");
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }
//
//       final apiUrl = Uri.parse('$baseUrl/viw_stolen_get/');
//
//       final response = await http.post(apiUrl,body: {
//         'lid': lid, // Add lid to the body
//
//       });
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//
//         if (jsonData['status'] == 'ok') {
//           List<Map<String, dynamic>> temp = [];
//
//           for (var item in jsonData['data']) {
//             temp.add({
//               'id': item['id'],
//               'vehicle_type': item['vehicle_type'].toString(),
//               'vehicle_color': item['vehicle_color'].toString(),
//               'longitude': item['longitude'].toString(),
//               'latitude': item['latitude'].toString(),
//               'vehicle_image': imgUrl + item['vehicle_image'].toString(),
//             });
//           }
//
//           setState(() {
//             users = temp;
//             isLoading = false;
//             imgurl = imgUrl;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//           Fluttertoast.showToast(msg: jsonData['message'] ?? "No data found");
//         }
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         Fluttertoast.showToast(msg: "Server error: ${response.statusCode}");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error fetching data: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _delete(String id) async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String baseUrl = sh.getString('url') ?? '';
//       String lid = sh.getString('lid') ?? '';
//
//       if (baseUrl.isEmpty) {
//         Fluttertoast.showToast(msg: "Base URL not set");
//         return;
//       }
//
//       final apiUrl = Uri.parse('$baseUrl/delete_stolen_vechile/');
//
//       final response = await http.post(apiUrl, body: {
//         'id': id,
//         'lid': lid, // Add lid to the body
//       });
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         if (jsonData['status'] == 'ok') {
//           Fluttertoast.showToast(msg: "Vehicle deleted successfully");
//           // Remove the deleted vehicle from the list
//           setState(() {
//             users.removeWhere((user) => user['id'].toString() == id);
//           });
//         } else {
//           Fluttertoast.showToast(msg: jsonData['message'] ?? "Failed to delete");
//         }
//       } else {
//         Fluttertoast.showToast(msg: "Server error: ${response.statusCode}");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error deleting vehicle: $e");
//     }
//   }
//
//   Future<void> _getCurrentLocation(String id) async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         Fluttertoast.showToast(msg: "Enable location services");
//         return;
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           Fluttertoast.showToast(msg: "Location permission denied");
//           return;
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         Fluttertoast.showToast(msg: "Enable location permission from settings");
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       _submitReport(id, position.latitude, position.longitude);
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Location error: $e");
//     }
//   }
//
//   Future<void> _submitReport(String id, double lat, double lng) async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String baseUrl = sh.getString('url') ?? '';
//       String lid = sh.getString('lid') ?? '';
//
//       final uri = Uri.parse('$baseUrl/found_stolen_vehicle/');
//
//       final response = await http.post(uri, body: {
//         'lati': lat.toString(),
//         'longi': lng.toString(),
//         'lid': lid,
//         'stolen_v_id': id,
//       });
//
//       if (response.statusCode == 200) {
//         Fluttertoast.showToast(msg: "Vehicle reported successfully");
//       } else {
//         Fluttertoast.showToast(msg: "Report failed: ${response.statusCode}");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error reporting: $e");
//     }
//   }
//
//   Future<void> _showDeleteConfirmation(BuildContext context, String id, String vehicleType) async {
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Confirm Delete"),
//           content: Text("Are you sure you want to delete the stolen vehicle: $vehicleType?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("CANCEL"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _delete(id);
//               },
//               child: const Text(
//                 "DELETE",
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildVehicleCard(Map<String, dynamic> user) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.blue.shade50,
//               Colors.blue.shade100.withOpacity(0.3),
//               Colors.white,
//             ],
//           ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header with vehicle type and delete button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       user['vehicle_type'],
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blueGrey,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () => _showDeleteConfirmation(
//                       context,
//                       user['id'].toString(),
//                       user['vehicle_type'],
//                     ),
//                     icon: const Icon(Icons.delete_outline),
//                     color: Colors.red.shade600,
//                     tooltip: "Delete Vehicle",
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 12),
//
//               // Vehicle Image
//               Container(
//                 height: 150,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.blue.shade200),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: user['vehicle_image'] != null && user['vehicle_image'].toString().isNotEmpty
//                       ? Image.network(
//                     user['vehicle_image'],
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//                               : null,
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         color: Colors.grey.shade200,
//                         child: const Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.car_repair,
//                               size: 50,
//                               color: Colors.grey,
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               "Image not available",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   )
//                       : Container(
//                     color: Colors.grey.shade200,
//                     child: const Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.car_repair,
//                           size: 50,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           "No image",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Vehicle Details
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade200),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildDetailRow("Color", user['vehicle_color']),
//                     const SizedBox(height: 8),
//                     _buildDetailRow("Latitude", user['latitude']),
//                     _buildDetailRow("Longitude", user['longitude']),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Action Buttons
//               Row(
//                 children: [
//                   // Expanded(
//                   //   child: ElevatedButton.icon(
//                   //     onPressed: () => _getCurrentLocation(user['id'].toString()),
//                   //     icon: const Icon(Icons.report, size: 18),
//                   //     label: const Text("REPORT FOUND"),
//                   //     style: ElevatedButton.styleFrom(
//                   //       backgroundColor: Colors.red.shade600,
//                   //       foregroundColor: Colors.white,
//                   //       padding: const EdgeInsets.symmetric(vertical: 12),
//                   //       shape: RoundedRectangleBorder(
//                   //         borderRadius: BorderRadius.circular(8),
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () => _showDeleteConfirmation(
//                         context,
//                         user['id'].toString(),
//                         user['vehicle_type'],
//                       ),
//                       icon: const Icon(Icons.delete_outline, size: 18),
//                       label: const Text("DELETE"),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.red.shade600,
//                         side: BorderSide(color: Colors.red.shade400),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 80,
//           child: Text(
//             "$label:",
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade700,
//             ),
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const MyHomepage(title: ''),
//           ),
//         );
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//           backgroundColor: Colors.blue.shade700,
//           elevation: 2,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               onPressed: viewUsers,
//               tooltip: "Refresh",
//             ),
//           ],
//         ),
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.blue.shade50,
//                 Colors.grey.shade50,
//               ],
//             ),
//           ),
//           child: isLoading
//               ? const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                   strokeWidth: 3,
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   "Loading stolen vehicles...",
//                   style: TextStyle(
//                     color: Colors.blueGrey,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           )
//               : users.isEmpty
//               ? Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.car_crash,
//                   size: 80,
//                   color: Colors.grey.shade400,
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "No stolen vehicles found",
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Report a stolen vehicle to get started",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const MyHomepage(title: ''),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.home),
//                   label: const Text("Go to Home"),
//                 ),
//               ],
//             ),
//           )
//               : Column(
//             children: [
//               // Stats Banner
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                 color: Colors.blue.shade100,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             "${users.length}",
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         const Text(
//                           "Stolen Vehicles",
//                           style: TextStyle(
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.red.shade50,
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.red.shade100),
//                       ),
//                       child: const Row(
//                         children: [
//                           Icon(
//                             Icons.warning_amber,
//                             size: 14,
//                             color: Colors.red,
//                           ),
//                           SizedBox(width: 6),
//                           Text(
//                             "STOLEN",
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.red,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Vehicles List
//               Expanded(
//                 child: RefreshIndicator(
//                   onRefresh: viewUsers,
//                   child: ListView.builder(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     itemCount: users.length,
//                     itemBuilder: (context, index) {
//                       return _buildVehicleCard(users[index]);
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const MyHomepage(title: ''),
//               ),
//             );
//           },
//           icon: const Icon(Icons.home),
//           label: const Text("Home"),
//           backgroundColor: Colors.blue.shade600,
//           foregroundColor: Colors.white,
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

import 'Home_page.dart';

void main() {
  runApp(const ViewHouseApp());
}

class ViewHouseApp extends StatelessWidget {
  const ViewHouseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserViewHouse(title: 'View Stolen Vehicles'),
    );
  }
}

class UserViewHouse extends StatefulWidget {
  const UserViewHouse({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<UserViewHouse> createState() => _UserViewHouseState();
}

class _UserViewHouseState extends State<UserViewHouse> with TickerProviderStateMixin {
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;
  String imgurl = '';

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _listController;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    viewUsers();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeController.forward();
    _listController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _listController.dispose();
    super.dispose();
  }

  Future<void> viewUsers() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String baseUrl = sh.getString('url') ?? '';
      String imgUrl = sh.getString('img_url') ?? '';
      String lid = sh.getString('lid') ?? '';

      if (baseUrl.isEmpty) {
        Fluttertoast.showToast(msg: "Base URL not found");
        setState(() => isLoading = false);
        return;
      }

      final apiUrl = Uri.parse('$baseUrl/viw_stolen_get/');
      final response = await http.post(apiUrl, body: {'lid': lid});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'ok') {
          List<Map<String, dynamic>> temp = [];

          for (var item in jsonData['data']) {
            temp.add({
              'id': item['id'],
              'vehicle_type': item['vehicle_type'].toString(),
              'vehicle_color': item['vehicle_color'].toString(),
              'longitude': item['longitude'].toString(),
              'latitude': item['latitude'].toString(),
              'vehicle_image': imgUrl + item['vehicle_image'].toString(),
            });
          }

          setState(() {
            users = temp;
            isLoading = false;
            imgurl = imgUrl;
            _setupItemAnimations();
          });
        } else {
          setState(() => isLoading = false);
          Fluttertoast.showToast(msg: jsonData['message'] ?? "No data found");
        }
      } else {
        setState(() => isLoading = false);
        Fluttertoast.showToast(msg: "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

  void _setupItemAnimations() {
    _itemAnimations = List.generate(users.length, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _listController,
          curve: Interval(
            index * 0.1,
            0.5 + (index * 0.1),
            curve: Curves.easeOutBack,
          ),
        ),
      );
    });
  }

  Future<void> _delete(String id) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String baseUrl = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';

      if (baseUrl.isEmpty) {
        Fluttertoast.showToast(msg: "Base URL not set");
        return;
      }

      final apiUrl = Uri.parse('$baseUrl/delete_stolen_vechile/');
      final response = await http.post(apiUrl, body: {'id': id, 'lid': lid});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: "Vehicle deleted successfully",
            backgroundColor: const Color(0xFF28a745),
            textColor: Colors.white,
          );
          setState(() {
            users.removeWhere((user) => user['id'].toString() == id);
            _setupItemAnimations();
          });
        } else {
          Fluttertoast.showToast(
            msg: jsonData['message'] ?? "Failed to delete",
            backgroundColor: const Color(0xFFe63946),
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Server error: ${response.statusCode}",
          backgroundColor: const Color(0xFFe63946),
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error deleting vehicle: $e",
        backgroundColor: const Color(0xFFe63946),
        textColor: Colors.white,
      );
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context, String id, String vehicleType) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFe63946)),
              SizedBox(width: 10),
              Text("Confirm Delete"),
            ],
          ),
          content: Text("Are you sure you want to delete the stolen vehicle: $vehicleType?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _delete(id);
              },
              child: const Text(
                "DELETE",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomepage(title: ''),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: const Text(
            'Stolen Vehicles',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF4361ee),
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: viewUsers,
              tooltip: "Refresh",
            ),
          ],
        ),
        body: isLoading
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4361ee)),
                backgroundColor: const Color(0xFF4361ee).withOpacity(0.1),
                strokeWidth: 3,
              ),
              const SizedBox(height: 20),
              const Text(
                "Loading stolen vehicles...",
                style: TextStyle(
                  color: Color(0xFF495057),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
            : users.isEmpty
            ? Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.car_crash_rounded,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "No stolen vehicles found",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF495057),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Report a stolen vehicle to get started",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomepage(title: ''),
                      ),
                    );
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text("Go to Home"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4361ee),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
            : RefreshIndicator(
          onRefresh: viewUsers,
          color: const Color(0xFF4361ee),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return FadeTransition(
                opacity: _itemAnimations[index],
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _listController,
                      curve: Interval(
                        index * 0.1,
                        0.5 + (index * 0.1),
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                  ),
                  child: _buildVehicleCard(users[index]),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomepage(title: ''),
              ),
            );
          },
          icon: const Icon(Icons.home_rounded),
          label: const Text("Home"),
          backgroundColor: const Color(0xFF4361ee),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF4361ee).withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4361ee).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.directions_car_rounded,
                        color: Color(0xFF4361ee),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['vehicle_type'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1a1a2e),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFe63946).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'STOLEN',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFe63946),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _showDeleteConfirmation(
                    context,
                    user['id'].toString(),
                    user['vehicle_type'],
                  ),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFe63946).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFe63946),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Vehicle Image
          if (user['vehicle_image'] != null && user['vehicle_image'].toString().isNotEmpty)
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  user['vehicle_image'],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                        color: const Color(0xFF4361ee),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported_rounded,
                              size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            "Image not available",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Vehicle Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow("Color", user['vehicle_color']),
                const SizedBox(height: 12),
                _buildDetailRow("Latitude", user['latitude']),
                _buildDetailRow("Longitude", user['longitude']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            "$label:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Color(0xFF1a1a2e),
            ),
          ),
        ),
      ],
    );
  }
}