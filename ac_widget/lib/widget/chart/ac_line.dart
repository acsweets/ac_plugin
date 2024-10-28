
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

///左下标题显示  左下边框
///
class AcLine extends StatefulWidget {
  const AcLine({super.key});

  @override
  State<AcLine> createState() => _AcLineState();
}

class _AcLineState extends State<AcLine> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  BarTouchTooltipData customTip() {
    return BarTouchTooltipData(
      getTooltipColor: (e) => Colors.white,
      tooltipPadding: EdgeInsets.all(10),
      maxContentWidth: 150,
      tooltipHorizontalAlignment: FLHorizontalAlignment.right,
      //向右边偏移的距离
      tooltipHorizontalOffset: 0,
      //上下偏移的距离
      tooltipMargin: -100,
      //弹窗旋转角度
      rotateAngle: 0,
      //  [rod] 当前的数据
      getTooltipItem: (group, groupIndex, rod, rodIndex) {
        return BarTooltipItem(
            '15 H\n 数据（MB）：552',
            const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.left);
      },
      fitInsideHorizontally: true,
      // fitInsideVertically: true,
      tooltipBorder: BorderSide(width: 2, color: Colors.black.withOpacity(0.1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,

          ///触摸数据时显示的弹窗提示  BarChartGroupData.showingTooltipIndicators 强制显示提示
          touchTooltipData: customTip(),
        ),
        // 自定义水平线和垂直线 getDrawingHorizontalLine  getDrawingVerticalLine
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.black.withOpacity(0.2),
            strokeWidth: 1,
          ),
        ),
        //设置Y轴的最大值
        maxY: 100,
        barGroups: [
          BarChartGroupData(
            x: 10,
            barRods: [
              BarChartRodData(
                borderRadius: BorderRadius.zero,
                toY: 100,
                //给一个触摸判断
                color: Colors.grey.withOpacity(0.1),
                width: 20,
                borderSide: const BorderSide(color: Colors.white, width: 0),
                //背景数据柱状图
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 30,
                  color: Colors.deepPurple,
                ),
                rodStackItems: [
                  BarChartRodStackItem(10, 30, Colors.lightGreen,),
                  BarChartRodStackItem(10, 20, Colors.orange,),

                ],
              ),
            ],
            // showingTooltipIndicators: showTooltips,
          ),
          BarChartGroupData(
            x: 20,
            barRods: [
              BarChartRodData(
                borderRadius: BorderRadius.zero,
                toY: 100,
                color: Colors.grey.withOpacity(0.1),
                width: 20,
                borderSide: const BorderSide(color: Colors.white, width: 0),
                //背景数据
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 50,
                  color: Colors.deepPurple,
                ),
                //堆叠的柱状图
                rodStackItems: [
                  BarChartRodStackItem(20, 50, Colors.lightGreen,),
                  BarChartRodStackItem(20, 30, Colors.orange,),

                ],
              ),
            ],
            // showingTooltipIndicators: showTooltips,
          ),

          // BarChartGroupData(
          //   x: 20,
          //   barRods: [
          //     BarChartRodData(
          //       toY: 30,
          //       color: Colors.lightGreen,
          //       width: 10,
          //       borderSide: const BorderSide(color: Colors.white, width: 0),
          //       //背景数据
          //       backDrawRodData: BackgroundBarChartRodData(
          //         show: true,
          //         toY: 50,
          //         color: Colors.deepPurple,
          //       ),
          //     ),
          //     BarChartRodData(
          //       toY: 60,
          //       color: Colors.lightGreen,
          //       width: 10,
          //       borderSide: const BorderSide(color: Colors.white, width: 0),
          //       //背景数据
          //       backDrawRodData: BackgroundBarChartRodData(
          //         show: true,
          //         toY: 90,
          //         color: Colors.deepPurple,
          //       ),
          //     ),
          //   ],
          //   // showingTooltipIndicators: showTooltips,
          // ),
          // BarChartGroupData(),
          // BarChartGroupData(
          //   x: 30,
          //   barRods: [
          //     BarChartRodData(
          //       toY: 30,
          //       color: Colors.lightGreen,
          //       width: 10,
          //       borderSide: const BorderSide(color: Colors.white, width: 0),
          //       //背景数据
          //       backDrawRodData: BackgroundBarChartRodData(
          //         show: true,
          //         toY: 50,
          //         color: Colors.deepPurple,
          //       ),
          //     ),
          //     BarChartRodData(
          //       toY: 60,
          //       color: Colors.lightGreen,
          //       width: 10,
          //       borderSide: const BorderSide(color: Colors.white, width: 0),
          //       //背景数据
          //       backDrawRodData: BackgroundBarChartRodData(
          //         show: true,
          //         toY: 90,
          //         color: Colors.deepPurple,
          //       ),
          //     ),
          //   ],
          //   // showingTooltipIndicators: [1,],
          // ),
        ],
      ),
    );
  }

  ///思路触摸后更改背景图注的颜色

  ///1
