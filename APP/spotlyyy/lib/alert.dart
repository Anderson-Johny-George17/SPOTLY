// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
// import 'package:map_launcher/map_launcher.dart';
//
// class ViewAlertsPage extends StatefulWidget {
//   const ViewAlertsPage({Key? key}) : super(key: key);
//
//   @override
//   State<ViewAlertsPage> createState() => _ViewAlertsPageState();
// }
//
// class _ViewAlertsPageState extends State<ViewAlertsPage> {
//   List<Map<String, dynamic>> allAlerts = [];
//   List<Map<String, dynamic>> filteredAlerts = [];
//   Map<String, dynamic>? selectedVehicleDetails;
//   bool isLoading = true;
//   bool showOnlyYes = true;
//   bool isLoadingVehicleDetails = false;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAlerts();
//   }
//
//   Future<void> fetchAlerts() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String baseUrl = sh.getString('url') ?? '';
//       String lid = sh.getString('lid') ?? '';
//
//       if (baseUrl.isEmpty) {
//         Fluttertoast.showToast(msg: "Base URL not set");
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }
//
//       final apiUrl = Uri.parse('$baseUrl/view_alert/');
//
//       final response = await http.post(apiUrl, body: {
//         'lid': lid,
//       });
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//
//         if (jsonData['status'] == 'ok' && jsonData['data'] != null) {
//           List<Map<String, dynamic>> temp = [];
//
//           for (var item in jsonData['data']) {
//             String detailsRaw = item['details'].toString();
//
//             temp.add({
//               'id': item['id'].toString(),
//               'status': item['status'].toString(),
//               'details': detailsRaw,
//               'latitude': item['latitude']?.toString() ?? '0.0',
//               'longitude': item['longitude']?.toString() ?? '0.0',
//               'detected_at': item['detected_at'].toString(),
//               'stolen_vehicle_id': item['stolen_vehicle_id'].toString(),
//             });
//           }
//
//           setState(() {
//             allAlerts = temp;
//             filteredAlerts = filterAlerts(temp);
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//           Fluttertoast.showToast(msg: jsonData['message'] ?? "No alerts found");
//         }
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         Fluttertoast.showToast(msg: "Server error: ${response.statusCode}");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error fetching alerts: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> fetchVehicleDetails(String stolenVehicleId) async {
//     try {
//       setState(() {
//         isLoadingVehicleDetails = true;
//       });
//
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String baseUrl = sh.getString('url') ?? '';
//       String lid = sh.getString('lid') ?? '';
//
//       final apiUrl = Uri.parse('$baseUrl/get_vehicle_details/');
//
//       final response = await http.post(apiUrl, body: {
//         'lid': lid,
//         'vehicle_id': stolenVehicleId,
//       });
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         if (jsonData['status'] == 'ok') {
//           setState(() {
//             selectedVehicleDetails = jsonData['vehicle'];
//             isLoadingVehicleDetails = false;
//           });
//
//           // Show vehicle details modal
//           _showVehicleDetailsModal();
//         } else {
//           setState(() {
//             isLoadingVehicleDetails = false;
//           });
//           Fluttertoast.showToast(msg: jsonData['message'] ?? "Failed to load vehicle details");
//         }
//       } else {
//         setState(() {
//           isLoadingVehicleDetails = false;
//         });
//         Fluttertoast.showToast(msg: "Server error: ${response.statusCode}");
//       }
//     } catch (e) {
//       setState(() {
//         isLoadingVehicleDetails = false;
//       });
//       Fluttertoast.showToast(msg: "Error loading vehicle details: $e");
//     }
//   }
//
//   List<Map<String, dynamic>> filterAlerts(List<Map<String, dynamic>> alerts) {
//     if (!showOnlyYes) return alerts;
//
//     return alerts.where((alert) {
//       String details = alert['details'].toLowerCase();
//       return details.contains("gemini_result") &&
//           (details.contains("'yes") ||
//               details.contains('"yes') ||
//               details.contains(" yes,") ||
//               details.contains(" yes.") ||
//               details.contains("yes:"));
//     }).toList();
//   }
//
//   void toggleFilter() {
//     setState(() {
//       showOnlyYes = !showOnlyYes;
//       filteredAlerts = filterAlerts(allAlerts);
//     });
//
//     Fluttertoast.showToast(
//       msg: showOnlyYes ? "Showing only detected vehicles" : "Showing all alerts",
//       toastLength: Toast.LENGTH_SHORT,
//     );
//   }
//
//   Future<void> _launchMap(double lat, double lng, String? vehicleId) async {
//     final availableMaps = await MapLauncher.installedMaps;
//
//     if (availableMaps.isEmpty) {
//       // Fallback to URL launch for Google Maps
//       final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
//       if (await canLaunch(url)) {
//         await launch(url);
//       } else {
//         Fluttertoast.showToast(msg: "Could not launch maps");
//       }
//       return;
//     }
//
//     await showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Text(
//                   'Open Location in:',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue.shade700,
//                   ),
//                 ),
//               ),
//               ...availableMaps.map((map) => ListTile(
//                 leading: Image.asset(
//                   map.icon,
//                   height: 30,
//                   width: 30,
//                 ),
//                 title: Text(map.mapName),
//                 onTap: () {
//                   Navigator.pop(context);
//                   map.showMarker(
//                     coords: Coords(lat, lng),
//                     title: vehicleId != null
//                         ? "Detected Vehicle Location (ID: $vehicleId)"
//                         : "Alert Location",
//                     description: "Vehicle detection alert location",
//                   );
//                 },
//               )),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildLocationSection(Map<String, dynamic> alert) {
//     double lat = double.tryParse(alert['latitude']) ?? 0.0;
//     double lng = double.tryParse(alert['longitude']) ?? 0.0;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(
//               Icons.location_on,
//               size: 16,
//               color: Colors.red.shade600,
//             ),
//             const SizedBox(width: 6),
//             Text(
//               "Detection Location",
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 12,
//                 color: Colors.red.shade600,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Coordinates:",
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   Text(
//                     "${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}",
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       fontFamily: 'RobotoMono',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 10),
//             ElevatedButton.icon(
//               onPressed: () => _launchMap(lat, lng, alert['stolen_vehicle_id']),
//               icon: const Icon(Icons.map, size: 16),
//               label: const Text("View on Map"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red.shade500,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Container(
//           height: 120,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey.shade300),
//             color: Colors.grey.shade100,
//           ),
//           child: Stack(
//             children: [
//               // Placeholder for map - You can replace with actual map widget
//               Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.location_pin,
//                       size: 40,
//                       color: Colors.red.shade500,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Lat: ${lat.toStringAsFixed(4)}",
//                       style: const TextStyle(fontSize: 12),
//                     ),
//                     Text(
//                       "Lng: ${lng.toStringAsFixed(4)}",
//                       style: const TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 bottom: 8,
//                 right: 8,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.black54,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Text(
//                     "Tap button for full map",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAlertCard(Map<String, dynamic> alert) {
//     String details = alert['details'];
//     bool isDetected = _extractGeminiResult(details).toLowerCase().contains('yes');
//     String geminiResult = _extractGeminiResult(details);
//
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
//             colors: isDetected
//                 ? [Colors.green.shade50, Colors.lightGreen.shade50]
//                 : [Colors.white, Colors.grey.shade50],
//           ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Alert #${alert['id']}",
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blueGrey,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           _formatDateTime(alert['detected_at']),
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: isDetected ? Colors.green : Colors.orange,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       isDetected ? "DETECTED" : "NO MATCH",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//
//               // Stolen Vehicle Section
//               GestureDetector(
//                 onTap: () => fetchVehicleDetails(alert['stolen_vehicle_id']),
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.blue.shade100),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade100,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.directions_car,
//                           color: Colors.blue,
//                           size: 24,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Stolen Vehicle ID: ${alert['stolen_vehicle_id']}",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "Tap to view vehicle details →",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.blue.shade600,
//                                 fontStyle: FontStyle.italic,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Icon(
//                         Icons.chevron_right,
//                         color: Colors.blue,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Location Section
//               _buildLocationSection(alert),
//
//               const SizedBox(height: 16),
//
//               // Analysis Result
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: isDetected ? Colors.green.shade50 : Colors.orange.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: isDetected ? Colors.green.shade200 : Colors.orange.shade200,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.analytics,
//                           size: 18,
//                           color: isDetected ? Colors.green.shade700 : Colors.orange.shade700,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           "AI Analysis Result",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                             color: isDetected ? Colors.green.shade700 : Colors.orange.shade700,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(6),
//                         border: Border.all(color: Colors.grey.shade200),
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (isDetected)
//                               Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                 decoration: BoxDecoration(
//                                   color: Colors.green.shade100,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       Icons.check_circle,
//                                       size: 16,
//                                       color: Colors.green.shade800,
//                                     ),
//                                     const SizedBox(width: 6),
//                                     Text(
//                                       "MATCH CONFIRMED",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 12,
//                                         color: Colors.green.shade800,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             else
//                               Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                 decoration: BoxDecoration(
//                                   color: Colors.orange.shade100,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       Icons.close,
//                                       size: 16,
//                                       color: Colors.orange.shade800,
//                                     ),
//                                     const SizedBox(width: 6),
//                                     Text(
//                                       "NO MATCH FOUND",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 12,
//                                         color: Colors.orange.shade800,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             const SizedBox(height: 12),
//                             SelectableText(
//                               geminiResult,
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 height: 1.5,
//                                 fontFamily: 'RobotoMono',
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // Action Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () => _launchMap(
//                         double.tryParse(alert['latitude']) ?? 0.0,
//                         double.tryParse(alert['longitude']) ?? 0.0,
//                         alert['stolen_vehicle_id'],
//                       ),
//                       icon: const Icon(Icons.map, size: 18),
//                       label: const Text("Open in Maps"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red.shade500,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () => fetchVehicleDetails(alert['stolen_vehicle_id']),
//                       icon: const Icon(Icons.car_rental, size: 18),
//                       label: const Text("Vehicle Details"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue.shade500,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 10),
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
//   void _showVehicleDetailsModal() {
//     if (selectedVehicleDetails == null) return;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           height: MediaQuery.of(context).size.height * 0.8,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Stolen Vehicle Details",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blueGrey,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//               const Divider(),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Vehicle Info Card
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         margin: const EdgeInsets.only(bottom: 16),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade50,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.blue.shade100),
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.car_crash,
//                                   color: Colors.red.shade600,
//                                   size: 24,
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Text(
//                                     "STOLEN VEHICLE REPORT",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.red.shade600,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       // Details Grid
//                       GridView.count(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 12,
//                         mainAxisSpacing: 12,
//                         childAspectRatio: 2.5,
//                         children: [
//                           _buildDetailItem("Vehicle ID", selectedVehicleDetails!['id']?.toString() ?? 'N/A'),
//                           _buildDetailItem("Registration No", selectedVehicleDetails!['reg_no']?.toString() ?? 'N/A'),
//                           _buildDetailItem("Vehicle Type", selectedVehicleDetails!['vehicle_type']?.toString() ?? 'N/A'),
//                           _buildDetailItem("Brand", selectedVehicleDetails!['brand']?.toString() ?? 'N/A'),
//                           _buildDetailItem("Model", selectedVehicleDetails!['model']?.toString() ?? 'N/A'),
//                           _buildDetailItem("Color", selectedVehicleDetails!['color']?.toString() ?? 'N/A'),
//                           _buildDetailItem("Year", selectedVehicleDetails!['year']?.toString() ?? 'N/A'),
//                           _buildDetailItem("Fuel Type", selectedVehicleDetails!['fuel_type']?.toString() ?? 'N/A'),
//                           _buildDetailItem("Engine No", selectedVehicleDetails!['engine_no']?.toString() ?? 'N/A'),
//                           _buildDetailItem("Chassis No", selectedVehicleDetails!['chassis_no']?.toString() ?? 'N/A'),
//                           _buildDetailItem("Stolen From", selectedVehicleDetails!['stolen_location']?.toString() ?? 'N/A'),
//                           _buildDetailItem("Stolen Date", selectedVehicleDetails!['stolen_date']?.toString() ?? 'N/A'),
//                           _buildDetailItem("Police Station", selectedVehicleDetails!['police_station']?.toString() ?? 'N/A'),
//                           _buildDetailItem("FIR No", selectedVehicleDetails!['fir_no']?.toString() ?? 'N/A'),
//                         ],
//                       ),
//
//                       // Additional Info
//                       if (selectedVehicleDetails!['additional_info']?.toString().isNotEmpty == true)
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           margin: const EdgeInsets.only(top: 16),
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade50,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.grey.shade300),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Additional Information:",
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blueGrey,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 selectedVehicleDetails!['additional_info']?.toString() ?? '',
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                       // Images if available
//                       if (selectedVehicleDetails!['photo']?.toString().isNotEmpty == true)
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           margin: const EdgeInsets.only(top: 16),
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade50,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.grey.shade300),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Vehicle Photos:",
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blueGrey,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               // You can add image display here
//                               Container(
//                                 height: 150,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade200,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Center(
//                                   child: Icon(
//                                     Icons.car_repair,
//                                     size: 50,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               const Text(
//                                 "Tap to view full image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                   fontStyle: FontStyle.italic,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildDetailItem(String title, String value) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 2,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 11,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _extractGeminiResult(String details) {
//     try {
//       if (details.contains("'gemini_result':")) {
//         final match = RegExp(r"'gemini_result':\s*'([^']*)'").firstMatch(details);
//         if (match != null && match.groupCount >= 1) {
//           return match.group(1)?.replaceAll(r'\n', '\n') ?? details;
//         }
//       }
//       return details;
//     } catch (e) {
//       return details;
//     }
//   }
//
//   String _formatDateTime(String dateTime) {
//     try {
//       final dt = DateTime.parse(dateTime);
//       return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return dateTime;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Vehicle Detection Alerts"),
//         backgroundColor: Colors.blue.shade700,
//         elevation: 2,
//         actions: [
//           IconButton(
//             icon: Icon(
//               showOnlyYes ? Icons.filter_alt : Icons.filter_alt_off,
//               color: Colors.white,
//             ),
//             onPressed: toggleFilter,
//             tooltip: showOnlyYes ? "Show all alerts" : "Show only detected",
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//               strokeWidth: 3,
//             ),
//             SizedBox(height: 20),
//             Text(
//               "Loading alerts...",
//               style: TextStyle(
//                 color: Colors.blueGrey,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       )
//           : filteredAlerts.isEmpty
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.notifications_off,
//               size: 80,
//               color: Colors.grey.shade400,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               showOnlyYes
//                   ? "No detected vehicles found"
//                   : "No alerts available",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.grey.shade600,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       )
//           : Column(
//         children: [
//           // Stats Banner
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             color: Colors.blue.shade100,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         "${filteredAlerts.length} ${showOnlyYes ? 'Detected' : 'Total'}",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       showOnlyYes
//                           ? "vehicles detected"
//                           : "alerts",
//                       style: TextStyle(
//                         color: Colors.blue.shade800,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Chip(
//                   label: Text(
//                     showOnlyYes ? "Filter: Detected Only" : "Showing All",
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                   backgroundColor: showOnlyYes ? Colors.green.shade100 : Colors.grey.shade200,
//                 ),
//               ],
//             ),
//           ),
//
//           // Alerts List
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               itemCount: filteredAlerts.length,
//               itemBuilder: (context, index) {
//                 return _buildAlertCard(filteredAlerts[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: fetchAlerts,
//         backgroundColor: Colors.blue,
//         child: const Icon(Icons.refresh, color: Colors.white),
//         tooltip: "Refresh alerts",
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';
import 'dart:ui';

