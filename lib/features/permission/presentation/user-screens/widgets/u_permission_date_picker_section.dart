import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UserPermissionDatePickerSection extends StatelessWidget {
  final String startDate;
  final String endDate;
  final ValueChanged<DateRangePickerSelectionChangedArgs> onSelectionChanged;
  const UserPermissionDatePickerSection({
    required this.startDate,
    required this.endDate,
    required this.onSelectionChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShowSelectedDateText(date: startDate,text: 'Başlangıç Tarihi',),

        SfDateRangePicker(
          backgroundColor: Colors.grey.shade200,
          startRangeSelectionColor: Colors.blue,
          endRangeSelectionColor: Colors.blue,
          onSelectionChanged: onSelectionChanged,
          rangeSelectionColor: Colors.grey.shade400,
          selectionMode: DateRangePickerSelectionMode.range,
          initialSelectedRange: PickerDateRange(
            DateTime.now().subtract(const Duration(days: 4)),
            DateTime.now().add(const Duration(days: 3)),
          ),
          monthViewSettings: DateRangePickerMonthViewSettings(dayFormat: 'EEE'),
          headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: Colors.blue,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        ShowSelectedDateText(date: endDate,text: 'Bitiş Tarihi',),
      ],
    );
  }
}

class ShowSelectedDateText extends StatelessWidget {
  const ShowSelectedDateText({
    super.key,
    required this.date,
    required this.text
  });

  final String date;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Icon(Icons.arrow_left_rounded, color: Colors.blue, size: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            Text(
              date,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