//   BarChartGroupData makeGroupData(
//       int x,
//       double y, {
//         bool isTouched = false,
//         Color? barColor,
//         double width = 22,
//         List<int> showTooltips = const [],
//       }) {
//     barColor ??= widget.barColor;
//     return BarChartGroupData(
//       x: x,
//       barRods: [
//         BarChartRodData(
//           toY: isTouched ? y + 1 : y,
//           color: isTouched ? widget.touchedBarColor : barColor,
//           width: width,
//           borderSide: isTouched
//               ? BorderSide(color: widget.touchedBarColor.darken(80))
//               : const BorderSide(color: Colors.white, width: 0),
//           backDrawRodData: BackgroundBarChartRodData(
//             show: true,
//             toY: 20,
//             color: widget.barBackgroundColor,
//           ),
//         ),
//       ],
//       showingTooltipIndicators: showTooltips,
//     );
//   }
//
//   List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
//     switch (i) {
//       case 0:
//         return makeGroupData(0, 5, isTouched: i == touchedIndex);
//       case 1:
//         return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
//       case 2:
//         return makeGroupData(2, 5, isTouched: i == touchedIndex);
//       case 3:
//         return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
//       case 4:
//         return makeGroupData(4, 9, isTouched: i == touchedIndex);
//       case 5:
//         return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
//       case 6:
//         return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
//       default:
//         return throw Error();
//     }
//   });
//
//   BarChartData mainBarData() {
//     return BarChartData(
//       barTouchData: BarTouchData(
//         touchTooltipData: BarTouchTooltipData(
//           getTooltipColor: (_) => Colors.blueGrey,
//           tooltipHorizontalAlignment: FLHorizontalAlignment.right,
//           tooltipMargin: -10,
//           getTooltipItem: (group, groupIndex, rod, rodIndex) {
//             String weekDay;
//             switch (group.x) {
//               case 0:
//                 weekDay = 'Monday';
//                 break;
//               case 1:
//                 weekDay = 'Tuesday';
//                 break;
//               case 2:
//                 weekDay = 'Wednesday';
//                 break;
//               case 3:
//                 weekDay = 'Thursday';
//                 break;
//               case 4:
//                 weekDay = 'Friday';
//                 break;
//               case 5:
//                 weekDay = 'Saturday';
//                 break;
//               case 6:
//                 weekDay = 'Sunday';
//                 break;
//               default:
//                 throw Error();
//             }
//             return BarTooltipItem(
//               '$weekDay\n',
//               const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//               children: <TextSpan>[
//                 TextSpan(
//                   text: (rod.toY - 1).toString(),
//                   style: const TextStyle(
//                     color: Colors.white, //widget.touchedBarColor,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//         touchCallback: (FlTouchEvent event, barTouchResponse) {
//           setState(() {
//             if (!event.isInterestedForInteractions ||
//                 barTouchResponse == null ||
//                 barTouchResponse.spot == null) {
//               touchedIndex = -1;
//               return;
//             }
//             touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
//           });
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: getTitles,
//             reservedSize: 38,
//           ),
//         ),
//         leftTitles: const AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: false,
//       ),
//       barGroups: showingGroups(),
//       gridData: const FlGridData(show: false),
//     );
//   }
//
//   Widget getTitles(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Colors.white,
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     );
//     Widget text;
//     switch (value.toInt()) {
//       case 0:
//         text = const Text('M', style: style);
//         break;
//       case 1:
//         text = const Text('T', style: style);
//         break;
//       case 2:
//         text = const Text('W', style: style);
//         break;
//       case 3:
//         text = const Text('T', style: style);
//         break;
//       case 4:
//         text = const Text('F', style: style);
//         break;
//       case 5:
//         text = const Text('S', style: style);
//         break;
//       case 6:
//         text = const Text('S', style: style);
//         break;
//       default:
//         text = const Text('', style: style);
//         break;
//     }
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 16,
//       child: text,
//     );
//   }
//
//   BarChartData randomData() {
//     return BarChartData(
//       barTouchData: BarTouchData(
//         enabled: false,
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: getTitles,
//             reservedSize: 38,
//           ),
//         ),
//         leftTitles: const AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//           ),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//           ),
//         ),
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: false,
//       ),
//       barGroups: List.generate(7, (i) {
//         switch (i) {
//           case 0:
//             return makeGroupData(
//               0,
//               Random().nextInt(15).toDouble() + 6,
//               barColor: widget.availableColors[
//               Random().nextInt(widget.availableColors.length)],
//             );
//           case 1:
//             return makeGroupData(
//               1,
//               Random().nextInt(15).toDouble() + 6,
//               barColor: widget.availableColors[
//               Random().nextInt(widget.availableColors.length)],
//             );
//           case 2:
//             return makeGroupData(
//               2,
//               Random().nextInt(15).toDouble() + 6,
//               barColor: widget.availableColors[
//               Random().nextInt(widget.availableColors.length)],
//             );
//           case 3:
//             return makeGroupData(
//               3,
//               Random().nextInt(15).toDouble() + 6,
//               barColor: widget.availableColors[
//               Random().nextInt(widget.availableColors.length)],
//             );
//           case 4:
//             return makeGroupData(
//               4,
//               Random().nextInt(15).toDouble() + 6,
//               barColor: widget.availableColors[
//               Random().nextInt(widget.availableColors.length)],
//             );
//           case 5:
//             return makeGroupData(
//               5,
//               Random().nextInt(15).toDouble() + 6,
//               barColor: widget.availableColors[
//               Random().nextInt(widget.availableColors.length)],
//             );
//           case 6:
//             return makeGroupData(
//               6,
//               Random().nextInt(15).toDouble() + 6,
//               barColor: widget.availableColors[
//               Random().nextInt(widget.availableColors.length)],
//             );
//           default:
//             return throw Error();
//         }
//       }),
//       gridData: const FlGridData(show: false),
//     );
//   }
//
//   Future<dynamic> refreshState() async {
//     setState(() {});
//     await Future<dynamic>.delayed(
//       animDuration + const Duration(milliseconds: 50),
//     );
//     if (isPlaying) {
//       await refreshState();
//     }
//   }
  ///2
  ///  BarChartGroupData makeGroupData(
