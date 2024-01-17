import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:talk_trainer/models/user_success_rate.dart';
import 'package:talk_trainer/utils/app_colors.dart';
import 'package:intl/intl.dart';

import '../widgets/icon_button.dart';

class UserFeedbackFragment extends StatelessWidget {
  final UserSuccessRate userSuccessRate;
  final VoidCallback onPressedTranslate;
  final VoidCallback? onPressedListen;

  const UserFeedbackFragment(
      {super.key,
      required this.userSuccessRate,
      required this.onPressedTranslate,
      this.onPressedListen});

  @override
  Widget build(BuildContext context) {
    List<CategorySuccessRate> userResponse = <CategorySuccessRate>[
      CategorySuccessRate('Słowa', userSuccessRate.wordsAccuracy,
          AppColors.successRateChartBlue),
      CategorySuccessRate('Akcent', userSuccessRate.accentAccuracy,
          AppColors.successRateChartBrown),
      CategorySuccessRate('Intonacja', userSuccessRate.intonationAccuracy,
          AppColors.successRateChartPink),
      CategorySuccessRate('Wymowa', userSuccessRate.pronunciationAccuracy,
          AppColors.successRateChartOrange),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Visibility(
          visible: !kIsWeb,
          child: Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
                  child: AppIconButton(
                    backgroundColorDefault: AppColors.primaryHighlight[700]!,
                    backgroundColorPressed:
                        Theme.of(context).primaryColorDark,
                    onPressed: onPressedTranslate,
                    child: const Icon(
                      Icons.translate_rounded,
                      color: AppColors.primaryShadow,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AppIconButton(
                    backgroundColorDefault: AppColors.primaryHighlight[700]!,
                    backgroundColorPressed:
                        Theme.of(context).primaryColorDark,
                    onPressed: onPressedListen!,
                    child: const Icon(
                      Icons.headset_rounded,
                      color: AppColors.primaryShadow,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: kIsWeb
                ? const EdgeInsets.fromLTRB(100.0, 100.0, 100.0, 0)
                : EdgeInsets.zero,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: const CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                numberFormat: NumberFormat.percentPattern(),
                minimum: 0,
                maximum: 1,
                majorGridLines: const MajorGridLines(width: 0),
              ),
              series: <CartesianSeries<CategorySuccessRate, String>>[
                ColumnSeries<CategorySuccessRate, String>(
                  dataSource: userResponse,
                  xValueMapper: (CategorySuccessRate data, _) =>
                      data.category,
                  yValueMapper: (CategorySuccessRate data, _) => data.rate,
                  pointColorMapper: (CategorySuccessRate data, _) =>
                      data.color,
                  width: 0.4,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CategorySuccessRate {
  final String category;
  final double rate;
  final Color color;

  CategorySuccessRate(this.category, this.rate, this.color);
}
