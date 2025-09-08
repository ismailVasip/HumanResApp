// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class PickAReasonWidget extends StatefulWidget {
  List<String>? list;
  final ValueChanged<String?> onReasonChanged;
  PickAReasonWidget({required this.onReasonChanged,super.key, required this.list});

  @override
  State<PickAReasonWidget> createState() => _PickAReasonWidgetState();
}

class _PickAReasonWidgetState extends State<PickAReasonWidget> {

  String _selectedReason = 'Henüz avans talep nedeni seçilmedi!';
  bool isReasonSelected = false;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 30,
        children: [
          Text(
            'Avans Nedeni Seçimi',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: widget.list?.length ?? 0,
              itemBuilder: (context, index) {
                final item = widget.list?[index];
                bool isSelected = selectedIndex == index;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black26, width: 0.8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            const SizedBox(height: 4),
                            !isSelected
                                ? SizedBox(height: 28)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Material(
                                        shape: const CircleBorder(),
                                        color: Colors.green.shade600,
                                        elevation: 2,
                                        child: const Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.done,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                    ],
                                  ),
                            Icon(
                              Icons.format_list_numbered_rounded,
                              color: Colors.lightBlue,
                              size: 25,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                item ?? 'ERROR',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: TextButton(
                          clipBehavior: Clip.hardEdge,
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor:
                                isReasonSelected && isSelected
                                ? Colors.black87
                                : isReasonSelected && selectedIndex != index
                                ? Colors.grey
                                : Colors.black87,
                          ),
                          onPressed: isReasonSelected && selectedIndex != index
                              ? null
                              : isReasonSelected && selectedIndex == index
                              ? () {
                                  setState(() {
                                    isReasonSelected = false;
                                    selectedIndex = -1;
                                  });
                                }
                              : () {
                                  setState(() {
                                    _selectedReason =
                                        item ??
                                        'Seçilen neden null olarak atandı!';
                                    widget.onReasonChanged(_selectedReason);
                                    selectedIndex = index;
                                    isReasonSelected = true;
                                  });
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isSelected
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      spacing: 8,
                                      children: [
                                        Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                        const Text(
                                          'İptal Et',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      'Seç',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
