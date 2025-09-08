import 'package:flutter/material.dart';

class UserPermissionTabs extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabSelected;
  const UserPermissionTabs({
    required this.selectedTab,
    required this.onTabSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _tabs = [
      _TabItem(title: 'Tümü', color: Colors.black, showIcon: false),
      _TabItem(title: 'Genel', color: Colors.orange, showIcon: true),
      _TabItem(title: 'Hastalık', color: Colors.blue, showIcon: true),
    ];

    return Column(
      spacing: 2,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'İzinler',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Row(
            spacing: 16,
            children: List.generate(_tabs.length, (index) {
              final tab = _tabs[index];
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
                          BoxShadow(
                            color: tab.color,
                            blurRadius: 6,
                          ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tab.showIcon
                            ? Icon(Icons.circle, color: tab.color, size: 8)
                            : SizedBox(),
                        const SizedBox(width: 6),
                        Text(
                          tab.title,
                          style: TextStyle(
                            color: selectedTab == index
                                ? Colors.black
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.w700,
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

class _TabItem {
  final String title;
  final Color color;
  final bool showIcon;
  _TabItem({required this.title, required this.color, required this.showIcon});
}
