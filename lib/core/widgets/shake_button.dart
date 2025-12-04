// import 'package:flutter/material.dart';
//
// class ShakeButton extends StatefulWidget {
//   final Widget child;
//   final VoidCallback onTap;
//
//   const ShakeButton({
//     super.key,
//     required this.child,
//     required this.onTap,
//   });
//
//   @override
//   State<ShakeButton> createState() => _ShakeButtonState();
// }
//
// class _ShakeButtonState extends State<ShakeButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _offset;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 350),
//     );
//
//     _offset = Tween<double>(begin: 0, end: 10)
//         .chain(CurveTween(curve: Curves.elasticIn))
//         .animate(_controller);
//   }
//
//   void _trigger() async {
//     await _controller.forward();
//     _controller.reverse();
//     widget.onTap();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _offset,
//       builder: (_, child) {
//         return Transform.translate(
//           offset: Offset(_offset.value, 0),
//           child: child,
//         );
//       },
//       child: GestureDetector(
//         onTap: _trigger,
//         child: widget.child,
//       ),
//     );
//   }
// }
