// import 'dart:math';
//
// import 'package:flutter/material.dart';
//
// class Ball extends StatefulWidget {
//   const Ball({super.key});
//
//   @override
//   State<Ball> createState() => _BallState();
// }
//
// class _BallState extends State<Ball> with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 4),
//       reverseDuration: const Duration(seconds: 4),
//     );
//     _animation = Tween(begin: 0.2, end: 2 * pi).animate(_controller);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _controller.repeat();
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, image) {
//         return Transform.rotate(
//           angle: _animation.value,
//           child: image,
//         );
//       },
//       child: Image.network(
//           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrJGHS_G1Z0uzZIO_YfY3FuWQBcxZG7KsI-w'),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Animated Builder in Flutter'),
//       ),
//       body: const Center(
//         child: Ball(),
//       ),
//     );
//   }
// }
