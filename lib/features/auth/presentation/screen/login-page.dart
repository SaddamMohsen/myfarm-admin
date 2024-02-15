//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import 'package:myfarmadmin/features/auth/application/supabase_auth_provider.dart';
import 'package:myfarmadmin/features/auth/domain/entities/user.dart';
//import 'package:myfarm/utilities/constants.dart';
//import 'package:myfarm/utilities/form_model.dart';
// import 'package:reactive_forms/reactive_forms.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  // final ImageProvider image = const AssetImage('assets/images/mag8.jpg');
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  late ColorScheme currentColorScheme;

  TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late UserEntity user;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  String? validateEmail(String? value) {
    RegExp emailRegex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return value!.isNotEmpty && !emailRegex.hasMatch(value)
        ? 'الايميل غير صحيح'
        : value.isEmpty
            ? 'يجب كتابة البريد الالكتروني'
            : null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passController.dispose();
    //formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
        authControllerProvider,
        (_, state) => state.when(
              error: (error, stackTrace) {
                setState(() {
                  isLoading = false;
                });

                showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: Icon(
                      Icons.warning,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: const Text('خطأ'),
                    content: Text(
                      'البيانات المدخله غير صحيحة\nيرجى إعادة المحاولة\n ${error.toString()}\n',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    actions: <Widget>[
                      Center(
                        child: ElevatedButton(
                            child: const Text('موافق'),
                            onPressed: () => {
                                  Navigator.of(context).pop(),
                                }),
                      ),
                    ],
                  ),
                );
              },
              data: (data) => data != null
                  ? {
                      user = data,
                      setState(() {
                        isLoading = false;
                      }),
                      if (user.id.isNotEmpty) context.go('/home')
                    }
                  : '',
              loading: () => setState(() {
                isLoading = true;
              }),
            ));
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        //appBar: appBar(context, 'تسجيل الدخول'),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 350),
            //height: MediaQuery.of(context).size.height * 0.1,
            decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage('assets/images/mag6.jpg'),
                repeat: ImageRepeat.noRepeat,
                fit: BoxFit.cover,
                //scale: 0.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                //color: Theme.of(context).colorScheme.surfaceTint,
                decoration: const BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.black54, Colors.black])),
                height: MediaQuery.of(context).size.height * 0.6,
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          // margin: const EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 90,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 5.0),

                          ///Email Field
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextFormField(
                              textDirection: TextDirection.rtl,
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              validator: validateEmail,
                              decoration: InputDecoration(
                                // labelText: "البريد الالكتروني",
                                label: Container(
                                  margin:
                                      EdgeInsets.only(bottom: 5.0, right: 10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white38,
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.only(right: 15.0),
                                  child: Text(
                                    "البريد الالكتروني",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      //backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      style: BorderStyle.solid,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(24),
                                  ),
                                ),
                                prefixIcon: const Icon(Icons.email),
                                errorStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    backgroundColor:
                                        Color.fromARGB(255, 21, 20, 24)),
                                contentPadding: const EdgeInsets.only(top: 0.0),
                                hintText: "البريد الالكتروني",

                                // fillColor: Colors.white10,
                                focusColor: Colors.white,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(24),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(24),
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(24),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        ///Password Field
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 90.0,
                          padding: const EdgeInsets.only(
                              left: 50.0, top: 5.0, right: 50.0),
                          child: Stack(fit: StackFit.expand, children: [
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              obscureText: !showPassword,
                              validator: (String? value) {
                                return value!.isEmpty
                                    ? 'لا يمكن الدخول بدون كتابة كلمة المرور'
                                    : null;
                              },
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(24),
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(24),
                                  ),
                                ),
                                errorStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    backgroundColor:
                                        Color.fromARGB(255, 21, 20, 24)),
                                label: Container(
                                  margin:
                                      EdgeInsets.only(bottom: 5.0, right: 10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white38,
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.only(right: 15.0),
                                  child: Text(
                                    "كلمة المرور",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      //backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      style: BorderStyle.solid,
                                      color:
                                          Theme.of(context).colorScheme.error),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(showPassword == false
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                ),
                                prefixIcon: const Icon(Icons.lock),
                                contentPadding: const EdgeInsets.only(top: 0.0),
                                //hintText: "كلمة السر",
                                focusColor: Colors.white,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                              controller: passController,
                              obscuringCharacter: "*",
                            ),
                            // Positioned(
                            //     right: -5,
                            //     top: 0,
                            //     child: IconButton(
                            //       icon: Icon(showPassword == false
                            //           ? Icons.visibility
                            //           : Icons.visibility_off),
                            //       onPressed: () {
                            //         setState(() {
                            //           showPassword = !showPassword;
                            //         });
                            //       },
                            //     )),
                          ]),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxHeight: 60, maxWidth: 100),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 60,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    //textDirection: TextDirection.rtl,
                                    children: [
                                      Expanded(
                                        ///if is loading is false then show login button
                                        child: !isLoading
                                            ? ElevatedButton(
                                                onPressed: () => {
                                                  if (formKey.currentState!
                                                              .validate() ==
                                                          false ||
                                                      passController
                                                          .text.isEmpty)
                                                    {
                                                      if (emailController
                                                          .value.text.isEmpty)
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        ' تأكد من كتابة البريد الالكتروني بشكل صحيح ')))
                                                      else if (passController
                                                          .value.text.isEmpty)
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'تأكد من كتابة كلمة المرور')))
                                                      else
                                                        {}
                                                    }
                                                  else
                                                    {
                                                      ref
                                                          .read(
                                                              authControllerProvider
                                                                  .notifier)
                                                          .login(
                                                              emailController
                                                                  .text,
                                                              passController
                                                                  .text),
                                                    },
                                                },
                                                child:
                                                    const Text("تسجيل الدخول"),
                                              )

                                            /// else show loading button with icon
                                            : ElevatedButton.icon(
                                                icon: Icon(Icons.login,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground),
                                                onPressed: () {},
                                                label: const Text(
                                                  ".جاري تسجيل الدخول",
                                                  style: TextStyle(fontSize: 7),
                                                  // softWrap: false,
                                                ),
                                              ),
                                      ),
                                      if (isLoading) ...[
                                        const SizedBox(width: 2),
                                        const CircularProgressIndicator()
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
