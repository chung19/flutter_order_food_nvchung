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
