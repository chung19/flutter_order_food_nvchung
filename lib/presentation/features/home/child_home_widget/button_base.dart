
import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final MaterialStateProperty<Color?>? backgroundColor; // Thêm thuộc tính backgroundColor

  const MyCustomButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.backgroundColor, // Khai báo thuộc tính backgroundColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: backgroundColor, // Sử dụng thuộc tính backgroundColor
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
      child: child,
    );
  }
}
