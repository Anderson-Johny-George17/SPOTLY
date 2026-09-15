// // // import 'dart:convert';
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:fluttertoast/fluttertoast.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:http/http.dart' as http;
// // //
// // // import 'home.dart';
// // //
// // // void main() {
// // //   runApp(const MyApp());
// // // }
// // //
// // // class MyApp extends StatelessWidget {
// // //   const MyApp({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       title: 'Flutter Demo',
// // //       theme: ThemeData(
// // //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// // //         useMaterial3: true,
// // //       ),
// // //       home: const feedback(title: 'Flutter Demo Home Page'),
// // //     );
// // //   }
// // // }
// // //
// // // class feedback extends StatefulWidget {
// // //   const feedback({super.key, required this.title});
// // //
// // //   final String title;
// // //
// // //   @override
// // //   State<feedback> createState() => _feedbackState();
// // // }
// // //
// // // class _feedbackState extends State<feedback> {
// // //   // ✅ Create a TextEditingController
// // //   final TextEditingController _usernametextController = TextEditingController();
// // //   final TextEditingController _passwordtextController = TextEditingController();
// // //
// // //
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
// // //         title: Text(widget.title),
// // //       ),
// // //       body: Center(
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(16.0),
// // //           child: Column(
// // //             mainAxisAlignment: MainAxisAlignment.center,
// // //             children: <Widget>[
// // //               // ✅ TextField with controller
// // //               TextField(
// // //                 controller: _usernametextController,
// // //                 decoration: const InputDecoration(
// // //                   labelText: 'Enter Username or Email',
// // //                   border: OutlineInputBorder(),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 20),
// // //               TextField(
// // //                 controller: _passwordtextController,
// // //                 decoration: const InputDecoration(
// // //                   labelText: 'Enter Your Password',
// // //                   border: OutlineInputBorder(),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 20),
// // //               // ✅ ElevatedButton
// // //               ElevatedButton(
// // //                 onPressed: () {
// // //                 _send_data();
// // //                 },
// // //                 child: const Text('Login'),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //   void _send_data() async{
// // //
// // //     String uname=_usernametextController.text;
// // //     String password=_passwordtextController.text;
// // //
// // //     SharedPreferences sh = await SharedPreferences.getInstance();
// // //     String url = sh.getString('url').toString();
// // //
// // //     final urls = Uri.parse('$url/flutter_logins/');
// // //     try {
// // //       final response = await http.post(urls, body: {
// // //         'Username':uname,
// // //         'Password':password,
// // //       });
// // //       if (response.statusCode == 200) {
// // //         String status = jsonDecode(response.body)['status'];
// // //         if (status=='ok') {
// // //           String lid=jsonDecode(response.body)['lid'];
// // //           sh.setString("lid", lid);
// // //
// // //           Navigator.push(context, MaterialPageRoute(
// // //             builder: (context) => HomePage(),));
// // //         }else {
// // //           Fluttertoast.showToast(msg: 'Not Found');
// // //         }
// // //       }
// // //       else {
// // //         Fluttertoast.showToast(msg: 'Network Error');
// // //       }
// // //     }
// // //     catch (e){
// // //       Fluttertoast.showToast(msg: e.toString());
// // //     }
// // //   }
// // //
// // // }
// //
// //
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:spotly/Home_page.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:spotly/edit_user_profile.dart';
// //
// //
// // void main() {
// //   runApp(const MaterialApp(
// //     debugShowCheckedModeBanner: false,
// //     home: feedback(title: 'Login'),
// //   ));
// // }
// //
// // class feedback extends StatefulWidget {
// //   const feedback({super.key, required this.title});
// //   final String title;
// //
// //   @override
// //   State<feedback> createState() => _feedbackState();
// // }
// //
// // class _feedbackState extends State<feedback> {
// //   final TextEditingController _usernametextController = TextEditingController();
// //   final TextEditingController _passwordtextController = TextEditingController();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //         onWillPop: () async {
// //           Navigator.pushReplacement(
// //             context,
// //             MaterialPageRoute(builder: (context) => const MyHomepage(title: '',)),
// //           );
// //           return false; // Prevent default pop
// //         },
// //         child:Scaffold(
// //           backgroundColor: const Color(0xFFEFF3FF), // Light blue background
// //           body: SingleChildScrollView(
// //             child: Column(
// //               children: [
// //                 // Top Shape and Logo
// //                 Stack(
// //                   children: [
// //                     Container(
// //                       height: 180,
// //                       decoration: const BoxDecoration(
// //                         color: Color(0xFF0047AB),
// //                         borderRadius:
// //                         BorderRadius.only(bottomLeft: Radius.circular(80)),
// //                       ),
// //                     ),
// //                     const Positioned(
// //                       top: 100,
// //                       left: 20,
// //                       child: Text(
// //                         'Smart Billing',
// //                         style: TextStyle(
// //                             fontSize: 32,
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.bold),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //
// //                 const SizedBox(height: 40),
// //
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Text("Email id",
// //                           style:
// //                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// //                       const SizedBox(height: 10),
// //                       TextField(
// //                         controller: _usernametextController,
// //                         decoration: InputDecoration(
// //                           hintText: "Enter your email",
// //                           filled: true,
// //                           fillColor: Colors.white,
// //                           border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(8),
// //                               borderSide: BorderSide.none),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 20),
// //                       const Text("Password",
// //                           style:
// //                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// //                       const SizedBox(height: 10),
// //                       TextField(
// //                         controller: _passwordtextController,
// //                         obscureText: true,
// //                         decoration: InputDecoration(
// //                           hintText: "••••••••",
// //                           filled: true,
// //                           fillColor: Colors.white,
// //                           border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(8),
// //                               borderSide: BorderSide.none),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 30),
// //
// //                       // Login Button
// //                       SizedBox(
// //                         width: double.infinity,
// //                         child: ElevatedButton(
// //                           onPressed: _send_data,
// //                           style: ElevatedButton.styleFrom(
// //                             padding: const EdgeInsets.symmetric(vertical: 16),
// //                             backgroundColor: Colors.orange,
// //                             shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(12)),
// //                           ),
// //                           child: const Text("Login",
// //                               style: TextStyle(color: Colors.white, fontSize: 16)),
// //                         ),
// //                       ),
// //
// //                       const SizedBox(height: 10),
// //                       Align(
// //                         alignment: Alignment.centerRight,
// //                         child: TextButton(
// //                           onPressed: () {},
// //                           child: const Text("Forgot Password ?",
// //                               style: TextStyle(color: Colors.black87)),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 10),
// //
// //                       // Divider
// //                       Row(children: const <Widget>[
// //                         Expanded(child: Divider()),
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(horizontal: 8),
// //                           child: Text("or"),
// //                         ),
// //                         Expanded(child: Divider()),
// //                       ]),
// //                       const SizedBox(height: 20),
// //
// //                       // Facebook Button
// //                       // SizedBox(
// //                       //   width: double.infinity,
// //                       //   child: ElevatedButton.icon(
// //                       //     onPressed: () {},
// //                       //     icon: const Icon(Icons.facebook, color: Colors.white),
// //                       //     label: const Text("Log in with Facebook"),
// //                       //     style: ElevatedButton.styleFrom(
// //                       //         backgroundColor: const Color(0xFF1877F2),
// //                       //         padding: const EdgeInsets.symmetric(vertical: 14),
// //                       //         shape: RoundedRectangleBorder(
// //                       //             borderRadius: BorderRadius.circular(8))),
// //                       //   ),
// //                       // ),
// //                       const SizedBox(height: 30),
// //
// //                       // Register Prompt
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           const Text("Don't have an account? ",
// //                               style: TextStyle(color: Colors.black87)),
// //                       ElevatedButton(onPressed: (){
// //                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>MyAddUserPage(title: '',)));
// //                       }, child:     const Text("Register",
// //                           style: TextStyle(
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.orange))),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 )
// //               ],
// //             ),
// //           ),
// //         ));
// //   }
// //
// //   void _send_data() async {
// //     String uname = _usernametextController.text;
// //     String password = _passwordtextController.text;
// //
// //     SharedPreferences sh = await SharedPreferences.getInstance();
// //     String url = sh.getString('url').toString();
// //
// //     final urls = Uri.parse('$url/Applogin/');
// //     try {
// //       final response = await http.post(urls, body: {
// //         'username': uname,
// //         'password': password,
// //       });
// //       if (response.statusCode == 200) {
// //         String status = jsonDecode(response.body)['status'];
// //         if (status == 'ok') {
// //           String lid = jsonDecode(response.body)['lid'];
// //           sh.setString("lid", lid);
// //
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (context) => MyHomepage(title: '',)),
// //           );
// //         } else {
// //           Fluttertoast.showToast(msg: 'Not Found');
// //         }
// //       } else {
// //         Fluttertoast.showToast(msg: 'Network Error');
// //       }
// //     } catch (e) {
// //       Fluttertoast.showToast(msg: e.toString());
// //     }
// //   }
// // }
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'sign_up.dart';
// import 'home_page.dart';
//
// class sent_complaint extends StatefulWidget {
//   const sent_complaint({super.key, required this.title});
//   final String title;
//
//   @override
//   State<sent_complaint> createState() => _sent_complaintState();
// }
//
// class _sent_complaintState extends State<sent_complaint> {
//   // final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _feedbackController = TextEditingController();
//
//   void _feedback() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url') ?? "http://your-ip:8000";
//
//     final response = await http.post(
//       Uri.parse('$url/sent_complaint/'),
//       body: {
//         'lid':sh.getString('lid').toString(),
//         // 'username': _usernameController.text,
//         'feedback': _feedbackController.text,
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['status'] == 'ok') {
//         sh.setString("lid", data['lid']);
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const MyHomepage(title: '',)));
//       }
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEFF3FF),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 180,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF0047AB),
//                 borderRadius:
//                 BorderRadius.only(bottomLeft: Radius.circular(80)),
//               ),
//               alignment: Alignment.centerLeft,
//               padding: const EdgeInsets.all(20),
//               child: const Text(
//                 'Feedback',
//                 style: TextStyle(
//                     fontSize: 32,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//
//             const SizedBox(height: 40),
//
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   const Text("complaint"),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _feedbackController,
//                     obscureText: false,
//                     decoration: _inputDecoration("complaint"),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed:_feedback,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                       ),
//                       child: const Text("sent",
//                           style: TextStyle(color: Colors.white)),
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   InputDecoration _inputDecoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       filled: true,
//       fillColor: Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }
// }




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Home_page.dart';

