// import 'package:flutter/material.dart';
// import 'package:spotly/Change_password.dart';
// import 'package:spotly/view_stolen_.dart';
// import 'package:spotly/view_user_profile.dart';
// import 'package:spotly/complaint.dart';
// import 'package:spotly/view_stolen_.dart';
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: MyHomepage(title: '',),
//   ));
// }
//
// class MyHomepage extends StatefulWidget {
//   const MyHomepage({super.key, required String title});
//
//   @override
//   State<MyHomepage> createState() => _MyHomepageState();
// }
//
// class _MyHomepageState extends State<MyHomepage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // drawer: const Drawer(
//       //   child: DrawerContent(),
//       // ),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black87),
//         // actions: const [
//         //   Icon(Icons.notifications_none),
//         //   SizedBox(width: 16),
//         // ],
//       ),
//       backgroundColor: const Color(0xFFF5F6FA),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 CircleAvatar(
//                   backgroundImage: AssetImage('assets/user.jpg'),
//                   radius: 25,
//                 ),
//                 SizedBox(width: 12),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Hi Admin,',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       'What do you want to do today?',
//                       style: TextStyle(color: Colors.black54),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(''),
//                       SizedBox(height: 6),
//                       Text(
//                         '',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(''),
//                       SizedBox(height: 6),
//                       Text(
//                         '',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 25),
//             const Text(
//               'Quick Actions',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 15),
//             Expanded(
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 15,
//                 mainAxisSpacing: 15,
//                 children: [
//                   ActionCard(
//                     title: 'Add User',
//                     color: Colors.pinkAccent,
//                     icon: Icons.verified_user,
//                     onTap: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(builder: (context) => MyAddUserPage(title: '')),
//                       // );
//                     },
//                   ),
//                   ActionCard(
//                     title: 'View User',
//                     color: Colors.deepPurple,
//                     icon: Icons.table_view_outlined,
//                     onTap: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(builder: (context) => UserViewHouse(title: '')),
//                       // );
//                     },
//                   ),
//                   ActionCard(
//                     title: 'change Password',
//                     color: Colors.deepPurple,
//                     icon: Icons.table_view_outlined,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => change_password_page(title: '',)),
//                       );
//                     },
//                   ),
//                   ActionCard(
//                     title: 'send complaint',
//                     color: Colors.deepPurple,
//                     icon: Icons.table_view_outlined,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => sent_complaint(title: '',)),
//                       );
//                     },
//                   ),
//                   ActionCard(
//                     title: 'My Profile',
//                     color: Colors.deepPurple,
//                     icon: Icons.person,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ViewProfile()),
//                       );
//                     },
//                   ),
//                   ActionCard(
//                     title: 'view stolen vehicle',
//                     color: Colors.deepPurple,
//                     icon: Icons.person,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ViewHouseApp()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ActionCard extends StatelessWidget {
//   final String title;
//   final Color color;
//   final IconData icon;
//   final VoidCallback? onTap; // ADD this
//
//   const ActionCard({
//     super.key,
//     required this.title,
//     required this.color,
//     required this.icon,
//     this.onTap, // ADD this
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap, // USE this
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               backgroundColor: color,
//               child: Icon(icon, color: Colors.white),
//             ),
//             const SizedBox(height: 10),
//             Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // class DrawerContent extends StatefulWidget {
// //   const DrawerContent({super.key});
// //
// //   @override
// //   State<DrawerContent> createState() => _DrawerContentState();
// // }
//
// // class _DrawerContentState extends State<DrawerContent> {
// //   void showDrawerMessage(String message) {
// //     Navigator.pop(context); // Close drawer
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(message)),
// //     );
// //   }
// //
// //   // @override
// //   // Widget build(BuildContext context) {
// //   //   return ListView(
// //   //     padding: EdgeInsets.zero,
// //   //     children: [
// //   //       const DrawerHeader(
// //   //         decoration: BoxDecoration(color: Colors.blue),
// //   //         child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
// //   //       ),
// //   //       ListTile(
// //   //         leading: const Icon(Icons.dashboard),
// //   //         title: const Text('Dashboard'),
// //   //         onTap: () => showDrawerMessage('Dashboard selected'),
// //   //       ),
// //   //       ListTile(
// //   //         leading: const Icon(Icons.receipt),
// //   //         title: const Text('Add User'),
// //   //         onTap: () => showDrawerMessage('Bills selected'),
// //   //       ),
// //   //       ListTile(
// //   //         leading: const Icon(Icons.send),
// //   //         title: const Text('Transfers'),
// //   //         onTap: () => showDrawerMessage('Transfers selected'),
// //   //       ),
// //   //       ListTile(
// //   //         leading: const Icon(Icons.settings),
// //   //         title: const Text('Settings'),
// //   //         onTap: () => showDrawerMessage('Settings selected'),
// //   //       ),
// //   //     ],
// //   //   );
// //   // }
// // }


