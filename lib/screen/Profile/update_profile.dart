import 'dart:io';

import 'package:employe_management_system/utill/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/profile_provider.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  ProfileUpdateScreenState createState() => ProfileUpdateScreenState();
}

class ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _departmentNameFocus = FocusNode();
  final FocusNode _designationFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _departmentNameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  String? selectedBloodType;
  List<String> bloodGroups = ['', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  File? file;
  bool isLoading = false;
  String path ='';
  String? token;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  void _choose() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        path = pickedFile.path;
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  _updateUserAccount() async {
    isLoading = true;
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    String fName = _firstNameController.text.trim();
    String lName = _lastNameController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String address = _addressController.text.trim();

    /// Do update functionality here
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? token = sp.getString("tokenId");
    profileProvider.updateProfile(token??'', fName, lName, phoneNumber, address, file).then((value){
      getProfileData();
    });
    if (kDebugMode) {
      print('Update button clicked');
    }
  }

  Future<void> getProfileData() async {
    final profileProvider =
    Provider.of<ProfileProvider>(context, listen: false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedToken = prefs.getString('tokenId');
    if (savedToken != null) {
      setState(() {
        token = savedToken;
      });
    }

    try {
      await profileProvider.fetchProfile(token: token!).then((value) {
        isLoading = false;
        Navigator.of(context).pop();
      });
    } catch (e) {
      print('Error fetching profile: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profileData = profileProvider.userData;
    _firstNameController.text = profileData!.data.firstName;
    _lastNameController.text = profileData.data.lastName;
    _emailController.text = profileData.data.email;
    _phoneController.text = profileData.data.phone;
    _departmentNameController.text = profileData.data.department;
    _designationController.text = profileData.data.designation;
    _addressController.text = profileData.data.address != null ? profileData.data.address : '';
    return isLoading?Center(child: LoadingAnimationWidget.threeRotatingDots(
      color: Colors.blue,
      size: 30,
    ),):Scaffold(
      key: _scaffoldKey,
      body:Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Image.asset(
              'assets/images/toolbar_background.png',
              fit: BoxFit.fill,
              height: 500,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 35, left: 15),
            child: Row(
              children: [
                CupertinoNavigationBarBackButton(
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  'Settings',
                  style: GoogleFonts.mulish(fontSize: 20, color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 55),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: accent,
                        border: Border.all(color: primaryColor, width: 3),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child:
                                file != null
                                ? Image.file(file!, width: 100, height: 100,fit: BoxFit.cover,)
                                :file == null && profileData.data.photo !=null
                                ?Image.network(profileData.data.photo, width: 100, height: 100,)
                                :Image.network('https://i.pinimg.com/736x/d2/98/4e/d2984ec4b65a8568eab3dc2b640fc58e.jpg', width: 100, height: 100,)
                          ),
                          Positioned(
                            bottom: 0,
                            right: -10,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 14,
                              child: IconButton(
                                onPressed: _choose,
                                padding: const EdgeInsets.all(0),
                                icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      profileData.data.firstName != ''?'${profileData.data.firstName} ${profileData.data.lastName}':'Mr. Haasan Masud',
                      style: GoogleFonts.mulish(color: Colors.white, fontSize: 20.0),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, color: Colors.red, size: 20),
                                  const SizedBox(width: 5),
                                  Text('First Name',style: GoogleFonts.mulish()),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                focusNode: _fNameFocus,
                                onSubmitted: (term) {
                                  _fNameFocus.unfocus();
                                  FocusScope.of(context).requestFocus(_lNameFocus);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter first name',
                                  fillColor: Colors.green[50],
                                  filled: true,
                                  border: InputBorder.none, // Remove underline
                                ),
                                controller: _firstNameController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, color: Colors.red, size: 20),
                                  const SizedBox(width: 5),
                                  Text('Last Name',style: GoogleFonts.mulish()),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                focusNode: _lNameFocus,
                                onSubmitted: (term) {
                                  _lNameFocus.unfocus();
                                  FocusScope.of(context).requestFocus(_phoneFocus);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter last name',
                                  fillColor: Colors.green[50],
                                  filled: true,
                                  border: InputBorder.none, // Remove underline
                                ),
                                controller: _lastNameController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.alternate_email, color: Colors.red, size: 20),
                                  const SizedBox(width: 5),
                                  Text('Email',style: GoogleFonts.mulish()),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                focusNode: _emailFocus,
                                onSubmitted: (term) {
                                  _emailFocus.unfocus();
                                  FocusScope.of(context).requestFocus(_phoneFocus);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter email',
                                  fillColor: Colors.green[50],
                                  filled: true,
                                  enabled: false,
                                  border: InputBorder.none,
                                ),
                                controller: _emailController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.dialpad, color: Colors.red, size: 20),
                                  const SizedBox(width: 5),
                                  Text('Phone No',style: GoogleFonts.mulish()),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                                focusNode: _phoneFocus,
                                onSubmitted: (term) {
                                  _phoneFocus.unfocus();
                                  FocusScope.of(context).requestFocus(_addressFocus);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter phone no',
                                  fillColor: Colors.green[50],
                                  filled: true,
                                    border: InputBorder.none
                                ),
                                controller: _phoneController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_history_outlined, color: Colors.red, size: 20),
                                  const SizedBox(width: 5),
                                  Text('Department',style: GoogleFonts.mulish()),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                focusNode: _departmentNameFocus,
                                onSubmitted: (term) {
                                  _departmentNameFocus.unfocus();
                                  FocusScope.of(context).requestFocus(_designationFocus);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter address',
                                  fillColor: Colors.green[50],
                                  filled: true,
                                    enabled: false,
                                    border: InputBorder.none
                                ),
                                controller: _departmentNameController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_history_outlined, color: Colors.red, size: 20),
                                  const SizedBox(width: 5),
                                  Text('Designation',style: GoogleFonts.mulish()),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                focusNode: _designationFocus,
                                onSubmitted: (term) {
                                  _designationFocus.unfocus();
                                },
                                decoration: InputDecoration(
                                    hintText: 'Enter Designation',
                                    fillColor: Colors.green[50],
                                    filled: true,
                                    enabled: false,
                                    border: InputBorder.none
                                ),
                                controller: _designationController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_history_outlined, color: Colors.red, size: 20),
                                  const SizedBox(width: 5),
                                  Text('Address',style: GoogleFonts.mulish()),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                focusNode: _addressFocus,
                                onSubmitted: (term) {
                                  _addressFocus.unfocus();
                                },
                                decoration: InputDecoration(
                                    hintText: 'Enter address',
                                    fillColor: Colors.green[50],
                                    filled: true,
                                    border: InputBorder.none
                                ),
                                controller: _addressController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () async{
                            _updateUserAccount();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Container(
                              height: 45.0,
                              decoration: BoxDecoration(
                                color: accent,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Center(
                                child: Text(
                                  'Update Now',
                                  style: GoogleFonts.mulish(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
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
      )
    );
  }
}
