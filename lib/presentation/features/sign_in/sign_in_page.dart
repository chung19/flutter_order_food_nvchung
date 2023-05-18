import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../../common/bases/base_widget.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../common/utils/custom_textfield.dart';
import '../../../common/utils/extension.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../common/widgets/progress_listener_widget.dart';
import '../../../data/datasources/remote/api_request.dart';
import '../../../data/repositories/authentication_repository.dart';
import '../../resources/assets-manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import 'sign_in_bloc.dart';
import 'sign_in_event.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ebd60),
        title: const Center(child: Text('Sign In')),
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
      child: const SignInContainer(),
    );
  }
}

class SignInContainer extends StatefulWidget {
  const SignInContainer({super.key});

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
        showMessage(context, AppStrings.notify, event);
      });
    });
  }

  void handleButtonSignIn(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      showMessage(
          context, AppStrings.notify, AppStrings.doNotEnoughInformation);
      return;
    }
    if (password.length < 8) {
      showMessage(
          context, AppStrings.notify, AppStrings.passwordLengthError);
      return;
    }
    _bloc.eventSink.add(SignInEvent(email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(
                        flex: 2, child: Image.asset(ImageAssets.IcHelloFood)),
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
                                    handleButtonSignIn(emailController.text,
                                        passwordController.text);
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
              ),
            ),
            ProgressListenerWidget<SignInBloc>(
              callback: (event) {
                if (event is SignInSuccessEvent) {
                  Navigator.pushReplacementNamed(
                      context, VariableConstant.homeRoute);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(event.message)));
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
        margin: const EdgeInsets.only(
          bottom: AppMargin.m10,
          left: AppMargin.m10,
          right: AppMargin.m10,
        ),
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppPadding.p10),
                decoration: const BoxDecoration(
                    color: Color(0xff1b9696),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: const Text(AppStrings.doNotHaveAccount),
              ),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () async {
                  try {
                    var data = await Navigator.pushNamed(
                        context, VariableConstant.signUpRoute) as Map;
                    setState(() {
                      emailController.text = data['email'];
                      passwordController.text = data['password'];
                    });
                  } catch (e) {
                    showMessage(context, AppStrings.notify, e.toString());
                    return;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Color(0xFF3ac5c9),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: const Text(AppStrings.signUp,
                      style: TextStyle(
                        color: Color(0xFF536251),
                      )),
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildEmailTextField() {
    return CustomTextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      hintText: AppStrings.email,
      icon: const Icon(
        Icons.email,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return CustomTextField(
      controller: passwordController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.unspecified,
      hintText: AppStrings.password,
      obscureText: true, // enable (true) /disable hide password
      icon: const Icon(
        Icons.lock,
      ),
    );
  }

  Widget _buildButtonSignIn(Function onPress) {
    return Container(
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
              child: const Text(AppStrings.login,
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              onPressed: () => onPress(),
            )));
  }
}
