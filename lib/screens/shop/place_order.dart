import 'dart:convert';

import 'package:ecommerce_int2/mainurl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../app_properties.dart';
import '../../models/products.dart';

class PlaceOrder extends StatelessWidget {
  static const routeName = '/place-order';

  PlaceOrder({Key? key}) : super(key: key);

  final MainUrl mu = MainUrl();

  void placeOrder(String userEmail, String productName, String price,
      String sellerId) async {
    final bodyData = {
      "user_email": "$userEmail",
      "name": "$productName",
      "price": "$price",
      "seller_id": "$sellerId"
    };
    String url1 = mu.getMainUrl();
    String url = url1 + "place_order.php";
    final response = await http.post(Uri.parse(url), body: bodyData);
    print(json.decode(response.body));
  }

  Future<List<Products>?> postEmail(email) async {
    final MainUrl mu = MainUrl();
    String url1 = mu.getMainUrl();
    var url = url1 + "get_cart_item.php";
    Map postData = {
      'email': email,
    };
    var response = await http.post(Uri.parse(url), body: postData);
    var data = jsonDecode(response.body);
    int index = 0;
    while (index < data.length) {
      // print(data[index].toString());
      // print(data[index]['name']);
      placeOrder(email, data[index]['name'], data[index]['price'],
          data[index]['seller_id']);
      index++;
    }
    // print(data[0].toString());
    return productsFromJson(response.body);
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: darkGrey),
        title: Text(
          'Place Order',
          style: const TextStyle(
              color: darkGrey,
              fontWeight: FontWeight.w500,
              fontFamily: "Montserrat",
              fontSize: 18.0),
        ),
      ),
      body: FutureBuilder(
        future: postEmail(email),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: Container(
              child: Text('Order placed'),
            ),
          );
        },
      ),
    );
  }
}
