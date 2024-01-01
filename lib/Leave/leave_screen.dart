import 'package:flutter/material.dart';
import '../../utill/color_resources.dart';
import '../utill/dimensions.dart';
import 'package:image_picker/image_picker.dart';
class LeaveScreen extends StatefulWidget {
  bool backExits;
  LeaveScreen({Key? key, required this.backExits}) : super(key: key);
  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {

  List<String> leaveTypes = ['', 'Casual Leave', 'Sick Leave', 'Paid Leave', 'Unpaid Leave'];
  List<String> reportingPersons = ['', 'Broak Stephen (HR)', 'Stephen clark (PM)', 'Ellon Mask (Team Lead)', 'Mark Zukarbag (Acting Lead)'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Variables to store selected values
  String? selectedLeaveType;
  String? selectedReportingPerson;
  String leaveReason = '';
  String leaveFromDate = '';
  String leaveToDate = '';
  String fileName = '';

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

      setState(() {
        leaveFromDate =
        "${dateparse.day}-${dateparse.month}-${dateparse.year}";
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

      setState(() {
        leaveToDate =
        "${dateparse.day}-${dateparse.month}-${dateparse.year}";
      });
    });
  }

  // Function to display entered data in a dialog
  void _showSubmittedData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submitted Data'),
          content: Container(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Leave Type: $selectedLeaveType'),
                Text('From Date: ${leaveFromDate}'),
                Text('To Date: ${leaveFromDate}'),
                Text('Leave Reason: $leaveReason'),
                Text('Reporting person: $selectedReportingPerson'),
                Text('File name: $fileName'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
                  onTap: ()async{
                    Navigator.pop(context);
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.camera);
                    print('file Name: '+ image!.name.toString());
                    setState(() {
                      fileName = image.name.toString();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/camera.png'),
                      SizedBox(height: 8,),
                      Text('Camera'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: ()async{
                    Navigator.pop(context);
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    print('file Name: '+ image!.name.toString());
                    setState(() {
                      fileName = image.name.toString();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/gallery.png'),
                      SizedBox(height: 8,),
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accent,
        title: Text('Apply Leave'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
              },
              icon: Stack(clipBehavior: Clip.none, children: [
                Icon(Icons.notifications, size: 30,),
                Positioned(top: -2, right: -2,
                  child: CircleAvatar(radius: 7, backgroundColor: Colors.red,
                    child: Text('0',// need a consumer for cart data
                        style: TextStyle(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall,
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
                DropdownButtonFormField<String>(
                  value: selectedLeaveType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLeaveType = newValue;
                    });
                  },
                  items: leaveTypes.map((String leaveType) {
                    return DropdownMenuItem<String>(
                      value: leaveType,
                      child: Text(leaveType.isEmpty ? 'Select Leave Type' : leaveType, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Leave Type', labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This Field must be selected';
                    }
                    return null;
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(leaveFromDate == ''? 'Select date': leaveFromDate),
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(leaveToDate == ''? 'Select date': leaveToDate),
                            Icon(Icons.calendar_month_rounded)
                          ],
                        ))),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: selectedReportingPerson,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedReportingPerson = newValue;
                    });
                  },
                  items: reportingPersons.map((String leaveType) {
                    return DropdownMenuItem<String>(
                      value: leaveType,
                      child: Text(leaveType.isEmpty ? 'Select reporting person' : leaveType, style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Reporting person', labelStyle: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This Field must be selected';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      leaveReason = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Leave Reason',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                    onTap: () {
                      _showPhotoPicker();
                    },
                    child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Necessary file',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*.7,
                                child: Text(fileName == ''? 'Upload a photo': fileName, maxLines: 1,overflow: TextOverflow.ellipsis,)),
                            Icon(Icons.photo)
                          ],
                        ))),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Show the entered data in a dialog
                    _showSubmittedData();
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

