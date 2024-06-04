import 'package:flutter/material.dart';
import 'package:project_proud_me/constant.dart';

class TextListWidget extends StatelessWidget {
  final String title;
  final List<String> texts;

  const TextListWidget({
    Key? key,
    required this.title,
    required this.texts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontFamily: fontFamily,
            ),
          ),
        ),
        ...List.generate(
          texts.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 4.0),
                  child: Icon(
                    Icons.circle,
                    size: 10,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    texts[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: fontFamily
                      ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
