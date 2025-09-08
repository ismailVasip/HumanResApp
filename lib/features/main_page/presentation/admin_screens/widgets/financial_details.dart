import 'package:flutter/material.dart';

class FinancialDetails extends StatelessWidget {
  final TextEditingController annualLimitController;
  final TextEditingController remainingLimitController;
  final ValueChanged<String> valueChanged;
  final String? Function(String?)? validator;
  const FinancialDetails({
    required this.annualLimitController,
    required this.remainingLimitController,
    required this.valueChanged,
    required this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text(
              "Finansal Bilgiler",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),

            TextFormField(
              controller: annualLimitController,
              validator: validator,
              onChanged: (value) => valueChanged(value),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Yıllık Limit",
                prefixIcon: Icon(Icons.account_balance_wallet),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Remaining Limit (readonly)
            TextFormField(
              controller: remainingLimitController,
              enabled: false,
              decoration: InputDecoration(
                labelText: "Kalan Limit",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
