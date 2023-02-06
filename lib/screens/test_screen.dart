// import 'package:flutter/material.dart';
// import 'package:nbsms/constant/constant_fonts.dart';
// import 'package:nbsms/constant/constant_images.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// class LearningOnboard extends StatefulWidget {
//   const LearningOnboard({super.key});

//   @override
//   State<LearningOnboard> createState() => _LearningOnboardState();
// }

// class _LearningOnboardState extends State<LearningOnboard> {
//   PageController controller = PageController();
//   bool isLastPage = false;
//   bool isFirstPage = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   height: 600.0,
//                   child: PageView(
//                     controller: controller,
//                     onPageChanged: (index) {
//                       setState(() {
//                         isFirstPage = index == 0;
//                         isLastPage = index == 2;
//                       });
//                     },
//                     children: [
//                       Container(
//                         color: Colors.white,
//                         child: Column(
//                           children: [
//                             Image.asset(onboarding1),
//                             Text(
//                               "This is Page 1",
//                               style:
//                                   TextStyle(fontSize: 33.0, fontWeight: fnt600),
//                             ),
//                             const Text(
//                                 "This is the body of page 1 This is the body of page 1 This is the body of page 1 This is the body of page 1 This is the body of page 1"),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         color: Colors.yellow,
//                       ),
//                       Container(
//                         color: Colors.blue,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                     right: 8,
//                     child: TextButton(
//                         onPressed: () {}, child: const Text("Skip"))),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 isFirstPage
//                     ? SizedBox()
//                     : Container(child: Icon(Icons.arrow_back)),
//                 Container(
//                   child: SmoothPageIndicator(
//                     controller: controller,
//                     count: 3,
//                   ),
//                 ),
//                 isLastPage
//                     ? TextButton(
//                         onPressed: () {},
//                         child: Text("Sign Up"),
//                       )
//                     : Container(child: Icon(Icons.arrow_forward)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
