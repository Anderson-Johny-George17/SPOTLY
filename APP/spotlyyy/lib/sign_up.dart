// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: UserSignup(title: 'User Registration'),
//     );
//   }
// }
//
// class UserSignup extends StatefulWidget {
//   const UserSignup({super.key, required this.title});
//   final String title;
//
//   @override
//   State<UserSignup> createState() => _UserSignupState();
// }
//
// class _UserSignupState extends State<UserSignup> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _placeController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _vehicleController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   File? _selectedImage;
//   bool _hidePassword = true;
//
//   // IMAGE PICKER
//   Future<void> _chooseImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         _selectedImage = File(picked.path);
//       });
//     } else {
//       Fluttertoast.showToast(msg: "No image selected");
//     }
//   }
//
//   // SEND DATA
//   Future<void> _sendData() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     final url = sh.getString('url');
//
//     if (url == null) {
//       Fluttertoast.showToast(msg: "Server URL not set");
//       return;
//     }
//
//     try {
//       final request =
//       http.MultipartRequest('POST', Uri.parse('$url/reg_customer/'));
//
//       request.fields['name'] = _nameController.text;
//       request.fields['age'] = _ageController.text;
//       request.fields['email'] = _emailController.text;
//       request.fields['place'] = _placeController.text;
//       request.fields['phn_number'] = _phoneController.text;
//       request.fields['vechicle'] = _vehicleController.text;
//       request.fields['password'] = _passwordController.text;
//
//       if (_selectedImage != null) {
//         request.files.add(
//           await http.MultipartFile.fromPath(
//             'photo',
//             _selectedImage!.path,
//           ),
//         );
//       }
//
//       final response = await request.send();
//       final respStr = await response.stream.bytesToString();
//       final data = jsonDecode(respStr);
//
//       if (response.statusCode == 200 && data['status'] == 'ok') {
//         Fluttertoast.showToast(msg: "Registration successful");
//         _formKey.currentState!.reset();
//         setState(() => _selectedImage = null);
//       } else {
//         Fluttertoast.showToast(msg: "Registration failed");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         title: Text(widget.title),
//         centerTitle: true,
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             // IMAGE
//             Center(
//               child: _selectedImage != null
//                   ? Image.file(_selectedImage!, height: 150)
//                   : const Text("No Image Selected"),
//             ),
//
//             const SizedBox(height: 10),
//
//             ElevatedButton(
//               onPressed: _chooseImage,
//               child: const Text("Choose Image"),
//             ),
//
//             const SizedBox(height: 20),
//
//             // NAME
//             _buildTextField(
//               controller: _nameController,
//               label: "Enter Your Name",
//               validatorMsg: "Name required",
//             ),
//
//             // EMAIL
//             _buildTextField(
//               controller: _emailController,
//               label: "Enter Your Email",
//               keyboard: TextInputType.emailAddress,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return "Email required";
//                 }
//                 if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
//                   return "Invalid email";
//                 }
//                 return null;
//               },
//             ),
//
//             // PASSWORD
//             _buildTextField(
//               controller: _passwordController,
//               label: "Enter Your Password",
//               keyboard: TextInputType.visiblePassword,
//               obscureText: _hidePassword,
//               suffixIcon: IconButton(
//                 icon: Icon(
//                     _hidePassword ? Icons.visibility_off : Icons.visibility),
//                 onPressed: () {
//                   setState(() {
//                     _hidePassword = !_hidePassword;
//                   });
//                 },
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return "Password required";
//                 }
//                 if (value.length < 6) {
//                   return "Minimum 6 characters";
//                 }
//                 return null;
//               },
//             ),
//
//             // PHONE
//             _buildTextField(
//               controller: _phoneController,
//               label: "Enter Your Phone Number",
//               keyboard: TextInputType.phone,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(10),
//               ],
//               validator: (value) {
//                 if (value == null || value.length != 10) {
//                   return "Enter valid 10-digit number";
//                 }
//                 return null;
//               },
//             ),
//
//             // PLACE
//             _buildTextField(
//               controller: _placeController,
//               label: "Enter Your Place",
//               validatorMsg: "Place required",
//             ),
//
//             // AGE
//             _buildTextField(
//               controller: _ageController,
//               label: "Enter Your Age",
//               keyboard: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//               ],
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return "Age required";
//                 }
//                 final age = int.tryParse(value);
//                 if (age == null || age < 1 || age > 120) {
//                   return "Enter valid age";
//                 }
//                 return null;
//               },
//             ),
//
//             // VEHICLE
//             _buildTextField(
//               controller: _vehicleController,
//               label: "Enter Vehicle Number",
//               validatorMsg: "Vehicle number required",
//             ),
//
//             const SizedBox(height: 25),
//
//             ElevatedButton(
//               onPressed: _sendData,
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//               child: const Text("Submit"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // COMMON TEXT FIELD
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     TextInputType keyboard = TextInputType.text,
//     List<TextInputFormatter>? inputFormatters,
//     String? validatorMsg,
//     String? Function(String?)? validator,
//     bool obscureText = false,
//     Widget? suffixIcon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboard,
//         obscureText: obscureText,
//         inputFormatters: inputFormatters,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//           suffixIcon: suffixIcon,
//         ),
//         validator: validator ??
//                 (value) {
//               if (value == null || value.trim().isEmpty) {
//                 return validatorMsg;
//               }
//               return null;
//             },
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserSignup extends StatefulWidget {
  const UserSignup({super.key, required this.title});
  final String title;

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  File? _selectedImage;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _isLoading = false;

  // IMAGE PICKER
  Future<void> _chooseImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    } else {
      Fluttertoast.showToast(msg: "No image selected");
    }
  }

  // VALIDATION METHODS
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 3 || value.trim().length > 50) {
      return 'Name must be between 3 and 50 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    final email = value.trim();
    if (email.contains(' ')) {
      return "Email cannot contain spaces";
    }
    if (!RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$').hasMatch(email)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 4) {
      return "Password must be at least 4 characters";
    }

    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasDigits = value.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase) {
      return "Include at least one uppercase letter";
    }
    if (!hasDigits) {
      return "Include at least one number";
    }
    if (!hasSpecialCharacters) {
      return "Include at least one special character";
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }
    if (value != _passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  // SEND DATA
  Future<void> _sendData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    SharedPreferences sh = await SharedPreferences.getInstance();
    final url = sh.getString('url');

    if (url == null) {
      Fluttertoast.showToast(msg: "Server URL not set");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final request = http.MultipartRequest('POST', Uri.parse('$url/reg_customer/'));

      request.fields['name'] = _nameController.text;
      request.fields['age'] = _ageController.text;
      request.fields['email'] = _emailController.text;
      request.fields['place'] = _placeController.text;
      request.fields['phn_number'] = _phoneController.text;
      request.fields['vechicle'] = _vehicleController.text;
      request.fields['password'] = _passwordController.text;

      if (_selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            _selectedImage!.path,
          ),
        );
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        Fluttertoast.showToast(
          msg: "Registration successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        _formKey.currentState!.reset();
        setState(() => _selectedImage = null);
      } else {
        Fluttertoast.showToast(
          msg: "Registration failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'SPOTLY',
                      style: TextStyle(
                        fontSize: 32,
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
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Join Our Community',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Register to help recover stolen vehicles',
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

              // Registration Form
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 25,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF212529),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Fill in your details to get started',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6c757d),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Profile Picture Section
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFf8f9ff),
                                borderRadius: BorderRadius.circular(60),
                                border: Border.all(
                                  color: const Color(0xFF4361ee),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: _selectedImage != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(58),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : Icon(
                                Icons.person,
                                size: 50,
                                color: const Color(0xFF4361ee)
                                    .withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton.icon(
                              onPressed: _chooseImage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFf0f7ff),
                                foregroundColor: const Color(0xFF4361ee),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: const Color(0xFF4361ee),
                                    width: 1.5,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                size: 18,
                              ),
                              label: Text(
                                _selectedImage != null
                                    ? "Change Photo"
                                    : "Upload Profile Photo",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),

                      // Name Field with validation
                      _buildTextFieldSection(
                        label: 'FULL NAME',
                        controller: _nameController,
                        icon: Icons.person_outline,
                        validator: _validateName,
                      ),
                      const SizedBox(height: 20),

                      // Email Field with validation
                      _buildTextFieldSection(
                        label: 'EMAIL ADDRESS',
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 20),

                      // Password Field with validation
                      _buildTextFieldSection(
                        label: 'PASSWORD',
                        controller: _passwordController,
                        icon: Icons.lock_outline,
                        obscureText: _hidePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFFadb5bd),
                          ),
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password Field with validation
                      _buildTextFieldSection(
                        label: 'CONFIRM PASSWORD',
                        controller: _confirmPasswordController,
                        icon: Icons.lock_outline,
                        obscureText: _hideConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hideConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFFadb5bd),
                          ),
                          onPressed: () {
                            setState(() {
                              _hideConfirmPassword = !_hideConfirmPassword;
                            });
                          },
                        ),
                        validator: _validateConfirmPassword,
                      ),
                      const SizedBox(height: 20),

                      // Phone Field
                      _buildTextFieldSection(
                        label: 'PHONE NUMBER',
                        controller: _phoneController,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Phone number is required";
                          }
                          if (value.length != 10) {
                            return "Enter valid 10-digit number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Place Field
                      _buildTextFieldSection(
                        label: 'CITY/PLACE',
                        controller: _placeController,
                        icon: Icons.location_on_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your city/place';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Age Field
                      _buildTextFieldSection(
                        label: 'AGE',
                        controller: _ageController,
                        icon: Icons.calendar_today_outlined,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Age is required";
                          }
                          final age = int.tryParse(value);
                          if (age == null || age < 1 || age > 120) {
                            return "Please enter a valid age";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Vehicle Field
                      _buildTextFieldSection(
                        label: 'VEHICLE NUMBER',
                        controller: _vehicleController,
                        icon: Icons.directions_car_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your vehicle number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 35),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendData,
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
                              : const Text(
                            'CREATE ACCOUNT',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Login Prompt
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Sign In",
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
                      const SizedBox(height: 20),

                      // Info Box
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
                              Icons.info_outline_rounded,
                              color: const Color(0xFF4361ee),
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Your information is secure and will only be used for vehicle recovery purposes',
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
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom + 30,
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

  Widget _buildTextFieldSection({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
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
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF212529),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Enter ${label.toLowerCase()}',
              hintStyle: const TextStyle(
                color: Color(0xFFadb5bd),
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF4361ee),
                size: 22,
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: Colors.white,
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}