import 'package:flutter/material.dart';

class TestButton extends StatefulWidget {
  const TestButton({Key? key}) : super(key: key);

  @override
  State<TestButton> createState() => _TestButtonState();
}

class _TestButtonState extends State<TestButton> {
  @override
  Widget build(BuildContext context) {
    return
    Container(
      height: 100,
      width: 20,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Xử lý đăng nhập
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text('Đkăng nhập'),
      ),
    );

  }
}
