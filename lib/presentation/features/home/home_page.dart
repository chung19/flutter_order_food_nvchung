import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/bases/base_widget.dart';
import '../../../common/constants/api_constant.dart';
import '../../../common/constants/style_constant.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../common/utils/extension.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../data/datasources/remote/api_request.dart';
import '../../../data/model/cart.dart';
import '../../../data/model/product.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../../plugin/slider_banner.dart';
import '../../resources/assets-manager.dart';
import '../../resources/strings_manager.dart';
import 'child_home_widget/button_base.dart';
import 'home_bloc.dart';
import 'home_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var gallery = ApiConstant.baseUrl;
  @override
  void initState() {
    super.initState();

  }

  Future<void> handleButtonSignOut() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if(context.mounted){
      return showDialog(
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
                          AppStrings.cancel,
                          style: TextStyle(color: Colors.grey[400], fontSize: 16),
                        )),
                    TextButton(
                      onPressed: () {
                        preferences.clear();
                        preferences.setBool('firstRun', false);
                        print(AppStrings.logout);

                        Navigator.pushNamedAndRemoveUntil(
                            context, VariableConstant.signInRoute, (route) => false);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        padding: const EdgeInsets.fromLTRB(8, 10, 4, 10),
                        decoration: const BoxDecoration(
                            color: Color(0xFFF10808),
                            borderRadius: BorderRadius.all(Radius.circular(30))),
                        child: Text(
                          AppStrings.quit,
                          style: GoogleFonts.antonio(
                            color: const Color(0xFFF1F5F1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ebd60),
        title: const Center(
          child: Text('Home'),
        ),
        leading: IconButton(
          icon: Image.asset(
            ImageAssets.avatar,
            height: 50,
            fit: BoxFit.fill,
          ),
          onPressed: () {
            setState(
              () {
                handleButtonSignOut();
              },
            );
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/order');
              },
              icon: const Icon(Icons.history)),
          Consumer<HomeBloc>(
            builder: (context, bloc, child) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/cart').then((cartModelUpdate) {
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
                        return const SizedBox.shrink();
                      }
                      final String? count =
                          snapshot.data?.products?.length.toString();
                      if (count == null || count.isEmpty || count == '0') {
                        return Container(
                          margin: const EdgeInsets.only(right: 10, top: 10),
                          child: const Icon(Icons.shopping_cart_outlined),
                        );
                      } else {
                        return Container(
                          margin: const EdgeInsets.only(right: 10, top: 18),
                          child: Badge(
                            label: Text(count),
                            child: const Icon(Icons.shopping_cart_outlined),
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
      child: const HomeContainer(),
    );
  }
}

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});
  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  late ScrollController _scrollController;
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = context.read<HomeBloc>();
    _homeBloc.eventSink.add(GetListProductEvent());
    _homeBloc.eventSink.add(FetchCartEvent());
    _scrollController = ScrollController();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        _homeBloc.messageStream.listen((event) {
          showMessage(context, AppStrings.notify, event);
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
                      child: const Text(
                        AppStrings.cancel,
                        style: handleButtonDetailCanelTextStyle,
                      )),
                  TextButton(
                    onPressed: () {
                      handleButtonDetail(product, context);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.fromLTRB(4, 5, 2, 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFA22617),
                        border: Border.all(
                          color: Colors.purple,
                          width: 2,
                        ),
                      ),
                      child: const Text(AppStrings.buy,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w200,
                          )),
                    ),
                  ),
                ],
              ),
            ],
            title: Text(
              product.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.chewy(
                fontSize: 24,
                color: const Color(0xFFA22617),
                textStyle: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
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
                                '${ApiConstant.baseUrl}$e',
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
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.purple,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      "\$ : ${NumberFormat("#,###", "en_US").format(product.price)} VND",
                      style: GoogleFonts.amita(
                        fontSize: 20,
                        color: const Color(0xFFB41CD1),
                        fontWeight: FontWeight.w900,
                        textStyle: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    padding: const EdgeInsets.fromLTRB(23.8, 2, 23.8, 2),
                    decoration: const BoxDecoration(
                        color: Color(0xFFC91A1A),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Text(
                      'Quantity : 99+',
                      maxLines: 1,
                      style: GoogleFonts.amita(
                        fontSize: 20,
                        color: const Color(0xFFEFF5EF),
                        textStyle: Theme.of(context).textTheme.displaySmall,
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
        child: Container(
      child: Stack(
        children: [
          ListView(children: [
            const SliderBanner(),
            StreamBuilder<List<Product>>(
                initialData: const [],
                stream: _homeBloc.listProductController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Stack(
                      children: [
                        Image.asset(
                          ImageAssets.Opps,
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
                    return Column(
                      children: [
                        Image.asset(
                          ImageAssets.EmptyCart,
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

                  return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return _buildItemFood(snapshot.data?[index]);
                      });
                }),
          ]),
          LoadingWidget(
            bloc: _homeBloc,
            child: Container(),
          )
        ],
      ),
    ));
  }

  Widget _buildItemFood(Product? product) {
    if (product == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      child: Card(
        elevation: 5,
        shadowColor: Colors.blueGrey,
        child: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                    ApiConstant.baseUrl + (product?.img).toString(),
                    width: 160,
                    height: 90,
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
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.purple,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            '\$: ${NumberFormat("#,###", "en_US").format(product.price)} VND',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MyCustomButton(
                            onPressed: () {
                              _homeBloc.eventSink
                                  .add(AddCartEvent(idProduct: product.id));
                            }, // Nội dung của button
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color.fromARGB(188, 157, 201, 10);
                              }
                              return const Color.fromARGB(230, 240, 102, 61);
                            }),
                            child: const Text(AppStrings.addCart,
                                style: TextStyle(fontSize: 10)),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          MyCustomButton(
                            onPressed: () {
                              setState(
                                () {
                                  handleButtonDetail(product, context);
                                },
                              );
                            }, // Nội dung của button
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color.fromARGB(230, 11, 22, 142);
                              }
                              return const Color.fromARGB(200, 11, 22, 142);

                              /// Màu sắc mặc định
                            }),
                            child: const Text(
                              AppStrings.detail,
                              style: TextStyle(fontSize: 10),
                            ),
                          )
                        ],
                      ),
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
