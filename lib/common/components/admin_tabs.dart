import 'package:flutter/material.dart';

class AdminTabs extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabSelected;

  const AdminTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _TabItem(title: "Bekleyenler", color: Colors.orange),
      _TabItem(title: "Kabul Edilenler", color: Colors.green.shade700),
      _TabItem(title: "Reddedilenler", color: Colors.red.shade700),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 3),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedTab == index
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    if (selectedTab == index)
                      BoxShadow(color: tab.color, blurRadius: 6),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, color: tab.color, size: 10),
                    const SizedBox(width: 6),
                    Text(
                      tab.title,
                      style: TextStyle(
                        fontSize: 12,
                        color: selectedTab == index
                            ? Colors.black
                            : Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TabItem {
  final String title;
  final Color color;
  _TabItem({required this.title, required this.color});
}
