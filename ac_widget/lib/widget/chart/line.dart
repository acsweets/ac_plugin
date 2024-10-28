import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LFLineChart<T> extends StatefulWidget {
  const LFLineChart({
    super.key,
    required this.data,
    required this.targetColumnCount,
    required this.titleBuilder,
    required this.barDataBuilders,
  });

  final List<T> data;

  ///希望显示的柱状图数量，如果数据不足则会将位置空出来
  final int targetColumnCount;

  ///横轴title
  final String Function(T data) titleBuilder;
  final List<BarDataBuilder<T>> barDataBuilders;

  @override
  State<LFLineChart<T>> createState() => _LFLineChartState<T>();
}

class _LFLineChartState<T> extends State<LFLineChart<T>> {
  late List<BarChartGroupData> _showingBarGroups;
  late int _maxHeight;
  int _affineMagnification = 1;

  @override
  void initState() {
    super.initState();
    _clearData();
    _maxHeight = maxmum;
    if (_maxHeight > 0) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _updateBarsWithData();
      });
    }
  }

  int get maxmum {
    final temp = widget.data.isEmpty
        ? 0
        : widget.data
            .map(
              (e) => widget.barDataBuilders
                  .map((builder) => builder.valueBuilder(e))
                  .reduce(max),
            )
            .reduce(max);

    if (temp == 0) return 0;

    double fixedData = temp.toDouble();
    int magnification = 1;

    while (fixedData > 10000) {
      fixedData /= 1000;
      magnification *= 1000;
    }

    var yAxisMax = (fixedData / 10).ceil() * 10;

    if (fixedData > yAxisMax) {
      yAxisMax = ((fixedData / 10).ceil() + 1) * 10;
    }

    _affineMagnification = magnification;

    return yAxisMax;
  }

  @override
  void didUpdateWidget(LFLineChart<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetColumnCount == widget.targetColumnCount &&
        oldWidget.data == widget.data) return;
    final targetMaxmum = maxmum;
    final currentMaxmum = _maxHeight;
    if (targetMaxmum > 0) {
      _maxHeight = targetMaxmum;
      if (currentMaxmum > 0) {
        _updateBarsWithData();
      } else {
        _clearData();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            _updateBarsWithData();
          });
        });
      }
    } else {
      _clearData();
    }
  }

  void _clearData() {
    _showingBarGroups = List.generate(
      widget.targetColumnCount,
      (index) => _barGroup(index, isEmpty: true),
    );
  }

  void _updateBarsWithData() {
    _showingBarGroups = List.generate(widget.targetColumnCount, _barGroup);
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: _maxHeight.toDouble(),
        barTouchData: BarTouchData(
          enabled: true,
          ///触摸数据时显示的弹窗提示
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (e) => Colors.black,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final temp = widget.data.elementAtOrNull(groupIndex);
              if (temp == null) return null;
              return BarTooltipItem(
                widget.barDataBuilders
                        .elementAtOrNull(rodIndex)
                        ?.tipBuilder(temp) ??
                    "",
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          ///AxisTitles上下左右标题是否显示的属性
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(

            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: _bottomTitles,
              ///距离图的距离
              reservedSize: 42,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: _leftTitles,
              reservedSize: 60,
            ),
          ),
        ),

        //图边框
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Color(0xFFEEF0F9), width: 2),
            bottom: BorderSide(color: Color(0xFFEEF0F9), width: 2),
          ),
        ),

        ///柱状图的格数
        barGroups: _showingBarGroups,
        ///网格数据
        gridData: const FlGridData(show: true, drawVerticalLine: false),
      ),
      swapAnimationDuration: const Duration(milliseconds: 800),
      swapAnimationCurve: Curves.easeOutCirc,
    );
  }

  ///自定义显示的 widget
  Widget _leftTitles(double value, TitleMeta meta) {
    if (value != value.toInt()) return const SizedBox();
    final unit = value == 0
        ? ''
        : switch (_affineMagnification) {
            1 => '',
            1000 => 'K',
            1000000 => 'M',
            1000000000 => 'B',
            _ => '',
          };
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        '$value$unit',
        style: const TextStyle(color: Color(0xFF999FB8), fontSize: 14),
      ),
    );
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    final temp = widget.data.elementAtOrNull(value.toInt());
    if (temp == null) return const SizedBox();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 22,
      child: Text(
        widget.titleBuilder(temp),
        style: const TextStyle(color: Color(0xff7589a2), fontSize: 14),
      ),
    );
  }

  BarChartGroupData _barGroup(int x, {bool isEmpty = false}) {
    final temp = widget.data.elementAtOrNull(x);
   ///柱状图的数据
    return BarChartGroupData(
      barsSpace: 0,
      x: x,
      barRods: [
        ...widget.barDataBuilders.map(
          (e) => e.barRodBuilder(
            isEmpty || temp == null
                ? 0
                : (e.valueBuilder(temp) / _affineMagnification),
          ),
        ),
      ],
    );
  }
}

class BarDataBuilder<T> {
  const BarDataBuilder({
    required this.valueBuilder,
    required this.tipBuilder,
    required this.barRodBuilder,
  });

  final double Function(T data) valueBuilder;
  final String Function(T data) tipBuilder;
  final BarChartRodData Function(double toY) barRodBuilder;
}

//i like trance /  Lost in thought  我喜欢发呆


