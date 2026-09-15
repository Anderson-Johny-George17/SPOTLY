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
// // //       home: const change_password_page(title: 'Flutter Demo Home Page'),
// // //     );
// // //   }
// // // }
// // //
// // // class change_password_page extends StatefulWidget {
// // //   const change_password_page({super.key, required this.title});
// // //
// // //   final String title;
// // //
// // //   @override
// // //   State<change_password_page> createState() => _change_password_pageState();
// // // }
// // //
// // // class _change_password_pageState extends State<change_password_page> {
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
// //     home: change_password_page(title: 'Login'),
// //   ));
// // }
// //
// // class change_password_page extends StatefulWidget {
// //   const change_password_page({super.key, required this.title});
// //   final String title;
// //
// //   @override
// //   State<change_password_page> createState() => _change_password_pageState();
// // }
// //
// // class _change_password_pageState extends State<change_password_page> {
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
// // import 'package:spotly/edit_user_profile.dart';
// import 'package:spotly/login.dart';
// import 'sign_up.dart';
// import 'home_page.dart';
//
// class change_password_page extends StatefulWidget {
//   const change_password_page({super.key, required this.title});
//   final String title;
//
//   @override
//   State<change_password_page> createState() => _change_password_pageState();
// }
//
// class _change_password_pageState extends State<change_password_page> {
//   final TextEditingController _currentpasswordController = TextEditingController();
//   final TextEditingController _newpasswordController = TextEditingController();
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
//                 'Smart Billing',
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
//                   const Text("Current Password"),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _currentpasswordController,
//                     decoration: _inputDecoration("Current Password"),
//                   ),
//
//                   const SizedBox(height: 20),
//                   const Text("New Password"),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _newpasswordController,
//                     obscureText: true,
//                     decoration: _inputDecoration("New Password"),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _login,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                       ),
//                       child: const Text("change password",
//                           style: TextStyle(color: Colors.white)),
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Don't have an account? "),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     UserSignup(title: '',)),
//                           );
//                         },
//                         child: const Text(
//                           "Register",
//                           style: TextStyle(
//                               color: Colors.orange,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       )
//                     ],
//                   ),
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
//
//   void _login() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url') ?? "http://your-ip:8000";
//     String lid = sh.getString('lid') ?? "";
//
//     final response = await http.post(
//       Uri.parse('$url/user_changepassword/'),
//       body: {
//         'current_password': _currentpasswordController.text,
//         'new_password': _newpasswordController.text,
//         'lid': lid,
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['status'] == 'ok') {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>  MyLoginPage(title: '',)));
//       } else {
//         Fluttertoast.showToast(msg: "Invalid login");
//       }
//     } else {
//       Fluttertoast.showToast(msg: "Server error");
//     }
//   }
// }
//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'sign_up.dart';

class change_password_page extends StatefulWidget {
  const change_password_page({super.key, required this.title});
  final String title;

  @override
  State<change_password_page> createState() => _change_password_pageState();
}

class _change_password_pageState extends State<change_password_page> {
  final TextEditingController _currentpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header Section
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF4361ee).withOpacity(0.95),
                      const Color(0xFF3a0ca3),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Update your account password securely',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Form Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 40,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Password Field
                      const Text(
                        'Current Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212529),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                        child: TextFormField(
                          controller: _currentpasswordController,
                          obscureText: true,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF212529),
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter current password',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            suffixIcon: Icon(
                              Icons.lock_outline,
                              color: Color(0xFF4361ee),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter current password';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 25),

                      // New Password Field
                      const Text(
                        'New Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212529),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                        child: TextFormField(
                          controller: _newpasswordController,
                          obscureText: true,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF212529),
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter new password',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            suffixIcon: Icon(
                              Icons.lock_reset_outlined,
                              color: Color(0xFF4361ee),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter new password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Password Requirements
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFf8f9ff),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF4361ee).withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Password Requirements:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF212529),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildRequirement('At least 6 characters long'),
                            _buildRequirement('Use a mix of letters and numbers'),
                            _buildRequirement('Avoid common passwords'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Change Password Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _changePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4361ee),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: const Color(0xFF4361ee).withOpacity(0.3),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            'Change Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Security Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF4361ee).withOpacity(0.05),
                              const Color(0xFF3a0ca3).withOpacity(0.02),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF4361ee).withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.security_outlined,
                              color: const Color(0xFF4361ee),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your password will be updated securely using encryption.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
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
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: const Color(0xFF4361ee),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? "";
      String lid = sh.getString('lid') ?? "";

      if (url.isEmpty) {
        Fluttertoast.showToast(msg: "Server URL not configured");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        final response = await http.post(
          Uri.parse('$url/user_changepassword/'),
          body: {
            'current_password': _currentpasswordController.text,
            'new_password': _newpasswordController.text,
            'lid': lid,
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 'ok') {
            Fluttertoast.showToast(
              msg: "Password changed successfully!",
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );

            // Clear form
            _currentpasswordController.clear();
            _newpasswordController.clear();

            // Navigate to login page after delay
            await Future.delayed(const Duration(milliseconds: 1500));

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MyLoginPage(title: ''),
              ),
                  (route) => false,
            );
          } else {
            Fluttertoast.showToast(
              msg: data['error'] ?? "Invalid current password",
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
          msg: "Network error: ${e.toString()}",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}