//2nd
//
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:spotlyyy/report_stolen%20vehicle.dart';
// import 'package:spotlyyy/view_police_station.dart';
// import 'package:spotlyyy/view_stolen_.dart';
// import 'package:spotlyyy/view_user_profile.dart';
// import 'package:http/http.dart' as http;
//
// import 'Change_password.dart';
// import 'alert.dart';
// import 'complaint.dart';
//
// class MyHomepage extends StatefulWidget {
//   const MyHomepage({super.key, required String title});
//
//   @override
//   State<MyHomepage> createState() => _MyHomepageState();
// }
//
// class _MyHomepageState extends State<MyHomepage> {
//   double _latitude = 0.0;
//   double _longitude = 0.0;
//   bool _locationLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
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
//       setState(() {
//         _latitude = position.latitude;
//         _longitude = position.longitude;
//         _locationLoading = false;
//       });
//
//       await sendlocation();
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Location error");
//     }
//   }
//
//   Future<void> sendlocation() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url') ?? '';
//       String lid = sh.getString('lid') ?? '';
//
//       final response = await http.post(
//         Uri.parse("$url/setlocation/"),
//         body: {
//           'lati': _latitude.toString(),
//           'longi': _longitude.toString(),
//           'lid': lid,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         debugPrint("Location updated successfully");
//       }
//     } catch (e) {
//       debugPrint("Send location error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ===================== HEADER =====================
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     const Color(0xFF4361ee),
//                     const Color(0xFF3a0ca3),
//                   ],
//                 ),
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(40),
//                   bottomRight: Radius.circular(40),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blue.withOpacity(0.3),
//                     blurRadius: 25,
//                     spreadRadius: 2,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(25, 30, 25, 25),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Top Row with Profile Icon and Dashboard Title
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Profile Icon (Clickable)
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewProfile(),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             width: 55,
//                             height: 55,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(15),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 5),
//                                 ),
//                               ],
//                             ),
//                             child: const Icon(
//                               Icons.person_rounded,
//                               size: 30,
//                               color: Color(0xFF4361ee),
//                             ),
//                           ),
//                         ),
//
//                         // Dashboard Title
//                         const Expanded(
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 15),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Spotly Dashboard',
//                                   style: TextStyle(
//                                     fontSize: 22,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w800,
//                                     letterSpacing: 0.5,
//                                   ),
//                                 ),
//                                 SizedBox(height: 4),
//                                 Text(
//                                   'Vehicle Security Platform',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.white70,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//
//                         // Notification Icon
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           padding: const EdgeInsets.all(8),
//                           child: const Icon(
//                             Icons.notifications_outlined,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 25),
//
//                     // Location Card
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.3),
//                           width: 1,
//                         ),
//                       ),
//                       padding: const EdgeInsets.all(16),
//                       child: Row(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             padding: const EdgeInsets.all(10),
//                             child: const Icon(
//                               Icons.location_on,
//                               color: Color(0xFF4361ee),
//                               size: 22,
//                             ),
//                           ),
//                           const SizedBox(width: 15),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Current Location',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.white70,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 _locationLoading
//                                     ? Row(
//                                   children: [
//                                     const SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Text(
//                                       "Fetching location...",
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.white.withOpacity(0.9),
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                                     : Text(
//                                   "${_latitude.toStringAsFixed(6)}, ${_longitude.toStringAsFixed(6)}",
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w600,
//                                     fontFamily: 'monospace',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (!_locationLoading)
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               padding: const EdgeInsets.all(6),
//                               child: const Icon(
//                                 Icons.check_circle,
//                                 color: Colors.white,
//                                 size: 18,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // ===================== MAIN CONTENT =====================
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Quick Actions',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w800,
//                         color: Color(0xFF1a1a2e),
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     const Text(
//                       'Access all features with one tap',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 25),
//
//                     // Grid View (Profile card is NOT here anymore)
//                     Expanded(
//                       child: GridView.count(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 18,
//                         mainAxisSpacing: 18,
//                         childAspectRatio: 0.85,
//                         children: [
//                           _buildActionCard(
//                             title: 'Change Password',
//                             icon: Icons.lock_reset_rounded,
//                             color: const Color(0xFF4CCD99),
//                             iconColor: Colors.white,
//                             subtitle: 'Update security',
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       change_password_page(title: ''),
//                                 ),
//                               );
//                             },
//                           ),
//
//                           _buildActionCard(
//                             title: 'Feedback',
//                             icon: Icons.feedback_rounded,
//                             color: const Color(0xFFFFB84C),
//                             iconColor: Colors.white,
//                             subtitle: 'Share thoughts',
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => sent_complaint(title: ''),
//                                 ),
//                               );
//                             },
//                           ),
//
//                           _buildActionCard(
//                             title: 'Report Vehicle',
//                             icon: Icons.report_problem_rounded,
//                             color: const Color(0xFFF45050),
//                             iconColor: Colors.white,
//                             subtitle: 'Missing vehicle',
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const ReportVehicle(),
//                                 ),
//                               );
//                             },
//                           ),
//
//                           _buildActionCard(
//                             title: 'View Stolen',
//                             icon: Icons.directions_car_rounded,
//                             color: const Color(0xFF4361ee),
//                             iconColor: Colors.white,
//                             subtitle: 'Check reports',
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ViewHouseApp(),
//                                 ),
//                               );
//                             },
//                           ),
//
//                           // Optional: Add a placeholder card for future feature
//                           _buildActionCard(
//                             title: 'view police stations',
//                             icon: Icons.history_rounded,
//                             color: const Color(0xFF6D67E4),
//                             iconColor: Colors.white,
//                             subtitle: 'Sent your Complaints',
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => PoliceComplaintPage(),
//                                 ),
//                               );
//                             },
//                           ),
//
//                           _buildActionCard(
//                             title: 'view Alerts',
//                             icon: Icons.settings_rounded,
//                             color: const Color(0xFF888888),
//                             iconColor: Colors.white,
//                             subtitle: 'App preferences',
//                             onTap: () {
//                               Navigator.push(context,
//                                   MaterialPageRoute(builder: (context)=> ViewAlertsPage(),
//                               ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//
//       // ===================== BOTTOM NAVIGATION =====================
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(25),
//             topRight: Radius.circular(25),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 20,
//               spreadRadius: 1,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildNavItem(Icons.home_rounded, 'Home', true),
//             _buildNavItem(Icons.history_rounded, 'History', false),
//             _buildNavItem(Icons.qr_code_scanner_rounded, 'Scan', false),
//             _buildNavItem(Icons.help_outline_rounded, 'Help', false),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionCard({
//     required String title,
//     required IconData icon,
//     required Color color,
//     required Color iconColor,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 15,
//               spreadRadius: 1,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(20),
//             onTap: onTap,
//             splashColor: color.withOpacity(0.2),
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: color,
//                       borderRadius: BorderRadius.circular(16),
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           color,
//                           color.withOpacity(0.8),
//                         ],
//                       ),
//                     ),
//                     padding: const EdgeInsets.all(15),
//                     child: Icon(
//                       icon,
//                       color: iconColor,
//                       size: 28,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   Text(
//                     title,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF1a1a2e),
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     subtitle,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem(IconData icon, String label, bool isActive) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           icon,
//           color: isActive ? const Color(0xFF4361ee) : Colors.grey,
//           size: 24,
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: isActive ? const Color(0xFF4361ee) : Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotlyyy/report_stolen%20vehicle.dart';
import 'package:spotlyyy/view_police_station.dart';
import 'package:spotlyyy/view_stolen_.dart';
import 'package:spotlyyy/view_user_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:ui'; // For ImageFilter

import 'Change_password.dart';
import 'alert.dart';
import 'complaint.dart';

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key, required String title});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> with TickerProviderStateMixin {
  double _latitude = 0.0;
  double _longitude = 0.0;
  bool _locationLoading = true;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _greeting = "";
  String _userName = "User";

  // For staggered animations
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _cardAnimations;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getUserName();
    _setupAnimations();
    _setGreeting();
  }

  void _setupAnimations() {
    // Main fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );

    // Slide animation for header
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Card animations (staggered) - now for 6 cards
    _cardControllers = List.generate(6, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    });

    _cardAnimations = _cardControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutBack,
        ),
      );
    }).toList();

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Stagger card animations
    for (int i = 0; i < _cardControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 200 + (i * 100)), () {
        if (mounted) {
          _cardControllers[i].forward();
        }
      });
    }
  }

  void _setGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      _greeting = "Good Morning";
    } else if (hour < 17) {
      _greeting = "Good Afternoon";
    } else {
      _greeting = "Good Evening";
    }
  }

  Future<void> _getUserName() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    setState(() {
      _userName = sh.getString('username') ?? 'User';
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Fluttertoast.showToast(msg: "Enable location services");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Fluttertoast.showToast(msg: "Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: "Enable location permission from settings");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationLoading = false;
      });

      await sendlocation();
    } catch (e) {
      Fluttertoast.showToast(msg: "Location error");
    }
  }

  Future<void> sendlocation() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';

      final response = await http.post(
        Uri.parse("$url/setlocation/"),
        body: {
          'lati': _latitude.toString(),
          'longi': _longitude.toString(),
          'lid': lid,
        },
      );

      if (response.statusCode == 200) {
        debugPrint("Location updated successfully");
      }
    } catch (e) {
      debugPrint("Send location error: $e");
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F7FA),
              Color(0xFFE9ECF0),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ===================== HEADER =====================
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF4361ee),
                          Color(0xFF3a0ca3),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 20, 25, 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row with Profile Icon and Dashboard Title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Profile Icon (Clickable)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewProfile(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    size: 30,
                                    color: Color(0xFF4361ee),
                                  ),
                                ),
                              ),

                              // Dashboard Title
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Spotly Dashboard',
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Vehicle Security Platform',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Notification Icon
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  // Notification badge (simulating unread)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFe63946),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // Location Card
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF4361ee),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Current Location',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      _locationLoading
                                          ? Row(
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Fetching location...",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white.withOpacity(0.9),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                          : Text(
                                        "${_latitude.toStringAsFixed(6)}, ${_longitude.toStringAsFixed(6)}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!_locationLoading)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ===================== MAIN CONTENT =====================
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quick Actions',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1a1a2e),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Access all features with one tap',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Grid View with Staggered Animations - CORRECT ORDER
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          childAspectRatio: 0.85,
                          children: [
                            // 1. Report Vehicle (Red)
                            _buildAnimatedCard(
                              index: 0,
                              title: 'Report Vehicle',
                              icon: Icons.report_problem_rounded,
                              color: const Color(0xFFF45050),
                              subtitle: 'Report stolen vehicle',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ReportVehicle(),
                                  ),
                                );
                              },
                            ),

                            // 2. View Stolen (Blue)
                            _buildAnimatedCard(
                              index: 1,
                              title: 'View Stolen',
                              icon: Icons.directions_car_rounded,
                              color: const Color(0xFF4361ee),
                              subtitle: 'Check stolen reports',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewHouseApp(),
                                  ),
                                );
                              },
                            ),

                            // 3. View Police Stations (Purple)
                            _buildAnimatedCard(
                              index: 2,
                              title: 'Police Stations',
                              icon: Icons.local_police_rounded,
                              color: const Color(0xFF6D67E4),
                              subtitle: 'View nearby stations',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PoliceComplaintPage(),
                                  ),
                                );
                              },
                            ),

                            // 4. View Alerts (Grey)
                            _buildAnimatedCard(
                              index: 3,
                              title: 'View Alerts',
                              icon: Icons.notifications_active_rounded,
                              color: const Color(0xFF888888),
                              subtitle: 'Check latest alerts',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewAlertsPage(),
                                  ),
                                );
                              },
                            ),

                            // 5. Change Password (Green)
                            _buildAnimatedCard(
                              index: 4,
                              title: 'Change Password',
                              icon: Icons.lock_reset_rounded,
                              color: const Color(0xFF4CCD99),
                              subtitle: 'Update security',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => change_password_page(title: ''),
                                  ),
                                );
                              },
                            ),

                            // 6. Feedback (Orange/Yellow)
                            _buildAnimatedCard(
                              index: 5,
                              title: 'Feedback',
                              icon: Icons.feedback_rounded,
                              color: const Color(0xFFFFB84C),
                              subtitle: 'Share your thoughts',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => sent_complaint(title: ''),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ===================== SIMPLE BOTTOM NAVIGATION =====================
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavItem(Icons.home_rounded, 'Home'),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required int index,
    required String title,
    required IconData icon,
    required Color color,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return FadeTransition(
      opacity: _cardAnimations[index],
      child: ScaleTransition(
        scale: _cardAnimations[index],
        child: _buildActionCard(
          title: title,
          icon: icon,
          color: color,
          subtitle: subtitle,
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            splashColor: color.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color,
                          color.withOpacity(0.8),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1a1a2e),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF4361ee).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF4361ee),
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4361ee),
          ),
        ),
      ],
    );
  }
}