import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../common/bases/base_widget.dart';
import '../../../common/constants/api_constant.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../common/utils/extension.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../common/widgets/progress_listener_widget.dart';
import '../../../data/datasources/remote/api_request.dart';
import '../../../data/model/cart.dart';
import '../../../data/model/product.dart';
import '../../../data/repositories/cart_repository.dart';
import 'cart_bloc.dart';
import 'cart_event.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      providers: [
        Provider(create: (context) => ApiRequest()),
        ProxyProvider<ApiRequest, CartRepository>(
          update: (context, request, repository) {
            repository?.updateRequest(request);
            return repository ?? CartRepository()
              ..updateRequest(request);
          },
        ),
        ProxyProvider<CartRepository, CartBloc>(
          update: (context, repository, bloc) {
            bloc?.updateRepository(cartRepository: repository);
            return bloc ?? CartBloc()
              ..updateRepository(cartRepository: repository);
          },
        ),
      ],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ebd60),
        title: const Center(child: Text("Cart")),
      ),
      child: const CartContainer(),
    );
  }
}

class CartContainer extends StatefulWidget {
  const CartContainer({Key? key}) : super(key: key);

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {
  Cart? _cart;
  late CartBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
    _bloc.eventSink.add(FetchCartEvent());

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _bloc.messageStream.listen((event) {
        showMessage(context, "Thông báo", event);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _cart);
        return true;
      },
      child: LoadingWidget(
        bloc: _bloc,
        child: Center(
          child: StreamBuilder<Cart>(
            stream: _bloc.cartController.stream,
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              if (snapshot.hasData) {
                _cart = snapshot.data;
                if (snapshot.data == null || snapshot.data!.products!.isEmpty) {
                  return Stack(
                    children: [
                      Image.asset(
                        "assets/images/empty_cart.png",
                      ),
                      const Center(
                        child: Text(
                          'Cart Empty !',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF91FF52),
                          ),
                        ),
                      ),

                    ],
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data?.products?.length,
                          itemBuilder: (lstContext, index) =>
                              _buildItem(snapshot.data?.products?[index])),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text(
                            "Tổng tiền : ${NumberFormat("#,###", "en_US").format(_cart?.price)} đ",
                            style: const TextStyle(
                                fontSize: 25, color: Colors.white))),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      child:  ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text(
                                    "Đặt hàng?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                  ),
                                  content: Text(
                                      "Quý khách sẽ thanh toán ${NumberFormat("#,###", "en_US").format(_cart?.price)} đồng cho các món ăn trên"),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: Text(
                                          "Hủy",
                                          style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 16),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          if (_cart != null) {
                                            String idCart = _cart!.id ??= "";
                                            _bloc.eventSink.add(CartConform(
                                              idCart: idCart,
                                            ));
                                             print('p');
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text("Thanh toán",
                                            style: TextStyle(
                                                color: Colors.red[400],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))),
                                  ],
                                );
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text(
                          "Thanh toán",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    ProgressListenerWidget<CartBloc>(
                      callback: (event) {
                        if (event is CartConFormSuccessEvent) {
                          Navigator.pushReplacementNamed(context, VariableConstant.homeRoute);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event.message)));
                        }
                      },
                      child: Container(),
                    ),

                  ],
                );
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItem(Product? product) {
    return SizedBox(
      height: 170,
      child: Card(
        elevation: 5,
        shadowColor: Colors.blueGrey,
        child: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                      ApiConstant.baseUrl + (product?.img).toString(),
                      width: 150,
                      height: 155,
                      fit: BoxFit.fill),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text((product?.name).toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16)),
                      ),
                      Text(
                          "Giá : ${NumberFormat("#,###", "en_US")
                                  .format(product?.price)} đ",
                          style: const TextStyle(fontSize: 12)),

                      Center(
                        child: ElevatedButton(

                          onPressed: () {
                            if (product != null && _cart != null) {
                              String cartId = _cart!.id ??= "";
                              if (cartId.isNotEmpty) {
                                _bloc.eventSink.add(UpdateCartEvent(
                                    idCart: cartId,
                                    idProduct: product.id,
                                    quantity: product.quantity - product.quantity  as int));
                              }
                            }
                          }, style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Background color
                        ),

                          child: const Icon(FontAwesomeIcons.trashCan,
                            color: Colors.black54, //<-- SEE HERE
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          ElevatedButton(
                            onPressed: () {
                              if (product != null && _cart != null) {
                                String? cartId = _cart?.id;
                                if (cartId?.isNotEmpty == true) {
                                  _bloc.eventSink.add(UpdateCartEvent(
                                      idCart: cartId!,
                                      idProduct: product.id,
                                      quantity: product.quantity - 1 as int));
                                }
                              }
                            },style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Background color
                          ),
                            child: const Icon(FontAwesomeIcons.minus,
                              color: Colors.black54, //<-- SEE HERE
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text((product?.quantity).toString(),
                                style: const TextStyle(fontSize: 16)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (product != null && _cart != null) {
                                String cartId = _cart!.id ??= "";
                                if (cartId.isNotEmpty) {
                                  _bloc.eventSink.add(UpdateCartEvent(
                                      idCart: cartId,
                                      idProduct: product.id,
                                      quantity: product.quantity + 1 as int));
                                }
                              }
                            },style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Background color
                          ),
                           child: const Icon(FontAwesomeIcons.plus,
                            color: Colors.black54, //<-- SEE HERE
                          ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
