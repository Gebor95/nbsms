import 'package:flutter/material.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton(
      {required this.onTap,
      this.text,
      this.width = double.infinity,
      this.height,
      this.child,
      this.color,
      this.bgcolor, //background color
      this.fgcolor, //foreground color
      this.textStyle,
      this.borderSide,
      super.key});
  final VoidCallback onTap;
  final String? text;
  final double? width;
  final double? height;
  final Widget? child;
  final Color? color;
  final Color? bgcolor;
  final Color? fgcolor;
  final TextStyle? textStyle;
  final BorderSide? borderSide;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 60,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgcolor ?? nbPrimarycolor,
          foregroundColor: fgcolor ?? nbPrimarycolor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: borderSide ?? BorderSide.none),
        ),
        child: child ??
            Text(text!,
                style: textStyle ??
                    TextStyle(
                        color: nbSecondarycolor,
                        fontWeight: fnt500,
                        fontSize: 16.0,
                        fontFamily: centurygothic)),
      ),
    );
  }
}
