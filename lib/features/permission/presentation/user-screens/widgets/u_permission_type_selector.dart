import 'package:flutter/material.dart';

class UserPermissionTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeSelected;
  const UserPermissionTypeSelector({
    required this.selectedType,
    required this.onTypeSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final options = {'casual': 'Genel', 'sick': 'Hastalık'};

    return Row(
      spacing: 8,
      children: [
        Icon(Icons.window_rounded, size: 30, color: Colors.blue),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(options.length, (index) {
              final option = options.entries.elementAt(index);
              return Flexible(
                fit: FlexFit.loose,
                child: GestureDetector(
                  onTap: () => onTypeSelected(option.key),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedType == option.key
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        if (selectedType == option.key)
                          BoxShadow(
                            color: option.key == 'casual'
                                ? Colors.orange
                                : Colors.blue,
                            blurRadius: 4,
                          ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                    child: Row(
                      spacing: 6,
                      children: [
                        Icon(
                          Icons.circle,
                          color: option.value.toLowerCase() == 'genel'
                              ? Colors.orange
                              : Colors.blue,
                          size: 8,
                        ),
                        Text(
                          option.value,
                          style: TextStyle(
                            color: option.key == selectedType
                                ? Colors.black
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: option.key == selectedType ? 15 : 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
