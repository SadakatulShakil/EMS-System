import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../Model/leave_types_model.dart';
import '../../providers/leave_provider.dart';
import '../../utill/color_resources.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utill/dimensions.dart';
import 'alert_widget/alertWidget.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LeaveScreen extends StatefulWidget {
  bool backExits;

  LeaveScreen({Key? key, required this.backExits}) : super(key: key);

  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  List<String> leaveTypes = [
    '',
    'Casual Leave',
    'Sick Leave',
    'Paid Leave',
    'Unpaid Leave'
  ];
  String? token;
  final List<String> reportingPersons = [
    'Broak Stephen (HR)',
    'Stephen clark (PM)',
    'Ellon Mask (Team Lead)',
    'Mark Zukarbag (Acting Lead)'
  ];
  List<String> _selectedItems = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  // Variables to store selected values
  String? selectedLeaveType;
  late String selectedReporters;
  List<dynamic> selectedReportingPersons = [];
  String leaveReason = '';
  String leaveFromDate = '';
  String leaveToDate = '';
  String fileName = '';
  int? leaveTypeId;

  void _removeFromList(String item) {
    setState(() {
      _selectedItems.remove(item);
    });
  }

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  void _showMultiSelect() async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: reportingPersons);
      },
    );

    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  _showFromDatePicker() {
    /// TODO changing the color of date picker
    DateTime currentDate = DateTime.now();
    DateTime previousDays = currentDate.subtract(Duration(days: 1));
    DateTime nextDays = currentDate.add(Duration(days: 365));

    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: previousDays,
      lastDate: nextDays,
    ).then((value) {
      var dateparse = DateTime.parse(value.toString());
      String formattedDate = '${dateparse.year}-${dateparse.month.toString().padLeft(2, '0')}-${dateparse.day.toString().padLeft(2, '0')}';
      setState(() {
        leaveFromDate = formattedDate;
      });
    });
  }

  _showToDatePicker() {
    /// TODO changing the color of date picker
    DateTime currentDate = DateTime.now();
    DateTime previousDays = currentDate.subtract(Duration(days: 1));
    DateTime nextDays = currentDate.add(Duration(days: 365));

    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: previousDays,
      lastDate: nextDays,
    ).then((value) {
      var dateparse = DateTime.parse(value.toString());
      String formattedDate = '${dateparse.year}-${dateparse.month.toString().padLeft(2, '0')}-${dateparse.day.toString().padLeft(2, '0')}';
      setState(() {
        leaveToDate = formattedDate;
      });
    });
  }

  // Function to display entered data in a dialog
  // void _showSubmittedData() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Submitted Data'),
  //         content: Container(
  //           height: 250,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text('Leave Type: $leaveTypeId'),
  //               Text('From Date: ${leaveFromDate}'),
  //               Text('To Date: ${leaveFromDate}'),
  //               Text('Leave Reason: $leaveReason'),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _applyNewLeave() async{
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    SharedPreferences sp = await SharedPreferences.getInstance();
    token = sp.getString("tokenId");
    print('hgvf: '+token!);
    if(leaveToDate == ''){
      Get.snackbar(
        'Warning',
        'Leave-to date is needed',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
    }else if(leaveFromDate == ''){
      Get.snackbar(
        'Warning',
        'Leave-from date is needed',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
    }else{
      if(_formKey.currentState!.validate()){
        try {
          leaveProvider.applyLeave(token!, titleController.text, reasonController.text, leaveTypeId!, leaveFromDate, leaveToDate);

          setState(() {
            titleController.text = ''; // Resetting title field
            reasonController.text = ''; // Resetting reason field
            selectedLeaveType = null; // Resetting selected leave type
            leaveTypeId = null; // Resetting leave type ID
            leaveFromDate = ''; // Resetting leave from date
            leaveToDate = ''; // Resetting leave to date
          });
        } catch (e) {
          if (kDebugMode) {
            print('Error fetching profile: $e');
          }
          throw e;
        }
      }
    }
  }

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
    selectedReporters = '';
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);
    return leaveProvider.isLoading?Center(
      child: LoadingAnimationWidget.threeRotatingDots(
        color: Colors.green,
        size: 30,
      ),
    ):Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accent,
        title: Text('Apply Leave'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: () {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => FinalView()));
              },
              icon: Stack(clipBehavior: Clip.none, children: [
                Icon(
                  Icons.notifications,
                  size: 30,
                ),
                Positioned(
                  top: -2,
                  right: -2,
                  child: CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.red,
                    child: Text('0', // need a consumer for cart data
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.fontSizeExtraSmall,
                        )),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                onChanged: (value) {
                  setState(() {
                    leaveReason = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter leave title';
                  }
                  return null; // Return null if the input is valid
                },
                decoration: InputDecoration(
                  labelText: 'Leave Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Consumer<LeaveProvider>(
                builder: (context, leaveTypesProvider, _) {
                  if (leaveTypesProvider.leaveTypes.isEmpty) {
                    return CircularProgressIndicator();
                  } else {
                    return DropdownButtonFormField<Datum>(
                      items: leaveTypesProvider.leaveTypes.map((leaveType) {
                        return DropdownMenuItem<Datum>(
                          value: leaveType,
                          child: Text(leaveType.name),
                        );
                      }).toList(),
                      onChanged: (selectedLeaveType) {
                        // Handle selected leave type
                        leaveTypeId = selectedLeaveType?.id;
                        print('Selected Leave Type: ${selectedLeaveType?.id}');
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a leave type';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Leave Type',
                        border: OutlineInputBorder(),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                  onTap: () {
                    _showFromDatePicker();
                  },
                  child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Leave From',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(leaveFromDate == ''
                              ? 'Select date'
                              : leaveFromDate),
                          Icon(Icons.calendar_month_rounded)
                        ],
                      ))),
              SizedBox(height: 16.0),
              GestureDetector(
                  onTap: () {
                    _showToDatePicker();
                  },
                  child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Leave To',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(leaveToDate == '' ? 'Select date' : leaveToDate),
                          Icon(Icons.calendar_month_rounded)
                        ],
                      ))),
              SizedBox(height: 16.0),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     GestureDetector(
              //       onTap: (){
              //         _showMultiSelect();
              //       },
              //       child: Container(
              //         padding: EdgeInsets.all(16.0),
              //         decoration:BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           color: Colors.white,
              //           boxShadow: [
              //             BoxShadow(color: Colors.grey.shade500, spreadRadius: .8),
              //           ],
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text('Select Your Reporting person'),
              //             Icon(Icons.arrow_drop_down, color: Colors.grey.shade700,)
              //           ],
              //         ),
              //       ),
              //     ),
              //     if (_selectedItems.isEmpty)
              //       const SizedBox(
              //         width: double.infinity,
              //         child: Column(
              //           children: [
              //             SizedBox(height: 10),
              //             Text("Please select at least one person"),
              //           ],
              //         ),
              //       )
              //     else
              //       Wrap(
              //         children: _selectedItems
              //             .map(
              //               (e) => Padding(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 4, vertical: 2),
              //             child: Chip(
              //               label: GestureDetector(
              //                 onTap: () {
              //                   _removeFromList(e);
              //                 },
              //                 child: Row(
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: [
              //                     Text(e),
              //                     const SizedBox(
              //                       width: 3,
              //                     ),
              //                     const Icon(Icons.delete_forever, color: Colors.red,),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //         )
              //             .toList(),
              //       )
              //   ],
              // ),
              // const Divider(
              //   height: 10,
              // ),
              // SizedBox(height: 16.0),
              TextFormField(
                controller: reasonController,
                onChanged: (value) {
                  setState(() {
                    leaveReason = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter leave title';
                  }
                  return null; // Return null if the input is valid
                },
                decoration: InputDecoration(
                  labelText: 'Leave Reason',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              // GestureDetector(
              //     onTap: () {
              //       _showPhotoPicker();
              //     },
              //     child: InputDecorator(
              //         decoration: InputDecoration(
              //           labelText: 'Necessary file',
              //           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              //           border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(10.0)),
              //         ),
              //         child:
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Container(
              //               width: MediaQuery.of(context).size.width*.7,
              //                 child: Text(fileName == ''? 'Upload a photo': fileName, maxLines: 1,overflow: TextOverflow.ellipsis,)),
              //             Icon(Icons.photo)
              //           ],
              //         ))),
              // SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Show the entered data in a dialog
                  //_saveForm();
                  _applyNewLeave();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