class ViewAlertsPage extends StatefulWidget {
  const ViewAlertsPage({Key? key}) : super(key: key);

  @override
  State<ViewAlertsPage> createState() => _ViewAlertsPageState();
}

class _ViewAlertsPageState extends State<ViewAlertsPage> with TickerProviderStateMixin {
  List<Map<String, dynamic>> allAlerts = [];
  List<Map<String, dynamic>> filteredAlerts = [];
  bool isLoading = true;
  bool showOnlyGemini = true;
  String imgUrl = '';

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _listController;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadPreferences();
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
      duration: const Duration(milliseconds: 1000),
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

  void _setupItemAnimations() {
    _itemAnimations = List.generate(filteredAlerts.length, (index) {
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

  Future<void> _loadPreferences() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    setState(() {
      imgUrl = sh.getString('d_url') ?? '';
    });
    fetchAlerts();
  }

  Future<void> fetchAlerts() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String baseUrl = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';

      if (baseUrl.isEmpty) {
        Fluttertoast.showToast(msg: "Base URL not set");
        setState(() {
          isLoading = false;
        });
        return;
      }

      final apiUrl = Uri.parse('$baseUrl/view_alert/');
      final response = await http.post(apiUrl, body: {'lid': lid});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'ok' && jsonData['data'] != null) {
          List<Map<String, dynamic>> temp = [];

          for (var item in jsonData['data']) {
            String detailsRaw = item['details'].toString();

            String detectedImageUrl = '';
            if (item['detected_image'] != null && item['detected_image'].toString().isNotEmpty) {
              String imgPath = item['detected_image'].toString();
              if (imgPath.startsWith('/')) {
                imgPath = imgPath.substring(1);
              }
              if (imgPath.startsWith('media/')) {
                imgPath = imgPath.substring(6);
              }
              detectedImageUrl = '$imgUrl$imgPath';
            }

            temp.add({
              'id': item['id'].toString(),
              'status': item['status'].toString(),
              'details': detailsRaw,
              'latitude': item['latitude']?.toString() ?? '0.0',
              'longitude': item['longitude']?.toString() ?? '0.0',
              'detected_at': item['detected_at'].toString(),
              'detected_image': detectedImageUrl,
              'stolen_vehicle_id': item['stolen_vehicle_id'].toString(),
            });
          }

          setState(() {
            allAlerts = temp;
            filteredAlerts = filterAlerts(temp);
            isLoading = false;
            _setupItemAnimations();
          });
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: jsonData['message'] ?? "No alerts found");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching alerts: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> filterAlerts(List<Map<String, dynamic>> alerts) {
    if (!showOnlyGemini) return alerts;

    return alerts.where((alert) {
      String details = alert['details'].toLowerCase();

      bool hasGeminiAnalysis = details.contains('gemini_result') ||
          details.contains('gemini_analysis') ||
          details.contains('gemini_verdict') ||
          details.contains('ai_analysis') ||
          details.contains('google_gemini') ||
          details.contains('gemini:');

      return hasGeminiAnalysis;
    }).toList();
  }

  // Parse Gemini analysis from first code
  Map<String, dynamic> parseGeminiAnalysis(String details) {
    Map<String, dynamic> result = {
      'has_gemini_analysis': false,
      'gemini_result': '',
      'gemini_confidence': 0.0,
      'gemini_reason': '',
      'gemini_details': {},
      'is_match': false,
      'vehicle_info': {},
      'raw_gemini_response': '',
    };

    try {
      try {
        Map<String, dynamic> jsonData = json.decode(details);
        _extractGeminiFromJson(jsonData, result);
        return result;
      } catch (e) {
        _extractGeminiFromString(details, result);
        return result;
      }
    } catch (e) {
      print('Error parsing Gemini analysis: $e');
      result['raw_gemini_response'] = details;
      return result;
    }
  }

  void _extractGeminiFromJson(Map<String, dynamic> jsonData, Map<String, dynamic> result) {
    if (jsonData.containsKey('gemini_result')) {
      result['has_gemini_analysis'] = true;
      result['gemini_result'] = jsonData['gemini_result'].toString();
      result['is_match'] = result['gemini_result'].toString().toLowerCase().contains('yes');
    }

    if (jsonData.containsKey('gemini_analysis')) {
      result['has_gemini_analysis'] = true;
      result['gemini_result'] = jsonData['gemini_analysis'].toString();
      result['is_match'] = result['gemini_result'].toString().toLowerCase().contains('yes');
    }

    if (jsonData.containsKey('gemini_verdict')) {
      result['has_gemini_analysis'] = true;
      result['gemini_result'] = jsonData['gemini_verdict'].toString();
      result['is_match'] = result['gemini_result'].toString().toLowerCase().contains('yes');
    }

    if (jsonData.containsKey('gemini_confidence')) {
      result['gemini_confidence'] = double.tryParse(jsonData['gemini_confidence'].toString()) ?? 0.0;
    } else if (jsonData.containsKey('confidence')) {
      result['gemini_confidence'] = double.tryParse(jsonData['confidence'].toString()) ?? 0.0;
    }

    if (jsonData.containsKey('gemini_reason')) {
      result['gemini_reason'] = jsonData['gemini_reason'].toString();
    } else if (jsonData.containsKey('reason')) {
      result['gemini_reason'] = jsonData['reason'].toString();
    }

    if (jsonData.containsKey('vehicle_make')) {
      result['vehicle_info']['make'] = jsonData['vehicle_make'].toString();
    }
    if (jsonData.containsKey('vehicle_model')) {
      result['vehicle_info']['model'] = jsonData['vehicle_model'].toString();
    }
    if (jsonData.containsKey('vehicle_color')) {
      result['vehicle_info']['color'] = jsonData['vehicle_color'].toString();
    }
    if (jsonData.containsKey('license_plate')) {
      result['vehicle_info']['license_plate'] = jsonData['license_plate'].toString();
    }
    if (jsonData.containsKey('plate_number')) {
      result['vehicle_info']['license_plate'] = jsonData['plate_number'].toString();
    }

    jsonData.forEach((key, value) {
      if (key.startsWith('gemini_') ||
          key.contains('ai_') ||
          key.contains('analysis_')) {
        result['gemini_details'][key] = value.toString();
      }
    });
  }

  void _extractGeminiFromString(String details, Map<String, dynamic> result) {
    String lowerDetails = details.toLowerCase();

    if (lowerDetails.contains('gemini') ||
        lowerDetails.contains('ai analysis') ||
        lowerDetails.contains('ai_analysis')) {
      result['has_gemini_analysis'] = true;
      result['raw_gemini_response'] = details;

      RegExp geminiResultRegex = RegExp(
        '(gemini[_\\s]?(result|analysis|verdict)[\\s:]*["\']?([^"\'\\n]+)["\']?)',
        caseSensitive: false,
      );

      var geminiMatch = geminiResultRegex.firstMatch(details);
      if (geminiMatch != null && geminiMatch.groupCount >= 2) {
        result['gemini_result'] = geminiMatch.group(2)!.trim();
        result['is_match'] = result['gemini_result'].toLowerCase().contains('yes');
      } else {
        if (lowerDetails.contains('yes') && lowerDetails.contains('gemini')) {
          result['gemini_result'] = 'Yes';
          result['is_match'] = true;
        } else if (lowerDetails.contains('no') && lowerDetails.contains('gemini')) {
          result['gemini_result'] = 'No';
          result['is_match'] = false;
        }
      }

      RegExp confidenceRegex = RegExp(r'(\d+(?:\.\d+)?)%\s*(?:confidence|match|similarity)');
      var confidenceMatch = confidenceRegex.firstMatch(details);
      if (confidenceMatch != null) {
        result['gemini_confidence'] = double.tryParse(confidenceMatch.group(1)!) ?? 0.0;
      }

      if (lowerDetails.contains('because') || lowerDetails.contains('reason:')) {
        int startIndex = lowerDetails.contains('because')
            ? lowerDetails.indexOf('because')
            : lowerDetails.indexOf('reason:');
        result['gemini_reason'] = details.substring(startIndex).trim();
      }

      RegExp makeRegex = RegExp(r'(?:make|brand)[\s:]*([^\s,;]+)', caseSensitive: false);
      var makeMatch = makeRegex.firstMatch(details);
      if (makeMatch != null) {
        result['vehicle_info']['make'] = makeMatch.group(1)!;
      }

      RegExp modelRegex = RegExp(r'(?:model|type)[\s:]*([^\s,;]+)', caseSensitive: false);
      var modelMatch = modelRegex.firstMatch(details);
      if (modelMatch != null) {
        result['vehicle_info']['model'] = modelMatch.group(1)!;
      }

      RegExp colorRegex = RegExp(r'(?:color|colour)[\s:]*([^\s,;]+)', caseSensitive: false);
      var colorMatch = colorRegex.firstMatch(details);
      if (colorMatch != null) {
        result['vehicle_info']['color'] = colorMatch.group(1)!;
      }

      RegExp plateRegex = RegExp(r'[A-Z]{1,2}\s?\d{1,4}\s?[A-Z]{1,3}');
      var plateMatch = plateRegex.firstMatch(details);
      if (plateMatch != null) {
        result['vehicle_info']['license_plate'] = plateMatch.group(0)!;
      }
    }
  }

  Widget _buildGeminiAnalysisSection(Map<String, dynamic> alert) {
    Map<String, dynamic> geminiAnalysis = parseGeminiAnalysis(alert['details']);

    if (!geminiAnalysis['has_gemini_analysis']) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.psychology_outlined,
                size: 32,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "No Gemini AI Analysis Available",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: geminiAnalysis['is_match']
              ? [const Color(0xFF28a745).withOpacity(0.05), Colors.white]
              : [const Color(0xFFe63946).withOpacity(0.05), Colors.white],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: geminiAnalysis['is_match']
              ? const Color(0xFF28a745).withOpacity(0.3)
              : const Color(0xFFe63946).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: Color(0xFF7209b7),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "GEMINI AI ANALYSIS",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7209b7),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: geminiAnalysis['is_match']
                      ? const Color(0xFF28a745).withOpacity(0.1)
                      : const Color(0xFFe63946).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: geminiAnalysis['is_match']
                        ? const Color(0xFF28a745).withOpacity(0.3)
                        : const Color(0xFFe63946).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  geminiAnalysis['is_match'] ? "MATCH FOUND" : "NO MATCH",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: geminiAnalysis['is_match']
                        ? const Color(0xFF28a745)
                        : const Color(0xFFe63946),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Verdict Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    geminiAnalysis['is_match'] ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "AI Verdict",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        geminiAnalysis['gemini_result'].isNotEmpty
                            ? geminiAnalysis['gemini_result'].toUpperCase()
                            : geminiAnalysis['is_match'] ? "VEHICLE DETECTED" : "NO MATCH FOUND",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1a1a2e),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Confidence Bar
          if (geminiAnalysis['gemini_confidence'] > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "AI Confidence",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      "${geminiAnalysis['gemini_confidence'].toStringAsFixed(1)}%",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: geminiAnalysis['gemini_confidence'] > 80
                            ? const Color(0xFF28a745)
                            : geminiAnalysis['gemini_confidence'] > 60
                            ? const Color(0xFFf8961e)
                            : const Color(0xFFe63946),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      height: 8,
                      width: MediaQuery.of(context).size.width * 0.6 * (geminiAnalysis['gemini_confidence'] / 100),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: geminiAnalysis['gemini_confidence'] > 80
                              ? [const Color(0xFF28a745), const Color(0xFF34d399)]
                              : geminiAnalysis['gemini_confidence'] > 60
                              ? [const Color(0xFFf8961e), const Color(0xFFf9c74f)]
                              : [const Color(0xFFe63946), const Color(0xFFf45050)],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),

