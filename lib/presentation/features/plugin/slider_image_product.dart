// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// class SliderImageProDuct extends StatefulWidget {
//   const SliderImageProDuct({Key? key}) : super(key: key);
//
//   @override
//   State<SliderImageProDuct> createState() => _SliderImageProDuctState();
// }
//
// class _SliderImageProDuctState extends State<SliderImageProDuct> {
//   num? height;
//   @override
//
//   Widget build(BuildContext context) {
//     return  CarouselSlider(
//
//       items: <Widget>[
//         for (var i = 0; i < image.length; i++)
//           Container(
//             margin: const EdgeInsets.only(top: 20.0, left: 20.0),
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage(image[i]),
//                 fit: BoxFit.fitHeight,
//               ),
//               // border:
//               //     Border.all(color: Theme.of(context).accentColor),
//               borderRadius: BorderRadius.circular(32.0),
//             ),
//           ),
//       ], options: CarouselOptions(),
//     );
//   }
// }
