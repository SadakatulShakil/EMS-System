import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../Model/profile_model.dart';
import '../screen/login/widget/main_login_widget.dart';
import '../utill/app_constant.dart';
import 'auth_session_provider.dart';


class ProfileProvider extends ChangeNotifier {
  bool _loadingIndicator = false;
  bool get isLoadingProfile => _loadingIndicator;
  void updateDataLoadingIndicator(bool value) {
    _loadingIndicator = value;
    notifyListeners();
  }
  /// Full name
  String _usersFullName = '';
  String get nameOfUser => _usersFullName;
  void updateTextFieldUsersFullName(String value) {
    _usersFullName = value;

    notifyListeners();
  }

  /// contact
  String _usersContact = '';
  String get contactOfUser => _usersContact;
  void updateTextFieldUsersContact(String value) {
    _usersContact = value;

    notifyListeners();
  }

  /// blood group
  String _usersBloodGroup = '';
  String get bloodGroupOfUser => _usersBloodGroup;
  void updateTextFieldUsersBloodGroup(String value) {
    _usersBloodGroup = value;

    notifyListeners();
  }

  /// Email
  String _usersEmail = '';
  String get usersEmail => _usersEmail;
  void updateTextFieldUsersEmail(String value) {
    _usersEmail = value;

    notifyListeners();
  }

  /// Email
  String _usersVillage = '';
  String get usersVillage => _usersVillage;
  void updateTextFieldUsersVillage(String value) {
    _usersVillage = value;

    notifyListeners();
  }

  // ///filtering region list based on starte id
  // List<Regions?> filterRegionsByStateId(int stateId) {
  //   return regionsForFiltering!
  //       .where((region) => region!.state?.id == stateId)
  //       .toList();
  // }
  //
  // ///filtering Districts list based on region id
  // List<Districts?> filterDistrictsByRegionId(int regionId) {
  //   return districtsForFiltering!
  //       .where((district) => district!.region?.id == regionId)
  //       .toList();
  // }
  //
  // ///state value
  // String _selectedStateName = '';
  // String get selectedStateName => _selectedStateName;
  // int _selectedStateId = 1;
  // int get selectedStateId => _selectedStateId;
  //
  // void setInitialValueForState() {
  //   if (states?.isNotEmpty ?? true) {
  //     try {
  //       _selectedStateName = states?.first?.name ?? "";
  //       _selectedStateId = states?.first?.id ?? 1;
  //       regions = filterRegionsByStateId(_selectedStateId);
  //       if (regions!.isEmpty) {
  //         _selectedDistrictsName = '';
  //         districts?.clear();
  //         setInitialValueForDistrict();
  //         notifyListeners();
  //       }
  //       _selectedRegionName = '';
  //       setInitialValueForRegion();
  //       notifyListeners();
  //     } catch (_) {}
  //   } else {}
  // }
  //
  // void setSelectedStateName(int id) {
  //   // Find the object with the matching ID
  //   final selectedState = states?.firstWhere(
  //         (state) => state?.id == id,
  //   );
  //
  //   // Set the selected name based on the object's name
  //   _selectedStateName = selectedState?.name ?? '';
  //   _selectedStateId = selectedState?.id ?? 1;
  //   regions = filterRegionsByStateId(_selectedStateId);
  //   if (regions!.isEmpty) {
  //     _selectedDistrictsName = '';
  //     districts?.clear();
  //     notifyListeners();
  //   }
  //   _selectedRegionName = '';
  //   setInitialValueForRegion();
  //
  //   notifyListeners();
  // }
  //
  // ///Region value
  // String _selectedRegionName = '';
  // String get selectedRegionName => _selectedRegionName;
  // int _selectedRegionId = 1;
  // int get selectedRegionId => _selectedRegionId;
  //
  // void setInitialValueForRegion() {
  //   try {
  //     if (regions?.isNotEmpty ?? true) {
  //       _selectedRegionName = regions?.first?.name ?? "";
  //       _selectedRegionId = regions?.first?.id ?? 1;
  //       districts = filterDistrictsByRegionId(_selectedRegionId);
  //       _selectedDistrictsName = '';
  //       setInitialValueForDistrict();
  //       notifyListeners();
  //     } else {}
  //   } catch (_) {}
  // }
  //
  // void setSelectedRegionName(int id) {
  //   // Find the object with the matching ID
  //   final selectedRegion = regions?.firstWhere(
  //         (region) => region?.id == id,
  //   );
  //
  //   // Set the selected name based on the object's name
  //   _selectedRegionName = selectedRegion?.name ?? '';
  //   _selectedRegionId = selectedRegion?.id ?? 1;
  //   districts = filterDistrictsByRegionId(_selectedRegionId);
  //   _selectedDistrictsName = '';
  //   setInitialValueForDistrict();
  //   notifyListeners();
  // }
  //
  // ///Districts value
  // String _selectedDistrictsName = '';
  // String get selectedDistrictsName => _selectedDistrictsName;
  //
  // int _selectedDistrictId = 1;
  // int get selectedDistrictId => _selectedDistrictId;
  //
  // void setInitialValueForDistrict() {
  //   // setSelectedStateName(3);
  //   if (districts?.isNotEmpty ?? true) {
  //     if (_selectedDistrictsName.isEmpty) {
  //       _selectedDistrictsName = districts?.first?.name ?? "";
  //       // _selectedStateId = states?.first?.id ?? 1;
  //       _selectedDistrictId = districts?.first?.id ?? 1;
  //       notifyListeners();
  //     } else {}
  //   } else {}
  // }
  //
  // void setSelectedDistrictsName(int id) {
  //   // Find the object with the matching ID
  //   final selectedDistricts = districts?.firstWhere(
  //         (district) => district?.id == id,
  //   );
  //
  //   // Set the selected name based on the object's name
  //   _selectedDistrictsName = selectedDistricts?.name ?? '';
  //   _selectedDistrictId = selectedDistricts?.id ?? 1;
  //
  //   notifyListeners();
  // }