          // Vehicle Info Grid
          if (geminiAnalysis['vehicle_info'].isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "VEHICLE DETAILS DETECTED",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (geminiAnalysis['vehicle_info']['make'] != null)
                      _buildInfoChip(
                        icon: Icons.directions_car_rounded,
                        label: geminiAnalysis['vehicle_info']['make'],
                        color: const Color(0xFF4361ee),
                      ),
                    if (geminiAnalysis['vehicle_info']['model'] != null)
                      _buildInfoChip(
                        icon: Icons.model_training,
                        label: geminiAnalysis['vehicle_info']['model'],
                        color: const Color(0xFF7209b7),
                      ),
                    if (geminiAnalysis['vehicle_info']['color'] != null)
                      _buildInfoChip(
                        icon: Icons.color_lens_rounded,
                        label: geminiAnalysis['vehicle_info']['color'],
                        color: const Color(0xFFf8961e),
                      ),
                    if (geminiAnalysis['vehicle_info']['license_plate'] != null)
                      _buildInfoChip(
                        icon: Icons.confirmation_number_rounded,
                        label: geminiAnalysis['vehicle_info']['license_plate'],
                        color: const Color(0xFF4cc9f0),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),

          // AI Reasoning
          if (geminiAnalysis['gemini_reason'].isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI REASONING",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blueGrey.shade200),
                  ),
                  child: Text(
                    geminiAnalysis['gemini_reason'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF495057),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedImageSection(Map<String, dynamic> alert) {
    String? imageUrl = alert['detected_image'];

    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(
              Icons.photo_camera_back_rounded,
              size: 40,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              "No detection image available",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4361ee).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.photo_camera_rounded,
                color: Color(0xFF4361ee),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Detected Vehicle",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a1a2e),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        GestureDetector(
          onTap: () => _showFullScreenImage(imageUrl),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF4361ee).withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.shade100,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                            color: const Color(0xFF4361ee),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade100,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_rounded,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Failed to load image",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.zoom_out_map_rounded,
                        color: Color(0xFF4361ee),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            "Tap image to view full screen",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection(Map<String, dynamic> alert) {
    double lat = double.tryParse(alert['latitude']) ?? 0.0;
    double lng = double.tryParse(alert['longitude']) ?? 0.0;
    bool hasValidLocation = lat != 0.0 && lng != 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: hasValidLocation
                    ? const Color(0xFFe63946).withOpacity(0.1)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: hasValidLocation ? const Color(0xFFe63946) : Colors.grey,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Detection Location",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: hasValidLocation ? const Color(0xFF1a1a2e) : Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (!hasValidLocation)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange.shade800,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Location data not available",
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Latitude",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lat.toStringAsFixed(6),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'RobotoMono',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Longitude",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lng.toStringAsFixed(6),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'RobotoMono',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _launchMap(lat, lng, alert['stolen_vehicle_id']),
                      icon: const Icon(Icons.map_rounded, size: 18),
                      label: const Text("OPEN IN MAPS"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFe63946),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(
                            text: '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}'
                        ));
                        Fluttertoast.showToast(
                          msg: "Coordinates copied",
                          backgroundColor: const Color(0xFF28a745),
                          textColor: Colors.white,
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, color: Color(0xFF4361ee)),
                      tooltip: "Copy coordinates",
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _launchMap(double lat, double lng, String vehicleId) async {
    try {
      String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        await Clipboard.setData(ClipboardData(
            text: 'Latitude: $lat\nLongitude: $lng\nVehicle ID: $vehicleId'
        ));
        Fluttertoast.showToast(
          msg: "Coordinates copied to clipboard",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not launch maps: $e");
    }
  }

  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.black87,
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              color: const Color(0xFFe63946),
                              size: 60,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Failed to load image",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDateTime(String dateTime) {
    try {
      final dt = DateTime.parse(dateTime);
      return '${dt.day}/${dt.month}/${dt.year} at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "AI Alerts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF7209b7),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                showOnlyGemini ? Icons.psychology_rounded : Icons.psychology_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  showOnlyGemini = !showOnlyGemini;
                  filteredAlerts = filterAlerts(allAlerts);
                  _setupItemAnimations();
                  _listController.forward(from: 0);
                });
                Fluttertoast.showToast(
                  msg: showOnlyGemini
                      ? "Showing Gemini AI analysis only"
                      : "Showing all alerts",
                );
              },
              tooltip: showOnlyGemini ? "Show all alerts" : "Show Gemini only",
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7209b7)),
              backgroundColor: const Color(0xFF7209b7).withOpacity(0.1),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              "Loading AI analysis...",
              style: TextStyle(
                color: Color(0xFF495057),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : filteredAlerts.isEmpty
          ? Center(
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
              child: Icon(
                showOnlyGemini ? Icons.psychology_rounded : Icons.notifications_off_rounded,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              showOnlyGemini
                  ? "No Gemini AI Analysis Found"
                  : "No Alerts Available",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF495057),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              showOnlyGemini
                  ? "Alerts with AI analysis will appear here"
                  : "New alerts will appear here when detected",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          // Stats Banner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7209b7).withOpacity(0.1),
                  const Color(0xFFb5179e).withOpacity(0.05),
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF7209b7).withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.psychology_rounded,
                            size: 16,
                            color: const Color(0xFF7209b7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${filteredAlerts.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7209b7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      showOnlyGemini
                          ? "AI Analyses"
                          : "Total Alerts",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF495057),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: showOnlyGemini
                        ? const Color(0xFF7209b7).withOpacity(0.1)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: showOnlyGemini
                          ? const Color(0xFF7209b7).withOpacity(0.3)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    showOnlyGemini ? "Gemini Only" : "All Alerts",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: showOnlyGemini
                          ? const Color(0xFF7209b7)
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Alerts List
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchAlerts,
              color: const Color(0xFF7209b7),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredAlerts.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> alert = filteredAlerts[index];
                  Map<String, dynamic> geminiAnalysis = parseGeminiAnalysis(alert['details']);
                  bool isDetected = geminiAnalysis['is_match'];

                  return FadeTransition(
                    opacity: _itemAnimations[index],
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
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
                                colors: isDetected
                                    ? [
                                  const Color(0xFF28a745).withOpacity(0.1),
                                  Colors.transparent,
                                ]
                                    : [
                                  const Color(0xFFe63946).withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isDetected
                                        ? const Color(0xFF28a745).withOpacity(0.1)
                                        : const Color(0xFFe63946).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    isDetected
                                        ? Icons.check_circle_rounded
                                        : Icons.warning_amber_rounded,
                                    color: isDetected
                                        ? const Color(0xFF28a745)
                                        : const Color(0xFFe63946),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Alert #${alert['id']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1a1a2e),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDateTime(alert['detected_at']),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isDetected
                                        ? const Color(0xFF28a745).withOpacity(0.1)
                                        : const Color(0xFFe63946).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    isDetected ? "DETECTED" : "WARNING",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: isDetected
                                          ? const Color(0xFF28a745)
                                          : const Color(0xFFe63946),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Vehicle ID
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4361ee).withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF4361ee).withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4361ee).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.directions_car_rounded,
                                          color: Color(0xFF4361ee),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Stolen Vehicle ID",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            alert['stolen_vehicle_id'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF1a1a2e),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Detected Image
                                _buildDetectedImageSection(alert),

                                const SizedBox(height: 20),

                                // Location
                                _buildLocationSection(alert),

                                const SizedBox(height: 20),

                                // Gemini Analysis
                                _buildGeminiAnalysisSection(alert),

                                const SizedBox(height: 20),

                                // Action Button
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          double lat = double.tryParse(alert['latitude']) ?? 0.0;
                                          double lng = double.tryParse(alert['longitude']) ?? 0.0;
                                          if (lat != 0.0 && lng != 0.0) {
                                            _launchMap(lat, lng, alert['stolen_vehicle_id']);
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "No valid location data",
                                              backgroundColor: const Color(0xFFe63946),
                                              textColor: Colors.white,
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.map_rounded, size: 18),
                                        label: const Text("VIEW ON MAP"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF4361ee),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchAlerts();
          _listController.forward(from: 0);
        },
        backgroundColor: const Color(0xFF7209b7),
        child: const Icon(Icons.refresh_rounded, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

int min(int a, int b) => a < b ? a : b;