class sent_complaint extends StatefulWidget {
  const sent_complaint({super.key, required this.title});
  final String title;

  @override
  State<sent_complaint> createState() => _sent_complaintState();
}

class _sent_complaintState extends State<sent_complaint> {
  final TextEditingController _feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Rating variable (1-5 stars)
  int _rating = 0;
  bool _isHovering = false;
  int _hoverRating = 0;

  // Selected emotion for feedback type
  String? _selectedEmotion;
  final List<Map<String, dynamic>> _emotions = [
    {'icon': Icons.sentiment_satisfied_rounded, 'label': 'Happy', 'color': Colors.green},
    {'icon': Icons.sentiment_neutral_rounded, 'label': 'Neutral', 'color': Colors.orange},
    {'icon': Icons.sentiment_dissatisfied_rounded, 'label': 'Unhappy', 'color': Colors.red},
    {'icon': Icons.lightbulb_rounded, 'label': 'Suggestion', 'color': Colors.purple},
    {'icon': Icons.bug_report_rounded, 'label': 'Bug', 'color': Colors.brown},
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  // Get rating description
  String _getRatingDescription() {
    switch (_rating) {
      case 1:
        return 'Very Poor';
      case 2:
        return 'Poor';
      case 3:
        return 'Average';
      case 4:
        return 'Good';
      case 5:
        return 'Excellent';
      default:
        return 'Tap to rate';
    }
  }

  // Get rating color
  Color _getRatingColor() {
    switch (_rating) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Modern Header
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4158D0),
                      Color(0xFFC850C0),
                      Color(0xFFFFCC70),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4158D0).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -40,
                      left: -40,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Back button
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Text(
                            'Rate Your Experience',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Subtitle
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: const Text(
                              'Your feedback helps us improve',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'How would you rate us?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF212529),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Star Rating
                            MouseRegion(
                              onEnter: (_) => setState(() => _isHovering = true),
                              onExit: (_) => setState(() {
                                _isHovering = false;
                                _hoverRating = 0;
                              }),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _rating = index + 1;
                                      });
                                    },
                                    child: MouseRegion(
                                      onEnter: (_) {
                                        setState(() {
                                          _hoverRating = index + 1;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Icon(
                                          index < (_isHovering ? _hoverRating : _rating)
                                              ? Icons.star_rounded
                                              : Icons.star_border_rounded,
                                          color: index < (_isHovering ? _hoverRating : _rating)
                                              ? Colors.amber
                                              : Colors.grey[400],
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // Rating Description
                            if (_rating > 0)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _getRatingColor().withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: _getRatingColor().withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      color: _getRatingColor(),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _getRatingDescription(),
                                      style: TextStyle(
                                        color: _getRatingColor(),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Emotion selector
                      const Text(
                        'How are you feeling?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF212529),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Select the type of feedback',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Horizontal emotion selector
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _emotions.length,
                          itemBuilder: (context, index) {
                            final emotion = _emotions[index];
                            final isSelected = _selectedEmotion == emotion['label'];

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedEmotion = emotion['label'];
                                });
                              },
                              child: Container(
                                width: 80,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? emotion['color'].withOpacity(0.2)
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? emotion['color']
                                        : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      emotion['icon'],
                                      color: isSelected
                                          ? emotion['color']
                                          : Colors.grey[600],
                                      size: 30,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      emotion['label'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isSelected
                                            ? emotion['color']
                                            : Colors.grey[700],
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Input label with counter
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Your Feedback',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF212529),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _feedbackController.text.length < 10
                                  ? Colors.red.shade50
                                  : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _feedbackController.text.length < 10
                                    ? Colors.red.shade200
                                    : Colors.green.shade200,
                              ),
                            ),
                            child: Text(
                              '${_feedbackController.text.length}/500',
                              style: TextStyle(
                                fontSize: 12,
                                color: _feedbackController.text.length < 10
                                    ? Colors.red.shade700
                                    : Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Text field
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4158D0).withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 0,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _feedbackController,
                          maxLines: 8,
                          maxLength: 500,
                          minLines: 6,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF212529),
                          ),
                          onChanged: (value) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Share your experience, suggestions, or concerns...',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(20),
                            counterText: '',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: const Color(0xFF4158D0).withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your feedback';
                            }
                            if (value.length < 10) {
                              return 'Please provide more details (at least 10 characters)';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Tips section
                      const Text(
                        '✨ Tips for better feedback',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF212529),
                        ),
                      ),
                      const SizedBox(height: 15),

                      _buildTip(
                        icon: Icons.info_outline_rounded,
                        title: 'Be Specific',
                        description: 'Include exact details about your experience',
                        color: const Color(0xFF4158D0),
                      ),
                      _buildTip(
                        icon: Icons.rate_review_rounded,
                        title: 'Explain Your Rating',
                        description: 'Tell us why you gave this rating',
                        color: const Color(0xFFC850C0),
                      ),
                      _buildTip(
                        icon: Icons.lightbulb_rounded,
                        title: 'Suggest Improvements',
                        description: 'What would make your experience better?',
                        color: const Color(0xFFFFCC70),
                      ),

                      const SizedBox(height: 30),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendFeedback,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4158D0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                              : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send_rounded, size: 22),
                              SizedBox(width: 12),
                              Text(
                                'Submit Feedback',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Privacy card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4158D0).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF4158D0).withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4158D0).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.privacy_tip_rounded,
                                color: Color(0xFF4158D0),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '100% Confidential',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF212529),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Your feedback and rating are anonymous and help us improve',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTip({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendFeedback() async {
    // Check if rating is selected
    if (_rating == 0) {
      Fluttertoast.showToast(
        msg: "Please rate your experience",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? "";
      String lid = sh.getString('lid') ?? "";

      if (url.isEmpty) {
        Fluttertoast.showToast(
          msg: "Server URL not configured",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        final response = await http.post(
          Uri.parse('$url/sent_complaint/'),
          body: {
            'lid': lid,
            'feedback': _feedbackController.text,
            'rating': _rating.toString(),
            'feedback_type': _selectedEmotion ?? 'General',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 'ok') {
            // Show thank you message with rating
            _showThankYouDialog();
          } else {
            Fluttertoast.showToast(
              msg: data['error'] ?? "Failed to submit feedback",
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "Server error: ${response.statusCode}",
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Network error",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                _getRatingColor().withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Thank you animation
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Thank You!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: _getRatingColor(),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You rated us $_rating star${_rating > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212529),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Icon(
                    index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 30,
                  );
                }),
              ),
              const SizedBox(height: 15),
              const Text(
                'Your feedback helps us improve',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    // Clear form
                    _feedbackController.clear();
                    setState(() {
                      _rating = 0;
                      _selectedEmotion = null;
                    });

                    // Navigate to home
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomepage(title: ''),
                      ),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4158D0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}