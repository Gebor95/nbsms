import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    super.key,
    this.text,
  });
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      child: Text(
        text!,
        style: const TextStyle(fontSize: 20.0),
      ),
    );
  }
}
