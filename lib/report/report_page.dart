import 'package:employe_management_system/report/widget/extention.dart';
import 'package:employe_management_system/report/widget/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../utill/color_resources.dart';

class ReportPageSection extends StatefulWidget {
  ReportPageSection({super.key});
  final Color leftBarColor = AppColors.contentColorGreen;
  final Color middleBarColor = AppColors.contentColorRed;
  final Color rightBarColor = AppColors.contentColorBlue;
  final Color avgColor =
  AppColors.contentColorOrange.avg(AppColors.contentColorRed);
  @override
  State<ReportPageSection> createState() => ReportPageSectionState();
}

class ReportPageSectionState extends State<ReportPageSection> {
  int touchedIndex = -1;
  final double width = 5;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(0, 18, 15, 15);
    final barGroup2 = makeGroupData(1, 16, 12, 10);
    final barGroup3 = makeGroupData(2, 18, 5, 8);
    final barGroup4 = makeGroupData(3, 20, 16, 13);
    final barGroup5 = makeGroupData(4, 18, 6, 5);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF66A690),
        title: Text('Daily Report'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent.withOpacity(.2),
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      height: MediaQuery.of(context).size.height*.33,
                      width: MediaQuery.of(context).size.height/2,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: PieChart(
                                  PieChartData(
                                    pieTouchData: PieTouchData(
                                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                        setState(() {
                                          if (!event.isInterestedForInteractions ||
                                              pieTouchResponse == null ||
                                              pieTouchResponse.touchedSection == null) {
                                            touchedIndex = -1;
                                            return;
                                          }
                                          touchedIndex = pieTouchResponse
                                              .touchedSection!.touchedSectionIndex;
                                        });
                                      },
                                    ),
                                    startDegreeOffset: 180,
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sectionsSpace: 1,
                                    centerSpaceRadius: 0,
                                    sections: showingSections(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Indicator(
                                  color: AppColors.contentColorBlue,
                                  text: 'On Attend',
                                  isSquare: false,
                                ),
                                Divider(),
                                Indicator(
                                  color: AppColors.contentColorYellow,
                                  text: 'On Absent',
                                  isSquare: false,
                                ),
                                Divider(),
                                Indicator(
                                  color: AppColors.contentColorPink,
                                  text: 'On Leave',
                                  isSquare: false,
                                ),
                                Divider(),
                                Indicator(
                                  color: AppColors.contentColorGreen,
                                  text: 'Late Entry',
                                  isSquare: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //Text('Fig: Today\\u0027s Report'.replaceAll('\\u0027', '\''))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent.withOpacity(.2),
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      height: MediaQuery.of(context).size.height*.4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Expanded(
                          child: BarChart(
                            BarChartData(
                              maxY: 20,
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: Colors.grey,
                                  getTooltipItem: (a, b, c, d) => null,
                                ),
                                touchCallback: (FlTouchEvent event, response) {
                                  if (response == null || response.spot == null) {
                                    setState(() {
                                      touchedGroupIndex = -1;
                                      showingBarGroups = List.of(rawBarGroups);
                                    });
                                    return;
                                  }

                                  touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                                  setState(() {
                                    if (!event.isInterestedForInteractions) {
                                      touchedGroupIndex = -1;
                                      showingBarGroups = List.of(rawBarGroups);
                                      return;
                                    }
                                    showingBarGroups = List.of(rawBarGroups);
                                    if (touchedGroupIndex != -1) {
                                      var sum = 0.0;
                                      for (final rod
                                      in showingBarGroups[touchedGroupIndex].barRods) {
                                        sum += rod.toY;
                                      }
                                      final avg = sum /
                                          showingBarGroups[touchedGroupIndex]
                                              .barRods
                                              .length;

                                      showingBarGroups[touchedGroupIndex] =
                                          showingBarGroups[touchedGroupIndex].copyWith(
                                            barRods: showingBarGroups[touchedGroupIndex]
                                                .barRods
                                                .map((rod) {
                                              return rod.copyWith(
                                                  toY: avg, color: widget.avgColor);
                                            }).toList(),
                                          );
                                    }
                                  });
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: bottomTitles,
                                    reservedSize: 42,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    interval: 1,
                                    getTitlesWidget: leftTitles,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              barGroups: showingBarGroups,
                              gridData: FlGridData(show: true),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Indicator(
                          color: AppColors.contentColorGreen,
                          text: 'Attend',
                          isSquare: false,
                        ),
                        Divider(),
                        Indicator(
                          color: AppColors.contentColorRed,
                          text: 'Late',
                          isSquare: false,
                        ),
                        Divider(),
                        Indicator(
                          color: AppColors.contentColorBlue,
                          text: 'Leave',
                          isSquare: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
          (i) {
        final isTouched = i == touchedIndex;
        const color0 = AppColors.contentColorBlue;
        const color1 = AppColors.contentColorYellow;
        const color2 = AppColors.contentColorPink;
        const color3 = AppColors.contentColorGreen;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0,
              value: 25,
              title: '88%',
              titleStyle: TextStyle(fontSize: 15, color: Colors.white),
              radius: 25*4,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                  color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                  color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: color1,
              value: 25,
              title: '7%',
              titleStyle: TextStyle(fontSize: 15, color: Colors.white),
              radius: 25*3.6,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                  color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                  color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: color2,
              value: 25,
              title: '5%',
              titleStyle: TextStyle(fontSize: 15, color: Colors.white),
              radius: 25*3.3,
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? const BorderSide(
                  color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                  color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: color3,
              value: 25,
              title: '15%',
              titleStyle: TextStyle(fontSize: 15, color: Colors.white),
              radius: 25*3.8,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                  color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                  color: AppColors.contentColorWhite.withOpacity(0)),
            );
          default:
            throw Error();
        }
      },
    );
  }
  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 2) {
      text = '2';
    } else if (value == 4) {
      text = '4';
    }else if (value == 6) {
      text = '6';
    }else if (value == 8) {
      text = '8';
    }else if (value == 10) {
      text = '10';
    }else if (value == 12) {
      text = '12';
    }else if (value == 14) {
      text = '14';
    }else if (value == 16) {
      text = '16';
    }else if (value == 18) {
      text = '18';
    }else if (value == 20) {
      text = '20';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Su', 'Mn', 'Te', 'Wd', 'Tu'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.middleBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y3,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }
}