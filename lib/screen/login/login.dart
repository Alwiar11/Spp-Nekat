import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sppnekat/shared/auth_service.dart';
import 'package:sppnekat/shared/button.dart';
import 'package:sppnekat/shared/textfield_login.dart';
import '../../shared/size.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isShow = true;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Masuk',
          style: TextStyle(
              fontFamily: "Herme", letterSpacing: 1, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: Sizes(context).width * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Masuk',
                      style: TextStyle(
                        fontFamily: 'Herme',
                        letterSpacing: 1,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Silahkan isi email dan password anda .',
                    style: TextStyle(
                        fontFamily: 'Herme', fontSize: 14, letterSpacing: 1),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              SizedBox(
                height: Sizes(context).width * 0.1,
              ),
              TextFieldCustom(
                label: 'Email',
                controller: emailController,
                type: TextInputType.emailAddress,
              ),
              SizedBox(
                height: Sizes(context).width * 0.01,
              ),
              SizedBox(
                width: Sizes(context).width * 0.9,
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  obscureText: _isShow,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isShow
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: const Color(0xffADADAD),
                        ),
                        onPressed: () {
                          setState(() {
                            _isShow = !_isShow;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xffADADAD))),
                      hintText: 'Kata Sandi',
                      hintStyle:
                          const TextStyle(fontFamily: 'Herme', fontSize: 16),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color(0xffADADAD)))),
                ),
              ),
              SizedBox(
                height: Sizes(context).height * 0.44,
              ),
              InkWell(
                  onTap: () {
                    authService.signInWithEmailAndPassword(
                        emailController.text.toString().trim(),
                        passwordController.text.toString().trim(),
                        context);
                  },
                  child: const ButtonGradient(title: 'Masuk'))
            ],
          ),
        ),
      ),
    );
  }
}