//     int x,
//     double y,
//   ) {
//     return BarChartGroupData(
//       x: x,
//       barRods: [
//         BarChartRodData(
//           toY: y,
//           color: x >= 4 ? Colors.transparent : widget.barColor,
//           borderRadius: BorderRadius.zero,
//           borderDashArray: x >= 4 ? [4, 4] : null,
//           width: 22,
//           borderSide: BorderSide(color: widget.barColor, width: 2.0),
//         ),
//       ],
//     );
//   }
//
//   Widget getTitles(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Colors.white,
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     );
//     List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
//
//     Widget text = Text(
//       days[value.toInt()],
//       style: style,
//     );
//
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 16,
//       child: text,
//     );
//   }
//
//   BarChartData randomData() {
//     return BarChartData(
//       maxY: 300.0,
//       barTouchData: BarTouchData(
//         enabled: false,
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: getTitles,
//             reservedSize: 38,
//           ),
//         ),
//         leftTitles: const AxisTitles(
//           sideTitles: SideTitles(
//             reservedSize: 30,
//             showTitles: true,
//           ),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//           ),
//         ),
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: false,
//       ),
//       barGroups: List.generate(
//         7,
//         (i) => makeGroupData(
//           i,
//           Random().nextInt(290).toDouble() + 10,
//         ),
//       ),
//       gridData: const FlGridData(show: false),
//     );
//   }
// }
}
