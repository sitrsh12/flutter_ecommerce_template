import 'dart:convert';

import 'package:ecommerce_int2/screens/profile_page_content/delivery_requests.dart';
import 'package:flutter/material.dart';

import '../../app_properties.dart';
import '../../mainurl.dart';
import 'package:http/http.dart' as http;

import 'InputDecorations.dart';

class DeliveryServiceRegisterPage extends StatefulWidget {
  static const routeName = '/delivery-service-register-page';

  const DeliveryServiceRegisterPage({Key? key}) : super(key: key);

  @override
  State<DeliveryServiceRegisterPage> createState() =>
      _DeliveryServiceRegisterPageState();
}

class _DeliveryServiceRegisterPageState
    extends State<DeliveryServiceRegisterPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController cmfPassword = TextEditingController();

  TextEditingController serviceName = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController transport = TextEditingController();

  String email1 = "", password1 = "";

  @override
  Widget build(BuildContext context) {
    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Create your new account for future uses.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget registerButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 40,
      child: InkWell(
        onTap: () {
          RegisterUser();
          Navigator.of(context).pushNamed(DeliveryRequests.routeName , arguments: email.text);
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text(" Register\n(Delivery)",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: mainButton,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget registerForm = Container(
      height: 485,
      child: Column(
        children: <Widget>[
          Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32.0, right: 12.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: serviceName,
                      keyboardType: TextInputType.text,
                      decoration:
                          buildInputDecoration(Icons.shop, "Service Name"),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Shop Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: area,
                      keyboardType: TextInputType.text,
                      decoration: buildInputDecoration(Icons.shop, "Area"),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please Enter An Area Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: transport,
                      keyboardType: TextInputType.text,
                      decoration:
                          buildInputDecoration(Icons.shop, "Transport Service"),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Transport Service';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: email,
                      keyboardType: TextInputType.text,
                      decoration: buildInputDecoration(Icons.email, "Email"),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Email';
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return 'Please a valid Email';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        email1 = value!;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: password,
                      keyboardType: TextInputType.text,
                      decoration: buildInputDecoration(Icons.lock, "Password"),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please Enter a Password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: cmfPassword,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration:
                          buildInputDecoration(Icons.lock, "Confirm Password"),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please re-enter password';
                        }

                        if (password.text != cmfPassword.text) {
                          return "Password does not match";
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          registerButton,
        ],
      ),
    );

    Widget socialRegister = Column(
      children: <Widget>[
        Text(
          'You can sign in with',
          style: TextStyle(
              fontSize: 12.0, fontStyle: FontStyle.italic, color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.find_replace),
              onPressed: () {},
              color: Colors.white,
            ),
            IconButton(
                icon: Icon(Icons.find_replace),
                onPressed: () {},
                color: Colors.white),
          ],
        )
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.cover)),
          ),
          Container(
            decoration: BoxDecoration(
              color: transparentYellow,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Spacer(flex: 3),
                Spacer(),
                subTitle,
                Spacer(flex: 2),
                registerForm,
                Spacer(flex: 2),
                Padding(
                    padding: EdgeInsets.only(bottom: 10), child: socialRegister)
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 5,
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future RegisterUser() async {

      final MainUrl mu = MainUrl();
      String url1 = mu.getMainUrl();
      var url = url1 + "register_delivery_service.php";

      Map postData = {
        'email': email.text,
        'password': password.text,
        'service_name': serviceName.text,
        'area' : area.text ,
        'transport' : transport.text ,
      };
      print(postData);
      var response = await http.post(Uri.parse(url), body: postData);
      var data = jsonDecode(response.body);

      print(data);
    }

}
