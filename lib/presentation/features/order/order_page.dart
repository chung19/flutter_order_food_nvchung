import 'package:flutter/material.dart';
import 'package:flutter_order_food_nvchung/data/model/order.dart';
import 'package:flutter_order_food_nvchung/presentation/features/order/order_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../common/bases/base_widget.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../data/repositories/order_repository.dart';
import 'order_event.dart';
class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      providers: [
        Provider(create: (context) => OrderRepository()),
        ProxyProvider<OrderRepository, OrderBloc>(
            create: (context) => OrderBloc(),
            update: (context, repository, bloc) {
              bloc!.updateRepository(orderRepository: repository);
              return bloc;
            }
        )
      ],
      appBar: AppBar(
        title: Text("Order History"),
      ),
      child: OrderContainer(),
    );
  }
}

class OrderContainer extends StatefulWidget {
  const OrderContainer({Key? key}) : super(key: key);

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  late OrderBloc _bloc;
  Order? _cart;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = context.read();
    _bloc.eventSink.add(FetchOrderEvent());
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          child: LoadingWidget(
            bloc: _bloc,
            child: StreamBuilder<List<Order>>(
              initialData: null,
              stream: _bloc.orderController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Data is error"),
                  );
                }
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("Data is empty"),
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) => itemList(snapshot.data?[index])
                      ),
                    ),
                    // Container(
                    //     margin: const EdgeInsets.symmetric(vertical: 10),
                    //    height: 50,
                    //     padding: const EdgeInsets.all(10),
                    //     decoration: const BoxDecoration(
                    //         color: Colors.teal,
                    //         borderRadius: BorderRadius.all(Radius.circular(5))),
                    //     child: Text(
                    //         "Tổng Tiền : ${NumberFormat("#,###", "en_US")
                    //                 .format(_cart?.price??0)} đ",
                    //         style: const TextStyle(fontSize: 25, color: Colors.white))),
                  ],


                );
              },
            ),
          ),
        )
    );
  }

  Widget itemList (Order? orderModel) {
    if (orderModel == null) return Container();
    return ListTile(
      title: Text(orderModel.date_created ??= ""),
      subtitle: Text(
          "Tổng Tiền : ${NumberFormat("#,###", "en_US")
                  .format(orderModel.price ??= 0) } đ",
          style: TextStyle(fontSize: 12)),
    );
  }
}

