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
// // //       home: const MyLoginPage(title: 'Flutter Demo Home Page'),
// // //     );
// // //   }
// // // }
// // //
// // // class MyLoginPage extends StatefulWidget {
// // //   const MyLoginPage({super.key, required this.title});
// // //
// // //   final String title;
// // //
// // //   @override
// // //   State<MyLoginPage> createState() => _MyLoginPageState();
// // // }
// // //
// // // class _MyLoginPageState extends State<MyLoginPage> {
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
// //     home: MyLoginPage(title: 'Login'),
// //   ));
// // }
// //
// // class MyLoginPage extends StatefulWidget {
// //   const MyLoginPage({super.key, required this.title});
// //   final String title;
// //
// //   @override
// //   State<MyLoginPage> createState() => _MyLoginPageState();
// // }
// //
// // class _MyLoginPageState extends State<MyLoginPage> {
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
// import 'sign_up.dart';
// import 'home_page.dart';
//
// class MyLoginPage extends StatefulWidget {
//   const MyLoginPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<MyLoginPage> createState() => _MyLoginPageState();
// }
//
// class _MyLoginPageState extends State<MyLoginPage> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
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
//                   const Text("Email"),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _usernameController,
//                     decoration: _inputDecoration("Enter email"),
//                   ),
//
//                   const SizedBox(height: 20),
//                   const Text("Password"),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration: _inputDecoration("••••••••"),
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
//                       child: const Text("Login",
//                           style: TextStyle(color: Colors.white)),
//                     ),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                        Text("Don't have an account? "),
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
//
//     final response = await http.post(
//       Uri.parse('$url/Applogin/'),
//       body: {
//         'username': _usernameController.text,
//         'password': _passwordController.text,
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
import 'sign_up.dart';
import 'home_page.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});
  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  // Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header Section (EXACTLY YOUR ORIGINAL DESIGN)
              Container(
                height: 280,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Container with subtle animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3a0ca3).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Car icon
                          const Icon(
                            Icons.directions_car_filled,
                            size: 50,
                            color: Color(0xFF4361ee),
                          ),
                          // Camera overlay
                          Positioned(
                            top: 15,
                            right: 15,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF4361ee),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.videocam_rounded,
                                size: 16,
                                color: Color(0xFF4361ee),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // App Name
                    const Text(
                      'SPOTLY',
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Tagline
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Stolen Vehicle Recovery Platform',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Sub-tagline
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Powered by Dash Camera Network',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // Login Form (EXACTLY YOUR ORIGINAL DESIGN with validation added)
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
                      // Welcome Text
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF212529),
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Sign in to access your account',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6c757d),
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Email Field
                      const Text(
                        'EMAIL ADDRESS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4361ee),
                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _usernameController,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF212529),
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: const TextStyle(
                              color: Color(0xFFadb5bd),
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 18,
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Color(0xFF4361ee),
                              size: 22,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: _validateEmail,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Password Field
                      const Text(
                        'PASSWORD',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4361ee),
                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF212529),
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            hintStyle: const TextStyle(
                              color: Color(0xFFadb5bd),
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 18,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF4361ee),
                              size: 22,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFFadb5bd),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: _validatePassword,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            _showForgotPasswordDialog();
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFF4361ee),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () {
                            if (_formKey.currentState!.validate()) {
                              _login();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4361ee),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shadowColor: const Color(0xFF4361ee).withOpacity(0.3),
                          ),
                          child: _isLoading
                              ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'SIGN IN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 35),

                      // Register Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFf8f9ff),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_add_alt_1_outlined,
                              color: Colors.grey[600],
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "New to Spotly? ",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserSignup(title: ''),
                                  ),
                                );
                              },
                              child: const Text(
                                "Register Now",
                                style: TextStyle(
                                  color: Color(0xFF4361ee),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Info box about platform
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFf0f7ff),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF4361ee).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.security_outlined,
                              color: Colors.green[600],
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Your data is protected with end-to-end encryption',
                                style: TextStyle(
                                  color: const Color(0xFF3a0ca3),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Add extra space at bottom for safe area
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom + 20,
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

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Forgot Password?',
            style: TextStyle(
              color: const Color(0xFF4361ee),
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact our support team to reset your password:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(
                  Icons.email_outlined,
                  color: const Color(0xFF4361ee),
                ),
                title: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  'support@spotly.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF212529),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.phone_outlined,
                  color: const Color(0xFF4361ee),
                ),
                title: Text(
                  'Phone',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  '+1-800-SPOTLY',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF212529),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF4361ee),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "http://your-ip:8000";

    try {
      final response = await http.post(
        Uri.parse('$url/Applogin/'),
        body: {
          'username': _usernameController.text.trim(),
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          sh.setString("lid", data['lid']);
          Fluttertoast.showToast(
            msg: "Login successful! Welcome to Spotly",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 14,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomepage(title: ''),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: "Invalid email or password. Please try again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Server error. Please try again later.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Network error. Please check your internet connection.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14,
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