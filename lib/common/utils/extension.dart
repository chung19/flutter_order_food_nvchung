import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';

void showMessage(
    [BuildContext? context,
    String? title,
    String? message,
    Widget? child,
    List<SingleChildWidget>? actionsAlert]) {
  if (context == null) return;
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: (title == null || title.isEmpty) ? null : Text(title),
        content: (message == null || message.isEmpty) ? null : Text(message),



        actions: actionsAlert,

      );
    },
  );
}

   Future  showDetail (
    [BuildContext? context,
    String? title,
    String? message,
      Widget? widget,
      Widget? widgets,
    Container? container,
    List<SingleChildWidget>? actionsAlert]) async {

  if (context == null) return;
 await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
    return StatefulBuilder(
        builder: (context, state )=>
       Dialog(
        child: (widget == null ) ? null : widget,



      ),
    );
    },
  );
}

bool isNotEmpty(List<String> data) {
  for (int i = 0; i < data.length; i++) {
    if (data[i].isEmpty) {
      return false;
    }
  }
  return true;
}
//extension marquee
class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;

  const MarqueeWidget({
    Key? key,
    required this.child,
    this.direction = Axis.horizontal,
    this.animationDuration = const Duration(milliseconds: 6000),
    this.backDuration = const Duration(milliseconds: 800),
    this.pauseDuration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  MarqueeWidgetState createState() => MarqueeWidgetState();
}

class MarqueeWidgetState extends State<MarqueeWidget> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 50.0);
    WidgetsBinding.instance!.addPostFrameCallback(scroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.direction,
      controller: scrollController,
      child: widget.child,
    );
  }

  void scroll(_) async {
    while (scrollController.hasClients) {
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: widget.animationDuration,
          curve: Curves.ease,
        );
      }
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          0.0,
          duration: widget.backDuration,
          curve: Curves.easeOut,
        );
      }
    }
  }
}