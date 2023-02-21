import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../bases/base_bloc.dart';
import '../bases/base_event.dart';

/*
 * Listen Event From Bloc
 *
 * @param Widget
 * @param Function
 */
class ProgressListenerWidget<T extends BaseBloc> extends StatefulWidget {
  final Widget child;
  final Function(BaseEvent event) callback;

  const ProgressListenerWidget({super.key, required this.child, required this.callback});

  @override
  _ProgressListenerWidgetState createState() =>
      _ProgressListenerWidgetState<T>();
}

class _ProgressListenerWidgetState<T> extends State<ProgressListenerWidget> {
  late Stream<BaseEvent> _stream;

  @override
  void initState() {
    super.initState();

    var bloc = context.read<T>() as BaseBloc;
    _stream = bloc.progressStream;
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<BaseEvent?>.value(
      value: _stream,
      initialData: null,
      updateShouldNotify: (prev, current) {
        return true;
      },
      child: Consumer<BaseEvent?>(
        builder: (context, event, child) {
          return Container(
            child: widget.child,
          );
        },
      ),
    );
  }
}

