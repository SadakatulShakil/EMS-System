import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utill/stored_images.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35), // Adjust the radius as needed
                  bottomRight: Radius.circular(35), // Adjust the radius as needed
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.shade700.withOpacity(0.2), // Shadow color
                    spreadRadius: 8, // Spread radius
                    blurRadius: 7, // Blur radius
                    offset: Offset(0, 4), // Offset in x and y directions
                  ),
                ],
              ),
              child: Image.asset('assets/images/home_background.png'),
            ),
            Positioned(child: Column(
              children: [
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Astronist Shakil', style: GoogleFonts.mulish(color: Colors.white,
                                fontSize: 20 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.w600),maxLines: 1,overflow: TextOverflow.ellipsis,),
                            SizedBox(height: 10,),
                            Text('Senior Software Engineer', style: TextStyle(
                                fontSize: 16 / MediaQuery.textScaleFactorOf(context), color: Colors.white),),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage('https://i.pinimg.com/736x/d2/98/4e/d2984ec4b65a8568eab3dc2b640fc58e.jpg'),
                        radius: 30,
                      )
                    ],
                  ),
                ),


              ],
            ))
          ],),
          SizedBox(height: 25,),
          GestureDetector(
            onTap: (){

            },
            child: Container(
                height: 170, width:170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(120),
                  color: Colors.white,

                ),
                //square box; equal height and width so that it won't look like oval
                child: Stack(
                    alignment: Alignment.center,
                    children:[
                      Image.asset('assets/images/rounded_btn.png', height: 200, width: 200,),
                      Positioned(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(Images.checkInBtn),
                          ],
                        ),
                      )
                    ] )
            ),
          ),
        ],
      )
    );
  }

}
