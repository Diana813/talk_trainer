import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/app_colors.dart';

void showIntonationPopup(
    context, List<double> lectorPitchData, List<double> userPitchData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.primaryBackground[300],
        title: const Text("Intonacja"),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.6,
          child: SfCartesianChart(
            legend:
                const Legend(isVisible: true, position: LegendPosition.bottom),
            primaryXAxis: const NumericAxis(
              title: AxisTitle(text: 'Czas'),
            ),
            primaryYAxis: const NumericAxis(
              title: AxisTitle(text: 'Wysokość tonu'),
            ),
            series: <LineSeries<double, int>>[
              LineSeries<double, int>(
                name: 'Lektor',
                dataSource: lectorPitchData,
                xValueMapper: (double data, index) => index,
                yValueMapper: (double data, index) => data,
              ),
              LineSeries<double, int>(
                name: 'Ty',
                dataSource: userPitchData,
                xValueMapper: (double data, index) => index,
                yValueMapper: (double data, index) => data,
              ),
            ],
          ),
        ),
      );
    },
  );
}
