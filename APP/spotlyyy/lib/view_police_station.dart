// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class PoliceComplaintPage extends StatefulWidget {
//   const PoliceComplaintPage({super.key});
//
//   @override
//   State<PoliceComplaintPage> createState() => _PoliceComplaintPageState();
// }
//
// class _PoliceComplaintPageState extends State<PoliceComplaintPage> {
//   List<Map<String, dynamic>> policeStations = [];
//   List complaints = [];
//
//   String? selectedPoliceId;
//   TextEditingController complaintController = TextEditingController();
//
//   bool loadingStations = true;
//   bool loadingComplaints = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchPoliceStations();
//     fetchComplaints();
//   }
//
//   // ================= FETCH POLICE STATIONS =================
//   Future<void> fetchPoliceStations() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String baseUrl = sh.getString('url') ?? '';
//
//     final response =
//     await http.get(Uri.parse('$baseUrl/view_police_stations/'));
//
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       if (jsonData['status'] == 'ok') {
//         setState(() {
//           policeStations =
//           List<Map<String, dynamic>>.from(jsonData['data']);
//           loadingStations = false;
//         });
//       }
//     }
//   }
//
//   // ================= FETCH MY COMPLAINTS =================
//   Future<void> fetchComplaints() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String baseUrl = sh.getString('url') ?? '';
//     String lid = sh.getString('lid') ?? '';
//
//     final response = await http.get(
//       Uri.parse('$baseUrl/view_my_complaints/?lid=$lid'),
//     );
//
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       if (jsonData['status'] == 'ok') {
//         setState(() {
//           complaints = jsonData['data'];
//           loadingComplaints = false;
//         });
//       }
//     }
//   }
//
//   // ================= SEND COMPLAINT =================
//   Future<void> sendComplaint() async {
//     if (selectedPoliceId == null) {
//       Fluttertoast.showToast(msg: "Select police station");
//       return;
//     }
//     if (complaintController.text.isEmpty) {
//       Fluttertoast.showToast(msg: "Enter complaint");
//       return;
//     }
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String baseUrl = sh.getString('url') ?? '';
//     String lid = sh.getString('lid') ?? '';
//
//     final response = await http.post(
//       Uri.parse('$baseUrl/send_complaint/'),
//       body: {
//         'police_id': selectedPoliceId!,
//         'complaint': complaintController.text,
//         'lid': lid,
//       },
//     );
//
//     if (response.statusCode == 200) {
//       Fluttertoast.showToast(msg: "Complaint sent successfully");
//       complaintController.clear();
//       fetchComplaints(); // 🔥 refresh list
//     } else {
//       Fluttertoast.showToast(msg: "Failed to send complaint");
//     }
//   }
//
//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Police Complaint")),
//       body: loadingStations
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Select Police Station",
//               style:
//               TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//               items: policeStations.map((p) {
//                 return DropdownMenuItem<String>(
//                   value: p['id'].toString(),
//                   child: Text(
//                       "${p['station_name']} (${p['place']})"),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 selectedPoliceId = value;
//               },
//             ),
//
//             const SizedBox(height: 16),
//
//             const Text(
//               "Complaint",
//               style:
//               TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//
//             TextField(
//               controller: complaintController,
//               maxLines: 3,
//               decoration: const InputDecoration(
//                 hintText: "Enter your complaint here...",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: sendComplaint,
//                 child: const Text("SEND COMPLAINT"),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//             const Divider(),
//             const Text(
//               "My Complaints",
//               style:
//               TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//
//             // ✅ IMPORTANT FIX
//             Expanded(
//               child: loadingComplaints
//                   ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//                   : complaints.isEmpty
//                   ? const Center(
//                 child: Text("No complaints yet"),
//               )
//                   : ListView.builder(
//                 itemCount: complaints.length,
//                 itemBuilder: (context, index) {
//                   final c = complaints[index];
//
//                   return Card(
//                     margin: const EdgeInsets.symmetric(
//                         vertical: 6),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: Column(
//                         crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${c['station']} (${c['place']})",
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 6),
//                           Text("Complaint: ${c['complaint']}"),
//                           const SizedBox(height: 6),
//                           Text(
//                             "Reply: ${c['reply']}",
//                             style: TextStyle(
//                               color: c['reply'] ==
//                                   "No reply yet"
//                                   ? Colors.grey
//                                   : Colors.green,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Row(
//                             mainAxisAlignment:
//                             MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Status: ${c['status']}"),
//                               Text(
//                                 c['date'],
//                                 style: const TextStyle(
//                                     fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class PoliceComplaintPage extends StatefulWidget {
  const PoliceComplaintPage({super.key});

  @override
  State<PoliceComplaintPage> createState() => _PoliceComplaintPageState();
}

class _PoliceComplaintPageState extends State<PoliceComplaintPage> with TickerProviderStateMixin {
  List<Map<String, dynamic>> policeStations = [];
  List complaints = [];

  String? selectedPoliceId;
  TextEditingController complaintController = TextEditingController();

