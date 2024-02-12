import 'dart:io';
import 'package:employe_management_system/utill/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/auth_session_provider.dart';
import '../../providers/profile_provider.dart';
import '../../utill/stored_images.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  String path ='';
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
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    String fName = _firstNameController.text.trim();
    String lName = _lastNameController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String address = _addressController.text.trim();

    /// Do update functionality here
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? token = sp.getString("tokenId");
    profileProvider.updateProfile(token??'', fName, lName, phoneNumber, address, file);
    if (kDebugMode) {
      print('Update button clicked');
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
    _addressController.text = profileData.data.address;
    return Scaffold(
      key: _scaffoldKey,
      body:Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Image.asset(
              Images.toolbarBackground,
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
                  style: TextStyle(fontSize: 20, color: Colors.white),
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
                            child: file == null
                                ? FadeInImage.assetNetwork(
                              placeholder: Images.user,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              image: Images.user,
                              imageErrorBuilder: (c, o, s) => Image.asset(
                                Images.user,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Image.file(file!, width: 100, height: 100, fit: BoxFit.fill),
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
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
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
                                  Text('First Name'),
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
                                  Text('Last Name'),
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
                                  Text('Email'),
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
                                  Text('Phone No'),
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
                                  Text('Department'),
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
                                  Text('Designation'),
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
                                  Text('Address'),
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
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            onPressed: () async {
                              _updateUserAccount();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: accent,
                            ),
                            child: Text(
                              'Update profile ',
                              style: TextStyle(fontSize: 16, color: Colors.white),
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