  // late List<States?>? states;
  // late List<Regions?>? regions;
  // late List<Districts?>? districts;
  // List<Regions?>? regionsForFiltering;
  // List<Districts?>? districtsForFiltering;
  User? user;
  ProfileModel? mainData;

  Future<void> getProfileData(BuildContext context, String tokenOfAuthUser) async {
    final sessionProvider = Provider.of<AuthSessionProvider>(context);
    updateDataLoadingIndicator(true);

    String fileName = "profileData.json";

    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/$fileName");
    if (file.existsSync()) {
      var jsonData = file.readAsStringSync();
      //mainData = profileModelFromJson(jsonData);
      mainData = ProfileModel.fromJson(json.decode(jsonData));

      // states = mainData?.data.states;
      // regions = mainData?.data.regions;
      // districts = mainData?.data.districts;
      // districtsForFiltering = mainData?.data.districts;
      // regionsForFiltering = mainData?.data.regions;
      user = mainData?.data.user;
      _usersFullName = user?.name ?? "";
      _usersEmail = user?.email ?? "";
      _usersVillage = mainData?.data.village ?? "";
      updateDataLoadingIndicator(false);
      notifyListeners();

      final url = Uri.parse(AppConstants.profileData);
      try {
        final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $tokenOfAuthUser',
          },
        );

        if (response.statusCode == 200) {
          print("res pro: "+ response.body.toString());
          file.writeAsStringSync(response.body,
              flush: true, mode: FileMode.write);
          final jsonData = jsonDecode(response.body);
          // mainData = ChwUserProfileData.fromJson(jsonData);
          // states = mainData?.data?.states;
          // regions = mainData?.data?.regions;
          // districts = mainData?.data?.districts;
          // districtsForFiltering = mainData?.data?.districts;
          // regionsForFiltering = mainData?.data?.regions;
          user = mainData?.data.user;
          _usersFullName = user?.name ?? "";
          _usersEmail = user?.email ?? "";
          _usersVillage = mainData?.data.village ?? "";
          updateDataLoadingIndicator(false);
          notifyListeners();
        }  else if(response.statusCode == 401){
          // Handle errors for each response if needed
          sessionProvider.userToken= '';
          await  sessionProvider.remove().then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainLoginPage()),
            );
          });

          Get.snackbar(
            "Alert!",
            "Your authentication token is expired Please Login again, to continue.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
          notifyListeners();
        }
      } catch (e) {
        print("error catch: "+e.toString());
      }
    }
    else {
      updateDataLoadingIndicator(true);
      final url = Uri.parse(AppConstants.profileData);
      try {
        final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $tokenOfAuthUser',
          },
        );

        if (response.statusCode == 200) {
          print("res pro: "+ response.body.toString());
          file.writeAsStringSync(response.body,
              flush: true, mode: FileMode.write);
          final jsonData = jsonDecode(response.body);
          mainData = ProfileModel.fromJson(jsonData);

          // states = mainData?.data.states;
          // regions = mainData?.data.regions;
          // districts = mainData?.data.districts;
          // districtsForFiltering = mainData?.data.districts;
          // regionsForFiltering = mainData?.data.regions;
          user = mainData?.data.user;
          _usersFullName = user?.name ?? "";
          _usersEmail = user?.email ?? "";
          _usersVillage = mainData?.data.village ?? "";
          updateDataLoadingIndicator(false);
          notifyListeners();
        }  else if(response.statusCode == 401){
          // Handle errors for each response if needed
          sessionProvider.userToken= '';
          await  sessionProvider.remove().then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainLoginPage()),
            );
          });

          Get.snackbar(
            "Alert!",
            "Your authentication token is expired Please Login again, to continue.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
          notifyListeners();
        }else if(response.statusCode == 500){
          Get.snackbar(
            "Error!",
            "There is an issue on server.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
        }
      } catch (e) {
        print("error catch: "+e.toString());
      }
    }
  }

  /// update profile

  Future<dynamic> updateProfile(BuildContext context, String tokenOfAuthUser) async {
    final sessionProvider = Provider.of<AuthSessionProvider>(context);
    final url = Uri.parse(AppConstants.updateProfileData);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization':
        'Bearer ${tokenOfAuthUser}',
      },
      body: {
        'name': nameOfUser,
        'phone': contactOfUser,
        'email': usersEmail,
        'blood_group': bloodGroupOfUser,
        // 'state_id': selectedStateId.toString(),
        // 'region_id': selectedRegionId.toString(),
        // 'district_id': selectedDistrictId.toString(),
        'village': usersVillage,
      },
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        "Success !.",
        "Profile updated successfully.",
        snackPosition:
        SnackPosition.TOP,
        // You can change the position
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
      return response.statusCode;
    }else if(response.statusCode == 401){
      // Handle errors for each response if needed
      sessionProvider.userToken= '';
      await  sessionProvider.remove().then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainLoginPage()),
        );
      });

      Get.snackbar(
        "Alert!",
        "Your authentication token is expired Please Login again, to continue.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
      notifyListeners();
    }else if(response.statusCode == 500){
      Get.snackbar(
        "Error!",
        "There is an issue on server.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
    } else{
      return response.statusCode;
    }
  }
}