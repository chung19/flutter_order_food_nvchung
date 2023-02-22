import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_order_food_nvchung/common/bases/base_widget.dart';
import 'package:flutter_order_food_nvchung/common/utils/extension.dart';
import 'package:flutter_order_food_nvchung/presentation/features/sign_up/sign_up_bloc.dart';
import 'package:flutter_order_food_nvchung/presentation/features/sign_up/sign_up_event.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../common/widgets/progress_listener_widget.dart';
import '../../../data/datasources/remote/api_request.dart';
import '../../../data/repositories/authentication_repository.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ebd60),
        title: const Center(child: Text("Sign Up")),
      ),
      providers: [
        Provider(create: (context) => ApiRequest()),
        ProxyProvider<ApiRequest, AuthenticationRepository>(
          update: (context, request, repository) {
            repository?.updateRequest(request);
            return repository ?? AuthenticationRepository()
              ..updateRequest(request);
          },
        ),
        ProxyProvider<AuthenticationRepository, SignUpBloc>(
          update: (context, repository, bloc) {
            bloc?.updateRepository(repository);
            return bloc ?? SignUpBloc()
              ..updateRepository(repository);
          },
        ),
      ],
      child: const SignUpContainer(),
    );
  }
}

class SignUpContainer extends StatefulWidget {
  const SignUpContainer({Key? key}) : super(key: key);

  @override
  State<SignUpContainer> createState() => _SignUpContainerState();
}

class _SignUpContainerState extends State<SignUpContainer> {
  late TextEditingController emailController, phoneController, passwordController, addressController, nameController;
  late SignUpBloc _bloc;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    nameController = TextEditingController();
    passwordController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();

    _bloc = context.read<SignUpBloc>();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _bloc.messageStream.listen((event) {
        showMessage(context, "Thông báo", event);
      });
    });
  }

  void clickSignUp(String email, String name, String password, String address, String phone){
    List<String> listString = List.empty(growable: true)
                                  ..add(email)
                                  ..add(password)
                                  ..add(name)
                                  ..add(address)
                                  ..add(phone);
    if (isNotEmpty(listString)) {
      _bloc.eventSink.add(SignUpEvent(email: email, password: password, name: name, phone: phone, address: address));
    } else {
      showMessage(context, "Thông báo", "Bạn chưa nhập đủ thông tin");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              flex: 2, child: Image.asset("assets/images/ic_hello_food.png")),
          Expanded(
              flex: 4,
              child: LayoutBuilder(
                builder: (context, constraint) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                      BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildNameTextField(nameController),
                                const SizedBox(height: 10),
                                _buildAddressTextField(addressController),
                                const SizedBox(height: 10),
                                _buildEmailTextField(emailController),
                                const SizedBox(height: 10),
                                _buildPhoneTextField(phoneController),
                                const SizedBox(height: 10),
                                _buildPasswordTextField(passwordController),
                                const SizedBox(height: 10),
                                _buildButtonSignUp(() {
                                  clickSignUp(emailController.text, nameController.text, passwordController.text, addressController.text, phoneController.text);
                                })
                              ],
                            ),
                            ProgressListenerWidget<SignUpBloc>(
                              callback: (event) {
                                if (event is SignUpSuccessEvent) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event.message)));
                                  Navigator.pop(context, {"email": event.email, "password": event.password});
                                }
                              },
                              child: Container(),
                            ),
                            LoadingWidget(
                              bloc: _bloc,
                              child: Container(),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget _buildNameTextField(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Example : Mr. John",
          fillColor: Colors.black12,
          filled: true,
          prefixIcon: const Icon(Icons.person, color: Colors.blue),
          labelStyle: const TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
        ),
      ),
    );
  }

  Widget _buildAddressTextField(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Example : district 1",
          fillColor: Colors.black12,
          filled: true,
          prefixIcon: const Icon(Icons.map, color: Colors.blue),
          labelStyle: const TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
        ),
      ),
    );
  }

  Widget _buildEmailTextField(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Email : abc@gmail.com",
          fillColor: Colors.black12,
          filled: true,
          prefixIcon: const Icon(Icons.email, color: Colors.blue),
          labelStyle: const TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
        ),
      ),
    );
  }

  Widget _buildPhoneTextField(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: controller,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Phone ((+84) 123 456 789)",
          fillColor: Colors.black12,
          filled: true,
          labelStyle: const TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          prefixIcon: const Icon(Icons.phone, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: controller,
        obscureText: true,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: "Pass word",
          fillColor: Colors.black12,
          filled: true,
          labelStyle: const TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          prefixIcon: const Icon(Icons.lock, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildButtonSignUp(Function()? function) {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        child: ElevatedButtonTheme(
            data: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.blue[500];
                    } else if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return Colors.blueAccent;
                  }),
                  elevation: MaterialStateProperty.all(5),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 100)),
                )),
            child: ElevatedButton(
              onPressed: function,
              child: const Text("Register",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            )));
  }
}
