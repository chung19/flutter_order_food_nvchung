import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class PageContainer extends StatelessWidget {
  final Widget child;
  final List<SingleChildWidget> providers;
  final AppBar? appBar;

  PageContainer(
      {super.key, required this.child, required this.providers, this.appBar});

  @override
  Widget build(BuildContext context) {
// Tối ưu hàm shouldRenderPage bằng cách truyền providers vào MultiProvider trực tiếp
    return MultiProvider(
      providers: providers,
      child: Scaffold(
        appBar: appBar,
        body: child,
      ),
    );
  }
}

// Xóa hàm shouldRenderPage vì nó không còn cần thiết nữa
