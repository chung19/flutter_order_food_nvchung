import 'package:flutter/material.dart';
import 'package:flutter_order_food_nvchung/data/model/order.dart';
import 'package:flutter_order_food_nvchung/presentation/features/order/order_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../common/bases/base_widget.dart';
import '../../../common/constants/api_constant.dart';
import '../../../common/utils/extension.dart';
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
        title: Center(child: const Text("Order History")),
      ),
      child: const OrderContainer(),
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = context.read();
    _bloc.eventSink.add(FetchOrderEvent());
  }
  void handleOrderButtonDetail() async{

    showDetail (

      context,
      'Chi Tiết',
      '', SafeArea(
      child: Container(
        child: Stack(
          children:[StreamBuilder<List<Order>>(
              initialData: null,
              stream: _bloc.orderController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Data error"));
                }
                if (snapshot.hasData && snapshot.data == []) {
                        return Stack(children:[
                    Image.asset("assets/images/empty_cart.png",),
                    const Center(
                      child: Text(
                        'Oder Empty !',

                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color:  Color(0xFF91FF52),
                        ),
                      ),
                    ),
                  ],);
                }
                return  SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                      shrinkWrap: false,
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {

                        return _buildOrderDetail(snapshot.data?[index],context);
                      }),
                );
              }),
          ],),
      ),
    ),
      // LoadingWidget(
      //   bloc: _homeBloc,
      //   child: Container(),
      // )
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: LoadingWidget(
            bloc: _bloc,
            child: StreamBuilder<List<Order>>(
              initialData: null,
              stream: _bloc.orderController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Data is error"),
                  );
                }
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Stack(children:[
                    Image.asset("assets/images/empty_cart.png",),
                    const Center(
                      child: Text(
                        'Order Empty !',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color:  Color(0xFF91FF52),
                        ),
                      ),
                    ),
                  ],);
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) => itemList(snapshot.data?[index],context)
                      ),
                    ),

                  ],


                );
              },
            ),
          ),
        )
    );
  }

  Widget itemList (Order? orderModel, BuildContext context) {
    if (orderModel == null) return Container();
    return ListTile(
      title: Text(orderModel.date_created ??= ""),
      subtitle: Text(
          "Tổng Tiền : ${NumberFormat("#,###", "en_US")
                  .format(orderModel.price ??= 0) } đ",
          style: const TextStyle(fontSize: 12,),),

      trailing:  ElevatedButton(
        onPressed: () {

       setState(() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>_buildOrderDetail(orderModel, context) ));
    print('test chi tiết');
          });
          handleOrderButtonDetail();
          });
        },
        style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return const Color.fromARGB(
                    200, 240, 102, 61);
              } else {
                return const Color.fromARGB(
                    230, 240, 102, 61);
              }
            }),
            shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10))))),
        child: const Text("Chi Tiết",
            style: TextStyle(fontSize: 14)),
      ),
    );
  }
  Widget _buildOrderDetail(Order? orderModel, BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF3ac5c9),
      appBar: AppBar(
          backgroundColor: const Color(0xFFf85c34),
        title: const Center(child: Text('Order Detail')),
      ),
      body: SafeArea(

        child: SingleChildScrollView(
          child: Flex(
            direction: Axis.horizontal,
            children:[ Expanded(
              child: SizedBox(
                // width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                        //  crossAxisAlignment: CrossAxisAlignment.center,
                        // // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(
                              ApiConstant.baseUrl + (orderModel?.products?[0].img).toString(),
                              width: 400,
                              height: 300,
                              fit: BoxFit.fill),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text((orderModel?.products?[0].name).toString(),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.chewy(
                                fontSize: 24,
                                color: const Color(0xFFA22617),
                                textStyle:
                                Theme.of(context).textTheme.displayLarge,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text((orderModel?.products?[0].address).toString(),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.alike(
                                fontSize: 20,
                                textStyle:
                                Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical:5, ),
                            padding: const EdgeInsets.fromLTRB(80, 10, 80, 10),
                            decoration: const BoxDecoration(
                              color: Color(0xFF19E0E0), borderRadius:
                            BorderRadius.all(Radius.circular(30),),),
                            child: Text(
                                "Giá : ${NumberFormat("#,###", "en_US")
                                        .format(orderModel?.price)} đ",
                              style: GoogleFonts.amita(
                                fontSize: 20,
                                color: const Color(0xFFEFF5EF),
                                textStyle:
                                Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical:5, ),
                            padding: const EdgeInsets.fromLTRB(95, 10, 95, 10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFC91A1A),
                              borderRadius:
                              BorderRadius.all(Radius.circular(30),),),


                            child: Text(("Số Lượng: ${orderModel?.products?[0].quantity}").toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.amita(
                                fontSize: 20,
                                color: const Color(0xFFEFF5EF),
                                textStyle:
                                Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

