// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ikproject/features/bonus_request/domain/entities/user_financials_entity.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DeterminingAmountWidget extends StatefulWidget {
  UserFinancialsEntity entity;
  double autoApprovalMaxAmount;
  int maxInstallments;
  final ValueChanged<double?> onAmountChanged;
  final ValueChanged<bool> onIsAutoApproveChanged;
  DeterminingAmountWidget({
    required this.entity,
    required this.autoApprovalMaxAmount,
    required this.maxInstallments,
    required this.onAmountChanged,
    required this.onIsAutoApproveChanged,
    super.key,
  });

  @override
  State<DeterminingAmountWidget> createState() =>
      _DeterminingAmountWidgetState();
}

class _DeterminingAmountWidgetState extends State<DeterminingAmountWidget> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 30,
        children: [
          Text(
            'Avans Tutarı Seçimi',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SfSliderTheme(
            data: SfSliderThemeData(
              tooltipBackgroundColor: Colors.black,
              tooltipTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: SfSlider(
              min: 0,
              max: widget.entity.remainingLimit == 0.0
                  ? 2
                  : widget.entity.remainingLimit.ceil(),
              value: _value,
              interval: widget.entity.remainingLimit == 0.0
                  ? 1
                  : widget.entity.remainingLimit.ceil() / 2,
              stepSize: widget.entity.remainingLimit == 0.0
                  || widget.entity.remainingLimit.ceil() < 100 ? null : 100,
              showTicks: true,
              showLabels: true,
              enableTooltip: true,
              activeColor: Colors.blue,
              inactiveColor: Colors.black,
              minorTicksPerInterval: 1,
              tooltipShape: SfPaddleTooltipShape(),
              onChanged: (dynamic value) {
                setState(() {
                  _value = value as double;
                  widget.onAmountChanged(_value);
                  widget.onIsAutoApproveChanged(_value <= widget.autoApprovalMaxAmount);
                });
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
              border: Border.all(color: Colors.blueAccent.shade100, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Seçilen Tutar : ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: "${_value.toInt()}₺",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Geri Ödeme Planı : ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: 
                        "${widget.maxInstallments} x ${(_value.toInt() / widget.maxInstallments)}₺",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),

                AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: _value <= widget.autoApprovalMaxAmount
                      ? Row(
                          spacing: 6,
                          key: ValueKey("auto_approval"),
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 24,
                            ),
                            Expanded(
                              child: Text(
                                'Bu talep anında onaylanacaktır.',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          spacing: 6,
                          key: ValueKey("admin_approval"),
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange.shade700,
                              size: 24,
                            ),
                            Expanded(
                              child: Text(
                                'Bu talep yönetici onayı gerektirecektir.',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
