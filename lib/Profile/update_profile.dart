import 'dart:io';
import 'package:employe_management_system/Profile/widget/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utill/dimensions.dart';
import '../../utill/stored_images.dart';
import '../utill/color_resources.dart';

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
  final FocusNode _bloodGroupFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  String? selectedBloodType;
  List<String> bloodGroups = ['', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  File? file;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  void _choose() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  _updateUserAccount() async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();

    /// Do update functionality here
    print('Update button clicked');
  }



  @override
  Widget build(BuildContext context) {
    _firstNameController.text = 'Mr. Haasan Masud';
    _lastNameController.text = 'Developer';
    _emailController.text = 'haasanmasud@company.com';
    _phoneController.text = '01751330394';
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Image.asset(Images.toolbarBackground, fit: BoxFit.fill, height: 500,),
            ),

            Container(padding: const EdgeInsets.only(top: 35, left: 15),
              child: Row(children: [
                CupertinoNavigationBarBackButton(
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.white,),
                const SizedBox(width: 10),

                Text('Settings',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),

            Container(padding: const EdgeInsets.only(top: 55),
              child: Column(children: [
                Column(
                  children: [
                    Container(margin: const EdgeInsets.only(top: Dimensions.marginSizeExtraLarge),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(color: accentShade, width: 3),
                        shape: BoxShape.circle,),
                      child: Stack(clipBehavior: Clip.none,
                        children: [
                          ClipRRect(borderRadius: BorderRadius.circular(50),
                            child: file == null ?
                            FadeInImage.assetNetwork(
                              placeholder: Images.user, width: Dimensions.profileImageSize,
                              height: Dimensions.profileImageSize, fit: BoxFit.cover,
                              image: Images.user,
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.user,
                                  width: Dimensions.profileImageSize, height: Dimensions.profileImageSize, fit: BoxFit.cover),
                            ) :
                            Image.file(file!, width: Dimensions.profileImageSize,
                                height: Dimensions.profileImageSize, fit: BoxFit.fill),),
                          Positioned(bottom: 0, right: -10,
                            child: CircleAvatar(backgroundColor: accentShade,
                              radius: 14,
                              child: IconButton(onPressed: _choose,
                                padding: const EdgeInsets.all(0),
                                icon: const Icon(Icons.edit, color: Colors.white, size: 18),),),
                          ),
                        ],
                      ),
                    ),

                    Text('Mr. Haasan Masud',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),)
                  ],
                ),

                const SizedBox(height: Dimensions.marginSizeDefault),
                
                Expanded(child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.marginSizeDefault),
                        topRight: Radius.circular(Dimensions.marginSizeDefault),)),
                  child: ListView(physics: const BouncingScrollPhysics(),
                    children: [
                      Container(margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault),
                        child: Expanded(child: Column(
                          children: [Row(children: [
                            Icon(Icons.person, color: accentShade, size: 20,),
                            const SizedBox(width: Dimensions.marginSizeExtraSmall),
                            Text('Name')
                          ],
                          ),
                            const SizedBox(height: Dimensions.marginSizeSmall),

                            CustomTextField(textInputType: TextInputType.name,
                              focusNode: _fNameFocus,
                              nextNode: _lNameFocus,
                              hintText: 'Enter first name',
                              fillColor: primaryBackground,
                              controller: _firstNameController,
                            ),
                          ],
                        )),
                      ),



                      Container(margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeDefault,
                          left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault),
                        child: Column(children: [
                          Row(children: [Icon(Icons.alternate_email,
                            color: accentShade, size: 20,),
                            const SizedBox(width: Dimensions.marginSizeExtraSmall,),
                            Text('Email')
                          ],
                          ),
                          const SizedBox(height: Dimensions.marginSizeSmall),

                          CustomTextField(textInputType: TextInputType.emailAddress,
                            focusNode: _emailFocus,
                            isEnable : false,
                            nextNode: _phoneFocus,
                            fillColor: primaryBackground,
                            hintText: 'Enter email',
                            controller: _emailController,
                          ),
                        ],
                        ),
                      ),


                      Container(margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeDefault,
                          left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault),
                        child: Column(children: [
                          Row(children: [
                            Icon(Icons.dialpad, color: accentShade, size: 20,),
                            const SizedBox(width: Dimensions.marginSizeExtraSmall),
                            Text('Phone No')
                          ],),
                          const SizedBox(height: Dimensions.marginSizeSmall),

                          CustomTextField(
                            textInputType: TextInputType.phone,
                            focusNode: _phoneFocus,
                            hintText: 'Enter phone no',
                            nextNode: _addressFocus,
                            fillColor: primaryBackground,
                            controller: _phoneController,
                            isPhoneNumber: true,
                          ),],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(
                            top: Dimensions.marginSizeDefault,
                            left: Dimensions.marginSizeDefault,
                            right: Dimensions.marginSizeDefault),
                        child: DropdownButtonFormField<String>(
                          value: selectedBloodType,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedBloodType = newValue;
                            });
                          },
                          items: bloodGroups.map((String group) {
                            return DropdownMenuItem<String>(
                              value: group,
                              child: Text(group.isEmpty ? 'Select blood group' : group, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Select blood group', labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),

                      Container(margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeDefault,
                          left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault),
                        child: Column(children: [
                          Row(children: [
                            Icon(Icons.dialpad, color: accentShade, size: 20,),
                            const SizedBox(width: Dimensions.marginSizeExtraSmall),
                            Text('Address')
                          ],),
                          const SizedBox(height: Dimensions.marginSizeSmall),

                          CustomTextField(
                            textInputType: TextInputType.text,
                            focusNode: _addressFocus,
                            hintText: 'Enter address',
                            nextNode: _addressFocus,
                            fillColor: primaryBackground,
                            controller: _addressController,
                            isPhoneNumber: true,
                          ),],
                        ),
                      ),

                    ],
                  ),
                ),
                ),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async{

                    },
                    style: ElevatedButton.styleFrom(

                      primary: accent, // Set the background color here
                    ),
                    child: Text('Update profile ', style: TextStyle(color: Colors.white, fontSize: 16 / MediaQuery.textScaleFactorOf(context))),
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
