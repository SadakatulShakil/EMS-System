import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../providers/leave_provider.dart';
import '../../../utill/color_resources.dart';
class RegisterWidgetScreen extends StatefulWidget {
  bool backExits;

  RegisterWidgetScreen({Key? key, required this.backExits}) : super(key: key);

  @override
  _RegisterWidgetScreenState createState() => _RegisterWidgetScreenState();
}

class _RegisterWidgetScreenState extends State<RegisterWidgetScreen> {
  String? _selectedBloodGroup;

  List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  List<String> _selectedItems = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  // Variables to store selected values
  String? selectedLeaveType;
  late String selectedReporters;
  List<dynamic> selectedReportingPersons = [];
  String leaveReason = '';
  String leaveFromDate = '';
  String leaveToDate = '';
  String fileName = '';
  int? leaveTypeId;

  void _registerNow() async {}

  // Function to display photo data in a dialog
  void _showPhotoPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload photo from'),
          content: Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (kDebugMode) {
                      print('file Name: ' + image!.name.toString());
                    }
                    setState(() {
                      fileName = image!.name.toString();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/camera.png'),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Camera'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (kDebugMode) {
                      print('file Name: ' + image!.name.toString());
                    }
                    setState(() {
                      fileName = image!.name.toString();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/gallery.png'),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Gallery')
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);
    return leaveProvider.isLoading
        ? Center(
            child: LoadingAnimationWidget.threeRotatingDots(
              color: Colors.green,
              size: 30,
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Complete your Profile,',
                      style: GoogleFonts.mulish(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null; // Return null if the input is valid
                      },
                      decoration: InputDecoration(
                        labelText: 'Your name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter email';
                        }
                        return null; // Return null if the input is valid
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter phone';
                        }
                        return null; // Return null if the input is valid
                      },
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: departmentController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter department';
                        }
                        return null; // Return null if the input is valid
                      },
                      decoration: InputDecoration(
                        labelText: 'Department',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: designationController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter designation';
                        }
                        return null; // Return null if the input is valid
                      },
                      decoration: InputDecoration(
                        labelText: 'Designation',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: addressController,
                      onChanged: (value) {
                        setState(() {
                          leaveReason = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter address';
                        }
                        return null; // Return null if the input is valid
                      },
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text('Select Blood Group'),
                      value: _selectedBloodGroup,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBloodGroup = newValue;
                        });
                      },
                      items: bloodGroups.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _registerNow();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: accentLight, // Set the background color here
                      ),
                      child: Text('Submit', style: GoogleFonts.mulish(color: primaryColor)),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
