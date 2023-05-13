// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../common/constants/style_constant.dart';
// import '../../../../common/utils/extension.dart';
// import '../../../../data/model/product.dart';
// import '../home_bloc.dart';
// import '../home_event.dart';
// import 'button_base.dart';
//
// class DetailAlertDialog extends StatefulWidget {
//   const DetailAlertDialog({Key? key}) : super(key: key);
//
//   @override
//   State<DetailAlertDialog> createState() => _DetailAlertDialogState();
// }
//
// class _DetailAlertDialogState extends State<DetailAlertDialog> {
//   late HomeBloc _homeBloc;
//   @override
//   void initState() {
//     super.initState();
//     _homeBloc = context.read();
//     // _homeBloc = Provider.of<HomeBloc>(context);
//   }
//
//   void addCart(String idProduct) {
//     _homeBloc.eventSink.add(AddCartEvent(idProduct: idProduct));
//   }
// Widget detailAlertDialog(BuildContext context, Product product) {
//     return AlertDialog(
//       actions: [
//         Row(
//
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text(
//                   "Cancel",
//                   style: handleButtonDetailCanelTextStyle,
//                 )),
//             TextButton(
//               onPressed: () {
//                 addCart(product.id);
//                 Navigator.pop(context);
//               },
//               child:    Container(
//                 margin: const EdgeInsets.symmetric(
//                   vertical: 5,
//                 ),
//                 padding: const EdgeInsets.fromLTRB(8, 10, 4,10),
//                 decoration: const BoxDecoration(
//                     color: Color(0xFF0783EC),
//                     borderRadius:
//                     BorderRadius.all(Radius.circular(30))),
//                 child: Text("Buy Now ",style:GoogleFonts.antonio(
//                   color: Color(0xFFF1F5F1),
//                 ) ,),
//               ),),
//           ],
//         ),
//       ],
//       title: Text(
//         product.name,
//         textAlign: TextAlign.center,
//         style: GoogleFonts.chewy(
//           fontSize: 24,
//           color: const Color(0xFFA22617),
//           textStyle:
//           Theme.of(context).textTheme.displayLarge,
//         ),
//       ),
//       content: SizedBox(
//         width: double.maxFinite,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//
//             Container(
//               margin: const EdgeInsets.only(top: 10),
//             ),
//             CarouselSlider(
//               items: product.gallery
//                   .map((e) => Center(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.network(
//                       "https://serverappsale.onrender.com/$e",
//                       fit: BoxFit.cover,
//                       width: 1000,
//                     ),
//                   )))
//                   .toList(),
//               options: CarouselOptions(
//                 // height: 400,
//                 aspectRatio: 16 / 9,
//                 viewportFraction: 0.8,
//                 initialPage: 0,
//                 enableInfiniteScroll: true,
//                 reverse: false,
//                 autoPlay: true,
//                 autoPlayInterval: const Duration(seconds: 3),
//                 autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                 autoPlayCurve: Curves.fastOutSlowIn,
//                 enlargeCenterPage: true,
//                 scrollDirection: Axis.horizontal,
//               ),
//             ),
//             const SizedBox(height: 10,),
//             Container(
//               margin: const EdgeInsets.symmetric(
//                 vertical: 5,
//               ),
//               padding: const EdgeInsets.fromLTRB(14, 2, 14, 2),
//               decoration: const BoxDecoration(
//                   color: Colors.teal,
//                   borderRadius:
//                   BorderRadius.all(Radius.circular(50))),
//               child: Text(
//                 "Price : ${NumberFormat("#,###", "en_US").format(product.price)} đ",
//                 style: GoogleFonts.amita(
//                   fontSize: 20,
//                   color: const Color(0xFFEFF5EF),
//                   textStyle:
//                   Theme.of(context).textTheme.displaySmall,
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(
//                 vertical: 5,
//               ),
//               padding: const EdgeInsets.fromLTRB(23.8, 2, 23.8,2),
//               decoration: const BoxDecoration(
//                   color: Color(0xFFC91A1A),
//                   borderRadius:
//                   BorderRadius.all(Radius.circular(30))),
//               child: Text(
//                 'Quantity : 99+',
//                 maxLines: 1,
//                 style: GoogleFonts.amita(
//                   fontSize: 20,
//                   color: const Color(0xFFEFF5EF),
//                   textStyle:
//                   Theme.of(context).textTheme.displaySmall,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MyCustomButton(
//       onPressed: () {
//         _homeBloc.eventSink
//             .add(AddCartEvent(idProduct: product.id));
//       },// Nội dung của button
//       backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
//
//         if (states.contains(MaterialState.pressed)) {
//           return const Color.fromARGB(
//               188, 157, 201, 10);
//         }
//         return const Color.fromARGB(
//             230, 240, 102, 61);
//       }),
//       child: const Text("thêm vào giỏ",
//           style: TextStyle(fontSize: 10)),
//     );
//
//
// // Button này có thể tái sử dụng, có thể chỉnh sửa màu sắc, shape, nội dung,... cho phù hợp với từng màn hình, nhu cầu sử dụng khác nhau.
//
//
//
//
//         ;
//
//   }
//
//
// }
