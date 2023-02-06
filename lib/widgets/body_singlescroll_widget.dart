import 'package:flutter/material.dart';

class BodyPaddingWidget extends StatelessWidget {
  const BodyPaddingWidget({
    super.key,
    required this.children,
  });
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
