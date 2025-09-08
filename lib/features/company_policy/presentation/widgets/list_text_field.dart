import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StringListInputPage extends StatefulWidget {
  TextEditingController textController = TextEditingController();
  ValueChanged<List<String>> onListChanged;
  StringListInputPage({
    required this.textController,
    required this.onListChanged,
    super.key,
  });

  @override
  State<StringListInputPage> createState() => _StringListInputPageState();
}

class _StringListInputPageState extends State<StringListInputPage> {
  List<String> items = [];
  TextEditingController textController = TextEditingController();

  void addItem() {
    if (textController.text.isNotEmpty) {
      setState(() {
        items.add(textController.text);
        widget.onListChanged(items);
        textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: 'Geçerli Nedenler',
            suffixIcon: IconButton(icon: Icon(Icons.add), onPressed: addItem),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue, width: 1),
            ),
          ),
          onSubmitted: (_) => addItem(),
        ),
        SizedBox(height: 20),
        Flexible(
          fit:FlexFit.loose,
          child: ListView.builder(
            shrinkWrap: true, 
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      items.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
