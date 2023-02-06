import 'package:flutter/material.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';

Widget buildPage({
  required Color color,
  required String urlimage,
  required String title,
  required String subtitle,
}) =>
    Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            urlimage,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            title,
            style: TextStyle(
              color: nbPrimarycolor,
              fontSize: 28.0,
              fontWeight: fnt500,
              fontFamily: centurygothic,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              subtitle,
              style: TextStyle(fontFamily: centurygothic, wordSpacing: 2.0),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
