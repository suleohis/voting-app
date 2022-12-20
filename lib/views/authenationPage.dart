import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_app/authFunction.dart';
import 'package:voter_app/contants/colors.dart';
import 'package:pinput/pinput.dart';

import 'homePage.dart';
import '../contants/states.dart';

class AuthenationPage extends StatefulWidget {
  const AuthenationPage({Key? key}) : super(key: key);

  @override
  State<AuthenationPage> createState() => _AuthenationPageState();
}

class _AuthenationPageState extends State<AuthenationPage>
    with SingleTickerProviderStateMixin {
  bool switchOn = false;
  bool getOTP = false;
  bool fingerPrint = false;
  TabController? tabController;
  String selectedState = states[0];
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  int selectedIndex = 0;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController ninController = TextEditingController();
  String sexController = 'M';
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: borderColor),
    ),
  );

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: switchOn ? loginBackgroundDark : loginBackgroundLight,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Switch(
                  value: switchOn,
                  onChanged: (value) {
                    setState(() {
                      switchOn = value;
                    });
                  }),
              const Icon(Icons.map, size: 50),
              const SizedBox(
                height: 20,
              ),
              // if (!getOTP)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: selectedIndex == 0 ? 340 : 520,
                  width: 511,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                      color: switchOn
                          ? loginContainerColorDark
                          : loginContainerColorLight,
                      borderRadius: BorderRadius.circular(6)),
                  child: loginAndSignup(),
                ),
              )
              // else if (!fingerPrint)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
              //     child: Container(
              //       height: 400,
              //       width: 511,
              //       padding: const EdgeInsets.all(30),
              //       decoration: BoxDecoration(
              //           color: switchOn
              //               ? loginContainerColorDark
              //               : loginContainerColorLight,
              //           borderRadius: BorderRadius.circular(6)),
              //       child: otpWidget(),
              //     ),
              //   )
              // else
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
              //     child: Container(
              //       height: 400,
              //       width: 511,
              //       padding: const EdgeInsets.all(30),
              //       decoration: BoxDecoration(
              //           color: switchOn
              //               ? loginContainerColorDark
              //               : loginContainerColorLight,
              //           borderRadius: BorderRadius.circular(6)),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           const Text(
              //             'Finger Scanner',
              //             style: TextStyle(
              //               color: Color.fromRGBO(112, 112, 112, 1),
              //             ),
              //           ),
              //           const SizedBox(
              //             height: 20,
              //           ),
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Container(
              //                 width: 73,
              //                 height: 132,
              //                 decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(15)),
              //               ),
              //               Container(
              //                 width: 73,
              //                 height: 132,
              //                 decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(15)),
              //               ),
              //               Container(
              //                 width: 73,
              //                 height: 132,
              //                 decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(15)),
              //               ),
              //               Container(
              //                 width: 73,
              //                 height: 132,
              //                 decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(15)),
              //               ),
              //             ],
              //           ),
              //           const SizedBox(
              //             height: 20,
              //           ),
              //           const Text(
              //               'Please position your fingers on the scanner well If not scanning your prints kindly wet your palm and try again',
              //               style: TextStyle(
              //                 color: Color.fromRGBO(91, 91, 91, 1),
              //               )),
              //           Align(
              //             alignment: AlignmentDirectional.topEnd,
              //             child: TextButton(
              //               onPressed: () {},
              //               child: const Text(
              //                 'Go to previous page',
              //                 style: TextStyle(
              //                     color: Color.fromRGBO(54, 54, 226, 1)),
              //               ),
              //             ),
              //           ),
              //           const SizedBox(
              //             height: 60,
              //           ),
              //           Center(
              //             child: GestureDetector(
              //               onTap: () {
              //                 setState(() {
              //                   fingerPrint = false;
              //                   getOTP = false;
              //                 });
              //               },
              //               child: Container(
              //                 padding: const EdgeInsets.symmetric(
              //                     vertical: 10, horizontal: 20),
              //                 decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(7),
              //                     color: loginButtonColor),
              //                 child: const Text(
              //                   'Send',
              //                   style: TextStyle(
              //                       color: Colors.white, fontSize: 20),
              //                 ),
              //               ),
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   )
            ],
          ),
        ),
      ),
    );
  }

  Column otpWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'O T P',
          style: TextStyle(
            color: Color.fromRGBO(112, 112, 112, 1),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Pinput(
          controller: pinController,
          focusNode: focusNode,
          androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
          listenForMultipleSmsOnAndroid: true,
          defaultPinTheme: defaultPinTheme,
          validator: (value) {
            return value == '2222' ? null : 'Pin is incorrect';
          },
          // onClipboardFound: (value) {
          //   debugPrint('onClipboardFound: $value');
          //   pinController.setText(value);
          // },
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          onCompleted: (pin) {
            debugPrint('onCompleted: $pin');
          },
          onChanged: (value) {
            debugPrint('onChanged: $value');
          },
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 9),
                width: 22,
                height: 1,
                color: focusedBorderColor,
              ),
            ],
          ),
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: focusedBorderColor),
            ),
          ),
          submittedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              color: fillColor,
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: focusedBorderColor),
            ),
          ),
          errorPinTheme: defaultPinTheme.copyBorderWith(
            border: Border.all(color: Colors.redAccent),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
            'Type the digit sent to your phone number \nIf you did not receive an OTP press ',
            style: TextStyle(
              color: Color.fromRGBO(91, 91, 91, 1),
            )),
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Resend OTP',
              style: TextStyle(color: Color.fromRGBO(54, 54, 226, 1)),
            ),
          ),
        ),
        const SizedBox(
          height: 60,
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                fingerPrint = true;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: loginButtonColor),
              child: const Text(
                'Send',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        )
      ],
    );
  }

  Column loginAndSignup() {
    return Column(
      children: [
        Material(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Container(
            height: 45,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: TabBar(
              onTap: (value) {
                selectedIndex = value;
                setState(() {

                });
              },
              labelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 23,
              ),
              unselectedLabelStyle:
                  TextStyle(color: loginButtonColor, fontSize: 23),
              indicator: BoxDecoration(
                  color: loginButtonColor,
                  borderRadius: BorderRadius.circular(30)),
              unselectedLabelColor: loginButtonColor,
              labelColor: Colors.white,
              controller: tabController,
              tabs: const [
                Tab(
                  text: 'Login',
                ),
                Tab(
                  text: 'Sign Up',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: tabController,
            children: [
              Column(
                children: [
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: 'Enter Email Address'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () => login(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: loginButtonColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(hintText: 'Name'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 30,
                          child: TextField(
                            controller: ageController,
                            decoration: const InputDecoration(hintText: 'Age'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: DropdownButton(
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                              value: sexController,
                              items: genders.map((value) {
                                return DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  sexController = value.toString();
                                });
                              }),
                        ),
                        SizedBox(
                          width: 120,
                          child:
                          DropdownButton(
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                              value: selectedState,
                              items: states.map((value) {
                                return DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedState = value.toString();
                                });
                              }),
                        ),
                      ],
                    ),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(hintText: 'Phone number'),
                      maxLength: 11,
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: ninController,
                      maxLength: 11,
                      decoration: const InputDecoration(hintText: 'NIN number'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(hintText: 'Email Address'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(hintText: 'Password'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        signup();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: loginButtonColor),
                        child: const Text(
                          'Signup',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  bool isLoading = false;
  login() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });

    if ((emailController.text == '') || (passwordController.text == '')) {
      print('enter fields');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      auth
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) async {
        FirebaseAuth auth = FirebaseAuth.instance;
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get();
        pref.setString('name', doc['name']);
        pref.setString('min', doc['nin']);
        pref.setString('state', doc['state']);
        pref.setString('email', doc['email']);
        pref.setBool('logged_in', true);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomePage()));
      }).catchError((e) {
        String error = '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.';
        if (e.toString().contains(error)) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('This Account Do not Exist')));
        } else {

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Network Problems')));
        }
        print(e);
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login Failed')));
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  signup() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });

    if ((emailController.text == '') ||
        (passwordController.text == '') ||
        (nameController.text == '') ||
        (ageController.text == '') ||
        (phoneController.text == '') ||
        (ninController.text == '')) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You Must Fill All The Fields')));
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      signUpRequest(
          emailController.text,
          passwordController.text,
          nameController.text,
          ageController.text,
          selectedState,
          phoneController.text,
          ninController.text,
          sexController,
          context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login Failed')));
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }
}
