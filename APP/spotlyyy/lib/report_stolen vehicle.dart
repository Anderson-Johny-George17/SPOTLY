// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:geolocator/geolocator.dart';
//
// class ReportVehicle extends StatefulWidget {
//   const ReportVehicle({super.key});
//
//   @override
//   State<ReportVehicle> createState() => _ReportVehicleState();
// }
//
// class _ReportVehicleState extends State<ReportVehicle> {
//   bool _isLoading = false;
//   File? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//
//   double _latitude = 0.0;
//   double _longitude = 0.0;
//   bool _locationLoading = true;
//
//   final List<String> vehicleTypes = [
//     'Car','Motorcycle','Scooter','Bicycle','SUV','Truck','Van','Bus','Other'
//   ];
//
//   final List<String> colorOptions = [
//     'White','Black','Gray','Silver','Blue','Red','Green','Yellow','Other'
//   ];
//
//   String? _selectedVehicleType;
//   String? _selectedColor;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   // ================= LOCATION =================
//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) return;
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) return;
//       }
//
//       if (permission == LocationPermission.deniedForever) return;
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
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Location error");
//     }
//   }
//
//   // ================= IMAGE PICK =================
//   Future<void> _pickImage() async {
//     final XFile? pickedFile =
//     await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
//
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }
//
//   // ================= SUBMIT (MULTIPART) =================
//   Future<void> _submitReport() async {
//     if (_selectedVehicleType == null ||
//         _selectedColor == null ||
//         _imageFile == null) {
//       Fluttertoast.showToast(msg: "All fields required");
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url') ?? '';
//       String lid = sh.getString('lid') ?? '';
//
//       var uri = Uri.parse('$url/report_stolen_vehicle/');
//       var request = http.MultipartRequest('POST', uri);
//
//       // ----------- TEXT FIELDS -----------
//       request.fields['vehicle_type'] = _selectedVehicleType!;
//       request.fields['vehicle_color'] = _selectedColor!;
//       request.fields['latitude'] = _latitude.toString();
//       request.fields['longitude'] = _longitude.toString();
//       request.fields['customer_id'] = lid;
//
//       // ----------- FILE FIELD -----------
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'vehicle_image',        // must match Django field name
//           _imageFile!.path,
//         ),
//       );
//
//       // ----------- SEND -----------
//       var response = await request.send();
//       var responseData = await response.stream.bytesToString();
//
//       if (response.statusCode == 200) {
//         Fluttertoast.showToast(msg: "Vehicle reported successfully");
//         Navigator.pop(context);
//       } else {
//         Fluttertoast.showToast(msg: "Upload failed");
//         debugPrint(responseData);
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: $e");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Report Stolen Vehicle")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//
//             DropdownButtonFormField<String>(
//               hint: const Text("Vehicle Type"),
//               items: vehicleTypes
//                   .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                   .toList(),
//               onChanged: (v) => _selectedVehicleType = v,
//             ),
//
//             const SizedBox(height: 15),
//
//             DropdownButtonFormField<String>(
//               hint: const Text("Vehicle Color"),
//               items: colorOptions
//                   .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                   .toList(),
//               onChanged: (v) => _selectedColor = v,
//             ),
//
//             const SizedBox(height: 15),
//
//             ElevatedButton.icon(
//               onPressed: _pickImage,
//               icon: const Icon(Icons.photo),
//               label: const Text("Upload Vehicle Image"),
//             ),
//
//             if (_imageFile != null)
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Image.file(_imageFile!, height: 150),
//               ),
//
//             const SizedBox(height: 15),
//
//             _locationLoading
//                 ? const CircularProgressIndicator()
//                 : Column(
//               children: [
//                 Text("Latitude: $_latitude"),
//                 Text("Longitude: $_longitude"),
//               ],
//             ),
//
//             const SizedBox(height: 25),
//
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _submitReport,
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text("REPORT VEHICLE"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'dart:ui';

class ReportVehicle extends StatefulWidget {
  const ReportVehicle({super.key});

  @override
  State<ReportVehicle> createState() => _ReportVehicleState();
}

class _ReportVehicleState extends State<ReportVehicle> with TickerProviderStateMixin {
  bool _isLoading = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  double _latitude = 0.0;
  double _longitude = 0.0;
  bool _locationLoading = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final List<String> vehicleTypes = [
    'Car', 'Motorcycle', 'Scooter', 'Bicycle', 'SUV', 'Truck', 'Van', 'Bus', 'Other'
  ];

  final List<String> colorOptions = [
    'White', 'Black', 'Gray', 'Silver', 'Blue', 'Red', 'Green', 'Yellow', 'Orange', 'Brown', 'Other'
  ];

  String? _selectedVehicleType;
  String? _selectedColor;

  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _getCurrentLocation();
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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _registrationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ================= LOCATION =================
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
    } catch (e) {
      Fluttertoast.showToast(msg: "Location error");
      setState(() => _locationLoading = false);
    }
  }

  // ================= IMAGE PICK =================
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Image Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: const Color(0xFF4361ee),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (pickedFile != null) {
                      setState(() => _imageFile = File(pickedFile.path));
                    }
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: const Color(0xFF4cc9f0),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? pickedFile = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (pickedFile != null) {
                      setState(() => _imageFile = File(pickedFile.path));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ================= SUBMIT (MULTIPART) =================
  Future<void> _submitReport() async {
    if (_selectedVehicleType == null ||
        _selectedColor == null ||
        _imageFile == null ||
        _registrationController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all required fields",
        backgroundColor: const Color(0xFFe63946),
        textColor: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';

      var uri = Uri.parse('$url/report_stolen_vehicle/');
      var request = http.MultipartRequest('POST', uri);

      request.fields['vehicle_type'] = _selectedVehicleType!;
      request.fields['vehicle_color'] = _selectedColor!;
      request.fields['latitude'] = _latitude.toString();
      request.fields['longitude'] = _longitude.toString();
      request.fields['customer_id'] = lid;
      request.fields['registration_number'] = _registrationController.text;
      request.fields['description'] = _descriptionController.text;

      request.files.add(
        await http.MultipartFile.fromPath('vehicle_image', _imageFile!.path),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Vehicle reported successfully",
          backgroundColor: const Color(0xFF28a745),
          textColor: Colors.white,
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: "Upload failed",
          backgroundColor: const Color(0xFFe63946),
          textColor: Colors.white,
        );
        debugPrint(responseData);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        backgroundColor: const Color(0xFFe63946),
        textColor: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
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
            const Text(
              'Reporting Vehicle...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      )
          : SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ===================== HEADER =====================
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF45050), Color(0xFFD00000)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 20, 25, 30),
                  child: Column(
                    children: [
                      // Back Button and Title
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
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
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Text(
                              'Report Stolen Vehicle',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Help us find your vehicle by providing accurate information',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===================== FORM =====================
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Image Upload Card
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _imageFile != null
                                    ? const Color(0xFF28a745)
                                    : const Color(0xFFE0E0E0),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: _imageFile != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.check_circle,
                                        color: Color(0xFF28a745),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF45050).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Color(0xFFF45050),
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Tap to upload vehicle image',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF495057),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'JPG, PNG (Max 5MB)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Vehicle Type Dropdown
                        _buildDropdownField(
                          label: 'Vehicle Type',
                          value: _selectedVehicleType,
                          items: vehicleTypes,
                          icon: Icons.directions_car_rounded,
                          color: const Color(0xFF4361ee),
                          onChanged: (v) => setState(() => _selectedVehicleType = v),
                        ),

                        const SizedBox(height: 20),

                        // Registration Number
                        _buildTextField(
                          controller: _registrationController,
                          label: 'Registration Number',
                          hint: 'Enter vehicle registration number',
                          icon: Icons.confirmation_number_rounded,
                          color: const Color(0xFF6D67E4),
                        ),

                        const SizedBox(height: 20),

                        // Vehicle Color
                        _buildDropdownField(
                          label: 'Vehicle Color',
                          value: _selectedColor,
                          items: colorOptions,
                          icon: Icons.color_lens_rounded,
                          color: const Color(0xFFf8961e),
                          onChanged: (v) => setState(() => _selectedColor = v),
                        ),

                        const SizedBox(height: 20),

                        // Description
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Additional Details',
                          hint: 'Enter any additional information...',
                          icon: Icons.description_rounded,
                          color: const Color(0xFF4cc9f0),
                          maxLines: 3,
                        ),

                        const SizedBox(height: 20),

                        // Location Card
                        Container(
                          padding: const EdgeInsets.all(16),
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
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4cc9f0).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: Color(0xFF4cc9f0),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _locationLoading
                                    ? const Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text('Getting location...'),
                                  ],
                                )
                                    : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Current Location',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_latitude.toStringAsFixed(6)}° N, ${_longitude.toStringAsFixed(6)}° E',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!_locationLoading)
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF28a745).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF28a745),
                                    size: 18,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _submitReport,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF45050),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: const Color(0xFFF45050).withOpacity(0.3),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.warning_amber_rounded, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  'REPORT VEHICLE',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Disclaimer
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF45050).withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFF45050).withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: const Color(0xFFF45050),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Please ensure all information is accurate. False reporting may lead to legal consequences.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF495057),
                                  ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
    int maxLines = 1,
  }) {
    return Container(
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
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: Color(0xFF495057), fontWeight: FontWeight.w600),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: color, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Color color,
    required void Function(String?) onChanged,
  }) {
    return Container(
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
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(label),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF495057), fontWeight: FontWeight.w600),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: color, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }
}