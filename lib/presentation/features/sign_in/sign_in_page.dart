import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_order_food_nvchung/common/bases/base_widget.dart';
import 'package:flutter_order_food_nvchung/common/constants/variable_constant.dart';
import 'package:flutter_order_food_nvchung/common/widgets/progress_listener_widget.dart';
import 'package:flutter_order_food_nvchung/data/datasources/remote/api_request.dart';
import 'package:flutter_order_food_nvchung/data/repositories/authentication_repository.dart';
import 'package:flutter_order_food_nvchung/presentation/features/sign_in/sign_in_bloc.dart';
import 'package:flutter_order_food_nvchung/presentation/features/sign_in/sign_in_event.dart';
import 'package:provider/provider.dart';

import '../../../common/utils/extension.dart';
import '../../../common/widgets/loading_widget.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        title: const Text("Sign In"),
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
        ProxyProvider<AuthenticationRepository, SignInBloc>(
          update: (context, repository, bloc) {
            bloc?.updateRepository(repository);
            return bloc ?? SignInBloc()
              ..updateRepository(repository);
          },
        ),
      ],
      child: SignInContainer(),
    );
  }
}

class SignInContainer extends StatefulWidget {
  const SignInContainer({Key? key}) : super(key: key);

  @override
  State<SignInContainer> createState() => _SignInContainerState();
}

class _SignInContainerState extends State<SignInContainer> {
  late SignInBloc _bloc;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = context.read<SignInBloc>();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _bloc.messageStream.listen((event) {
        showMessage(context, "Thông báo", event);
      });
    });
  }

  void handleButtonSignIn(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      showMessage(context, "Thông báo", "Bạn chưa nhập đủ thông tin");
      return;
    }
    _bloc.eventSink.add(SignInEvent(email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    flex: 2, child: Image.asset("assets/images/ic_hello_food.png")),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildEmailTextField(),
                        _buildPasswordTextField(),
                        StreamBuilder<bool>(
                          stream: _bloc.loadingStream,
                          initialData: false,
                          builder: (context, snapshot) {
                            return IgnorePointer(
                              ignoring: snapshot.data ?? false,
                              child: _buildButtonSignIn(() {
                                handleButtonSignIn(emailController.text, passwordController.text);
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: _buildTextSignUp())
              ],
            ),
            ProgressListenerWidget<SignInBloc>(
              callback: (event) {
                if (event is SignInSuccessEvent) {
                  Navigator.pushReplacementNamed(context, VariableConstant.homeRoute);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event.message)));
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
    );
  }

  Widget _buildTextSignUp() {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account!"),
            InkWell(
              onTap: () async{
                try {
                  var data = await Navigator.pushNamed(context, VariableConstant.signUpRoute) as Map;
                  setState(() {
                    emailController.text = data["email"];
                    passwordController.text = data["password"];
                  });
                } catch (e) {
                  showMessage(context, "Thông báo", e.toString());
                  return;
                }
              },
              child: Text("Sign Up",
                  style: TextStyle(
                      color: Colors.red, decoration: TextDecoration.underline)),
            )
          ],
        ));
  }

  Widget _buildEmailTextField() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          hintText: "Email",
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          prefixIcon: Icon(Icons.email, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        obscureText: true,
        controller: passwordController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          hintText: "PassWord",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          labelStyle: TextStyle(color: Colors.blue),
          prefixIcon: Icon(Icons.lock, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildButtonSignIn(Function onPress) {
    return Container(
        margin: EdgeInsets.only(top: 20),
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
                  EdgeInsets.symmetric(vertical: 5, horizontal: 100)),
            )),
            child: ElevatedButton(
              child: Text("Login",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              onPressed: () => onPress(),
            )));
  }
}
