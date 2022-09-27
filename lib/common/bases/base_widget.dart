import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class PageContainer extends StatelessWidget {
  final Widget child;
  final List<SingleChildWidget> providers;
  AppBar? appBar;

  PageContainer({required this.child, required this.providers, this.appBar});

  @override
  Widget build(BuildContext context) {
    return shouldRenderPage();
  }

  Widget shouldRenderPage() {
    if (providers.isNotEmpty) {
      return MultiProvider(
        providers: [...providers],
        child: Scaffold(
          appBar: appBar,
          body: child,
        ),
      );
    } else {
      return Scaffold(
        appBar: appBar,
        body: child,
      );
    }
  }
}