  bool loadingStations = true;
  bool loadingComplaints = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    fetchPoliceStations();
    fetchComplaints();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
    complaintController.dispose();
    super.dispose();
  }

  // ================= FETCH POLICE STATIONS =================
  Future<void> fetchPoliceStations() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String baseUrl = sh.getString('url') ?? '';

      final response = await http.get(Uri.parse('$baseUrl/view_police_stations/'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'ok') {
          setState(() {
            policeStations = List<Map<String, dynamic>>.from(jsonData['data']);
            loadingStations = false;
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to load police stations");
        setState(() => loadingStations = false);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
      setState(() => loadingStations = false);
    }
  }

  // ================= FETCH MY COMPLAINTS =================
  Future<void> fetchComplaints() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String baseUrl = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/view_my_complaints/?lid=$lid'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'ok') {
          setState(() {
            complaints = jsonData['data'];
            loadingComplaints = false;
          });
        }
      } else {
        setState(() => loadingComplaints = false);
      }
    } catch (e) {
      setState(() => loadingComplaints = false);
      Fluttertoast.showToast(msg: "Error fetching complaints");
    }
  }

  // ================= SEND COMPLAINT =================
  Future<void> sendComplaint() async {
    if (selectedPoliceId == null) {
      Fluttertoast.showToast(
        msg: "Please select a police station",
        backgroundColor: const Color(0xFFe63946),
        textColor: Colors.white,
      );
      return;
    }
    if (complaintController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your complaint",
        backgroundColor: const Color(0xFFe63946),
        textColor: Colors.white,
      );
      return;
    }

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String baseUrl = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/send_complaint/'),
        body: {
          'police_id': selectedPoliceId!,
          'complaint': complaintController.text,
          'lid': lid,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: "Complaint sent successfully",
            backgroundColor: const Color(0xFF28a745),
            textColor: Colors.white,
          );
          complaintController.clear();
          selectedPoliceId = null;
          fetchComplaints(); // Refresh list
          setState(() {}); // Reset dropdown
        } else {
          Fluttertoast.showToast(
            msg: jsonData['message'] ?? "Failed to send complaint",
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
        msg: "Error sending complaint",
        backgroundColor: const Color(0xFFe63946),
        textColor: Colors.white,
      );
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Police Complaint',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4361ee),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: loadingStations
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
              "Loading police stations...",
              style: TextStyle(
                color: Color(0xFF495057),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===================== NEW COMPLAINT CARD =====================
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
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
                        // Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF4361ee), Color(0xFF3a0ca3)],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.add_comment_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'New Complaint',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Form Body
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Police Station Dropdown
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Select Police Station',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF495057),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: selectedPoliceId,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        prefixIcon: Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF4361ee).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Icon(
                                            Icons.local_police_rounded,
                                            color: Color(0xFF4361ee),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      hint: const Text('Choose police station'),
                                      items: policeStations.map((p) {
                                        return DropdownMenuItem<String>(
                                          value: p['id'].toString(),
                                          child: Text(
                                            "${p['station_name']} - ${p['place']}",
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedPoliceId = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Complaint Text Field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Your Complaint',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF495057),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: complaintController,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        hintText: "Describe your complaint in detail...",
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.all(16),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Icon(
                                            Icons.description_rounded,
                                            color: const Color(0xFFf8961e),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Send Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: sendComplaint,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4361ee),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.send_rounded, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        "SEND COMPLAINT",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
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
              ),

              const SizedBox(height: 24),

              // ===================== MY COMPLAINTS SECTION =====================
              Container(
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
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF4cc9f0), Color(0xFF4895ef)],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.history_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'My Complaints',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Complaints List
                    loadingComplaints
                        ? const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4cc9f0)),
                        ),
                      ),
                    )
                        : complaints.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.inbox_rounded,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "No complaints yet",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF495057),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Your complaints will appear here",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: complaints.length,
                      itemBuilder: (context, index) {
                        final c = complaints[index];
                        bool hasReply = c['reply'] != null &&
                            c['reply'].toString().isNotEmpty &&
                            c['reply'] != "No reply yet";

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Police Station Header
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4361ee).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.local_police_rounded,
                                        color: Color(0xFF4361ee),
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "${c['station']}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1a1a2e),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: c['status'] == 'resolved'
                                            ? const Color(0xFF28a745).withOpacity(0.1)
                                            : const Color(0xFFf8961e).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        c['status']?.toUpperCase() ?? 'PENDING',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: c['status'] == 'resolved'
                                              ? const Color(0xFF28a745)
                                              : const Color(0xFFf8961e),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Place
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      size: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      c['place'] ?? 'Unknown',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Complaint
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFf8f9fa),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Complaint:',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF495057),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        c['complaint'] ?? 'No description',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF212529),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Reply (if exists)
                                if (hasReply) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF28a745).withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF28a745).withOpacity(0.2),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.reply_rounded,
                                              size: 14,
                                              color: Color(0xFF28a745),
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'Police Reply:',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF28a745),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          c['reply'],
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF212529),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 12),

                                // Date
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      c['date'] ?? 'Unknown date',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
    );
  }
}