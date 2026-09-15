// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(const ViewProfile());
// }
//
// class ViewProfile extends StatelessWidget {
//   const ViewProfile({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF14b8a6),
//         ),
//         useMaterial3: true,
//       ),
//       home: const ViewProfilePage(title: 'My Profile'),
//     );
//   }
// }
//
// class ViewProfilePage extends StatefulWidget {
//   const ViewProfilePage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<ViewProfilePage> createState() => _ViewProfilePageState();
// }
//
// class _ViewProfilePageState extends State<ViewProfilePage> {
//   bool _isLoading = true;
//
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController placeController = TextEditingController();
//   final TextEditingController vehicleController = TextEditingController();
//
//   _ViewProfilePageState() {
//     _fetchProfile();
//   }
//
//   // ---------------- FETCH PROFILE ----------------
//   void _fetchProfile() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url') ?? '';
//       String lid = sh.getString('lid') ?? '';
//
//       final response = await http.post(
//         Uri.parse('$url/job_seeker_profile/'),
//         body: {'cid': lid},
//       );
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data['status'] == 'ok') {
//           setState(() {
//             nameController.text = data['name'] ?? '';
//             ageController.text = data['age'] ?? '';
//             emailController.text = data['email'] ?? '';
//             phoneController.text = data['phnone_number'] ?? '';
//             placeController.text = data['place'] ?? '';
//             vehicleController.text = data['vechicle'] ?? '';
//             _isLoading = false;
//           });
//         } else {
//           _isLoading = false;
//           Fluttertoast.showToast(msg: 'Profile not found');
//         }
//       } else {
//         _isLoading = false;
//         Fluttertoast.showToast(msg: 'Network error');
//       }
//     } catch (e) {
//       _isLoading = false;
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
//   // ---------------- UPDATE PROFILE ----------------
//   void _updateProfile() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url') ?? '';
//       String lid = sh.getString('lid') ?? '';
//
//       final response = await http.post(
//         Uri.parse('$url/update_job_seeker_profile/'),
//         body: {
//           'cid': lid,
//           'name': nameController.text,
//           'age': ageController.text,
//           'email': emailController.text,
//           'phnone_number': phoneController.text,
//           'place': placeController.text,
//           'vechicle': vehicleController.text,
//         },
//       );
//
//       var data = jsonDecode(response.body);
//       if (data['status'] == 'ok') {
//         Fluttertoast.showToast(msg: "Profile Updated Successfully");
//       } else {
//         Fluttertoast.showToast(msg: "Update Failed");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0FDFA),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF14b8a6),
//         title: Text(widget.title),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _buildEditTile(Icons.person, "Name", nameController),
//             _buildEditTile(Icons.cake, "Age", ageController),
//             _buildEditTile(Icons.email, "Email", emailController),
//             _buildEditTile(Icons.phone, "Phone Number", phoneController),
//             _buildEditTile(Icons.location_on, "Place", placeController),
//             _buildEditTile(Icons.directions_car, "Vehicle Number", vehicleController),
//
//             const SizedBox(height: 30),
//
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _updateProfile,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF14b8a6),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 child: const Text(
//                   "Update Profile",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ---------------- EDIT FIELD UI ----------------
//   Widget _buildEditTile(
//       IconData icon, String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon),
//           labelText: label,
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _isEditing = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _fetchProfile();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
    _slideController.forward();
    _cardController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _cardController.dispose();
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    phoneController.dispose();
    placeController.dispose();
    vehicleController.dispose();
    super.dispose();
  }

  // ---------------- FETCH PROFILE ----------------
  void _fetchProfile() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';

      final response = await http.post(
        Uri.parse('$url/job_seeker_profile/'),
        body: {'cid': lid},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            nameController.text = data['name'] ?? '';
            ageController.text = data['age'] ?? '';
            emailController.text = data['email'] ?? '';
            phoneController.text = data['phnone_number'] ?? '';
            placeController.text = data['place'] ?? '';
            vehicleController.text = data['vechicle'] ?? '';
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
          Fluttertoast.showToast(msg: 'Profile not found');
        }
      } else {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: 'Network error');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // ---------------- UPDATE PROFILE ----------------
  void _updateProfile() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';

      final response = await http.post(
        Uri.parse('$url/update_job_seeker_profile/'),
        body: {
          'cid': lid,
          'name': nameController.text,
          'age': ageController.text,
          'email': emailController.text,
          'phnone_number': phoneController.text,
          'place': placeController.text,
          'vechicle': vehicleController.text,
        },
      );

      var data = jsonDecode(response.body);
      if (data['status'] == 'ok') {
        Fluttertoast.showToast(
          msg: "Profile Updated Successfully",
          backgroundColor: const Color(0xFF28a745),
          textColor: Colors.white,
        );
        setState(() => _isEditing = false);
      } else {
        Fluttertoast.showToast(
          msg: "Update Failed",
          backgroundColor: const Color(0xFFe63946),
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: const Color(0xFFe63946),
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f7fb),
      body: _isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4361ee)),
              backgroundColor: const Color(0xFF4361ee).withOpacity(0.1),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading Profile...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ===================== HEADER SECTION =====================
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF4361ee),
                          Color(0xFF3a0ca3),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4361ee).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
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
                        children: [
                          // Top Navigation Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Back Button
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
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

                              // Edit/View Toggle Button
                              GestureDetector(
                                onTap: () {
                                  setState(() => _isEditing = !_isEditing);
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
                                  child: Icon(
                                    _isEditing
                                        ? Icons.visibility_outlined
                                        : Icons.edit_outlined,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // Profile Avatar
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Color(0xFFE8F0FE),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                size: 60,
                                color: Color(0xFF4361ee),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // User Name
                          Center(
                            child: Text(
                              nameController.text.isNotEmpty
                                  ? nameController.text
                                  : 'Your Name',
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),

                          // User Email
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                emailController.text.isNotEmpty
                                    ? emailController.text
                                    : 'user@example.com',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ===================== PROFILE DETAILS SECTION =====================
              FadeTransition(
                opacity: _cardAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Edit Mode Indicator
                      if (_isEditing)
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFf8961e).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFf8961e).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFf8961e).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.edit_note_rounded,
                                  color: Color(0xFFf8961e),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Edit Mode Enabled - Tap fields to update your information',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF495057),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (_isEditing) const SizedBox(height: 20),

                      // Personal Information Card
                      _buildProfileCard(
                        icon: Icons.person_outline_rounded,
                        title: 'Personal Information',
                        gradientColors: const [
                          Color(0xFF4361ee),
                          Color(0xFF3a0ca3),
                        ],
                        children: [
                          _buildInfoField(
                            label: 'Full Name',
                            value: nameController,
                            icon: Icons.badge_outlined,
                            isEditable: _isEditing,
                          ),
                          _buildInfoField(
                            label: 'Age',
                            value: ageController,
                            icon: Icons.cake_outlined,
                            isEditable: _isEditing,
                          ),
                          _buildInfoField(
                            label: 'Place',
                            value: placeController,
                            icon: Icons.location_on_outlined,
                            isEditable: _isEditing,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Contact Information Card
                      _buildProfileCard(
                        icon: Icons.contact_phone_outlined,
                        title: 'Contact Information',
                        gradientColors: const [
                          Color(0xFF4cc9f0),
                          Color(0xFF4895ef),
                        ],
                        children: [
                          _buildInfoField(
                            label: 'Email Address',
                            value: emailController,
                            icon: Icons.email_outlined,
                            isEditable: _isEditing,
                          ),
                          _buildInfoField(
                            label: 'Phone Number',
                            value: phoneController,
                            icon: Icons.phone_android_outlined,
                            isEditable: _isEditing,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Vehicle Information Card
                      _buildProfileCard(
                        icon: Icons.directions_car_outlined,
                        title: 'Vehicle Information',
                        gradientColors: const [
                          Color(0xFF7209b7),
                          Color(0xFFb5179e),
                        ],
                        children: [
                          _buildInfoField(
                            label: 'Vehicle Number',
                            value: vehicleController,
                            icon: Icons.confirmation_number_outlined,
                            isEditable: _isEditing,
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Update Button (only in edit mode)
                      if (_isEditing)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4361ee),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: const Color(0xFF4361ee).withOpacity(0.3),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save_outlined, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // View Mode Message
                      if (!_isEditing)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4361ee).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.info_outline_rounded,
                                  color: Color(0xFF4361ee),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Expanded(
                                child: Text(
                                  'Tap the edit icon to update your profile information',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF495057),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 30),
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

  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required List<Color> gradientColors,
    required List<Widget> children,
  }) {
    return Container(
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
        children: [
          // Card Header with Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Card Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController value,
    required IconData icon,
    required bool isEditable,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isEditable
                    ? const Color(0xFF4361ee).withOpacity(0.5)
                    : const Color(0xFFE9ECEF),
                width: isEditable ? 2 : 1,
              ),
              color: isEditable ? Colors.white : const Color(0xFFF8F9FA),
            ),
            child: TextFormField(
              controller: value,
              enabled: isEditable,
              style: TextStyle(
                fontSize: 15,
                color: isEditable ? const Color(0xFF212529) : Colors.grey[600],
              ),
              decoration: InputDecoration(
                hintText: isEditable ? 'Enter $label' : 'Not provided',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isEditable
                        ? const Color(0xFF4361ee).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isEditable
                        ? const Color(0xFF4361ee)
                        : Colors.grey[400],
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}