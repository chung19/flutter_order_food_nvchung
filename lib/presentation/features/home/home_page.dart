import 'dart:math';
import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_order_food_nvchung/common/bases/base_widget.dart';
import 'package:flutter_order_food_nvchung/data/model/product.dart';
import 'package:flutter_order_food_nvchung/data/repositories/cart_repository.dart';
import 'package:flutter_order_food_nvchung/data/repositories/product_repository.dart';
import 'package:flutter_order_food_nvchung/presentation/features/home/home_bloc.dart';
import 'package:flutter_order_food_nvchung/presentation/features/home/home_event.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/constants/api_constant.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../common/utils/extension.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../data/datasources/remote/api_request.dart';
import '../../../data/model/cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> handleButtonSignOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    showDialog(
        context: context,
        builder: (_)
    {
      return AlertDialog(
        actions: [
          Row(

            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  )),
              TextButton(
                onPressed: () {
                  preferences.clear();
                  print('log out ');
                  // Navigator.pushNamed(context, "/sign_in");

                  Navigator.pushReplacementNamed(
                      context, VariableConstant.signInRoute);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  padding: const EdgeInsets.fromLTRB(8, 10, 4, 10),
                  decoration: const BoxDecoration(
                      color: Color(0xFFF10808),
                      borderRadius:
                      BorderRadius.all(Radius.circular(30))),
                  child: Text(" Do You Want Quit Now ! ", style: GoogleFonts.antonio(
                    color: const Color(0xFFF1F5F1),
                  ),),
                ),),
            ],
          ),
        ],


      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ebd60),
        title: const Center(child: Text("Home")),
        leading: IconButton(
          icon: Tab(icon: Image.asset("assets/images/boy.png",height:50,fit: BoxFit.fill,), ),iconSize: 2,
          onPressed: () {
            handleButtonSignOut();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/order");
              },
              icon: const Icon(Icons.history)),
          Consumer<HomeBloc>(
            builder: (context, bloc, child) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/cart").then((cartModelUpdate) {
                    if (cartModelUpdate != null) {
                      bloc.cartController.sink.add(cartModelUpdate as Cart);
                    }
                  });
                },
                child: StreamBuilder<Cart>(
                    initialData: null,
                    stream: bloc.cartController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Container();
                      }
                      String? count =
                          snapshot.data?.products?.length.toString();
                      if (count == null || count.isEmpty || count == "0") {
                        return Container(
                          margin: const EdgeInsets.only(right: 10, top: 10),
                          child: Icon(Icons.shopping_cart_outlined),
                        );
                      } else {
                        return Container(
                          margin: const EdgeInsets.only(right: 10, top: 10),
                          child: Badge(
                            badgeContent: Text(count),
                            child: Icon(Icons.shopping_cart_outlined),
                          ),
                        );
                      }
                    }),
              );
            },
          )
        ],

      ),
      providers: [
        Provider(create: (context) => ApiRequest()),
        Provider(create: (context) => CartRepository()),
        ProxyProvider<ApiRequest, ProductRepository>(
          update: (context, request, repository) {
            repository?.updateRequest(request);
            return repository ?? ProductRepository()
              ..updateRequest(request);
          },
        ),
        ProxyProvider2<ProductRepository, CartRepository, HomeBloc>(
          update: (context, productRepo, cartRepo, bloc) {
            bloc?.updateProductRepository(
                productRepository: productRepo, cartRepository: cartRepo);
            return bloc ?? HomeBloc()
              ..updateProductRepository(
                  productRepository: productRepo, cartRepository: cartRepo);
          },
        ),
      ],
      child: HomeContainer(),
    );
  }
}

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();

    _homeBloc = context.read<HomeBloc>();
    _homeBloc.eventSink.add(GetListProductEvent());
    _homeBloc.eventSink.add(FetchCartEvent());
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        _homeBloc.messageStream.listen((event) {
          showMessage(context, "Thông Báo", event);
        });
      },
    );
  }

  void addCart(String idProduct) {
    _homeBloc.eventSink.add(AddCartEvent(idProduct: idProduct));
  }

  void handleButtonDetail(Product product, BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            actions: [
            Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      )),
                  TextButton(
                      onPressed: () {
                        addCart(product.id);
                        Navigator.pop(context);
                      },
                      child:    Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      padding: const EdgeInsets.fromLTRB(8, 10, 4,10),
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF0783EC),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(30))),
                                      child: Text("Buy Now ",style:GoogleFonts.antonio(
                                      color: Color(0xFFF1F5F1),
                                    ) ,),
                                  ),),
              ],
            ),
            ],
            title: Text(
              product.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.chewy(
                fontSize: 24,
                color: const Color(0xFFA22617),
                textStyle:
                Theme.of(context).textTheme.displayLarge,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    margin: const EdgeInsets.only(top: 10),
                  ),
                  CarouselSlider(
                    items: product.gallery
                        .map((e) => Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                          "https://serverappsale.herokuapp.com/$e",
                          fit: BoxFit.cover,
                          width: 1000,
                        ),
                            )))
                        .toList(),
                    options: CarouselOptions(
                      // height: 400,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
            const SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    padding: const EdgeInsets.fromLTRB(14, 2, 14, 2),
                    decoration: const BoxDecoration(
                        color: Colors.teal,
                        borderRadius:
                        BorderRadius.all(Radius.circular(50))),
                    child: Text(
                      "Price : ${NumberFormat("#,###", "en_US").format(product.price)} đ",
                      style: GoogleFonts.amita(
                        fontSize: 20,
                        color: const Color(0xFFEFF5EF),
                        textStyle:
                        Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    padding: const EdgeInsets.fromLTRB(23.8, 2, 23.8,2),
                    decoration: const BoxDecoration(
                        color: Color(0xFFC91A1A),
                        borderRadius:
                        BorderRadius.all(Radius.circular(30))),
                    child: Text(
                      'Quantity : 99+',
                      maxLines: 1,
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
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: SizedBox(
      child: Stack(
        children: [

          StreamBuilder<List<Product>>(
              initialData: const [],
              stream: _homeBloc.listProductController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Stack(
                    children: [
                      Image.asset(
                        "assets/images/opps.png",
                      ),
                      const Center(
                        child: Text(
                          'Product is Err!',
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
                if (snapshot.hasData && snapshot.data == []) {
                  return Stack(
                    children: [
                      Image.asset(
                        "assets/images/empty_cart.png",
                      ),
                      const Center(
                        child: Text(
                          'Product Empty!',
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
                return ListView.builder(

                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      // return _buildSlider(snapshot.data?[index], context);
                      return _buildItemFood(snapshot.data?[index]);
                    });
              }),
          LoadingWidget(
            bloc: _homeBloc,
            child: Container(),
          )
        ],
      ),
    ));
  }

  Widget _buildItemFood(Product? product) {
    if (product == null) return Container();
    return SizedBox(
      height: 135,
      child: Card(
        elevation: 5,
        // shadowColor: Colors.blueGrey,
        child: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                    ApiConstant.baseUrl + (product?.img).toString(),
                    width: 150,
                    height: 120,
                    fit: BoxFit.fill),
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
                        child: Text(product.name.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16)),
                      ),
                      Text(
                        "Giá : ${NumberFormat("#,###", "en_US").format(product.price)} đ",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        ElevatedButton(
                          onPressed: () {
                            print('test add cart');
                            _homeBloc.eventSink
                                .add(AddCartEvent(idProduct: product.id));
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return const Color.fromARGB(
                                      188, 157, 201, 10);
                                } else {
                                  return const Color.fromARGB(
                                      230, 240, 102, 61);
                                }
                              }),
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))))),
                          child: const Text("Thêm vào giỏ",
                              style: TextStyle(fontSize: 14)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                              handleButtonDetail(product, context);
                                },);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return const Color.fromARGB(
                                        200, 11, 22, 142);
                                  } else {
                                    return const Color.fromARGB(
                                        230, 11, 22, 142);
                                  }
                                }),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))))),
                            child: Text("Chi tiết",
                                style: const TextStyle(fontSize: 14)),
                          ),
                        ),
                      ]),
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

  Widget _buildSlider(
    Product? product,
    BuildContext context,
  ) {
    // double height = MediaQuery.of(context).size.height;
    //  double width = MediaQuery.of(context).size.width;

    final random = Random();
    if (product == null) return Container();

    return Scaffold(
      // backgroundColor: const Color(0xFF3ac5c9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf85c34),
        title: const Center(child: Text('Home Detail')),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Flex(direction: Axis.horizontal, children: [
            Expanded(
              child: SizedBox(
                // width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Flexible(
                            child: FractionallySizedBox(
                              heightFactor: 0.03,
                            ),
                          ),
                          Image.network(
                              ApiConstant.baseUrl + (product?.img).toString(),
                              width: double.infinity,
                              height: 100,
                              fit: BoxFit.fill),
                          const Flexible(
                            child: FractionallySizedBox(
                              heightFactor: 0.09,
                            ),
                          ),
                          Text(
                            product.name.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.chewy(
                              fontSize: 24,
                              color: Color(0xFFA22617),
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                          const Flexible(
                            child: FractionallySizedBox(
                              heightFactor: 0.39,
                            ),
                          ),
                          CarouselSlider.builder(
                            itemCount:
                                product.gallery[random.nextInt(3)].length,
                            itemBuilder: (BuildContext context, int itemIndex,
                                    int pageViewIndex) =>
                                ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                ApiConstant.baseUrl +
                                    product.gallery[random.nextInt(3)],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 50,
                              ),
                            ),
                            options: CarouselOptions(
                                // height: 150.0,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 16 / 9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                // aspectRatio: 16/9,
                                // viewportFraction: 1,

                                onPageChanged: (index, reason) {
                                  setState(() {});
                                }),
                          ),
                          const Flexible(
                            child: FractionallySizedBox(
                              heightFactor: 0.09,
                            ),
                          ),
                          Text(
                            product.address.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.alike(
                              fontSize: 20,
                              textStyle:
                                  Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                          const Flexible(
                            child: FractionallySizedBox(
                              heightFactor: 0.09,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            padding: const EdgeInsets.fromLTRB(80, 10, 80, 10),
                            decoration: const BoxDecoration(
                                color: Color(0xFFC91A1A),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30),),),
                            child: Text(
                              'Số Lượng : 99+',
                              maxLines: 1,
                              style: GoogleFonts.amita(
                                fontSize: 20,
                                color: const Color(0xFFEFF5EF),
                                textStyle:
                                    Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                          ),
                          const Flexible(
                            child: FractionallySizedBox(
                              heightFactor: 0.09,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            padding: const EdgeInsets.fromLTRB(80, 10, 80, 10),
                            decoration: const BoxDecoration(
                                color: Colors.teal,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Text(
                              "Giá : ${NumberFormat("#,###", "en_US").format(product.price)} đ",
                              style: GoogleFonts.amita(
                                fontSize: 20,
                                color: const Color(0xFFEFF5EF),
                                textStyle:
                                    Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                          ),
                          const Flexible(
                            child: FractionallySizedBox(
                              heightFactor: 0.49,
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
