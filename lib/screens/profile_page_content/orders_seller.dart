import 'dart:convert';

import 'package:ecommerce_int2/mainurl.dart';
import 'package:ecommerce_int2/screens/profile_page_content/components/order_item.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class OrdersSeller extends StatelessWidget {
  OrdersSeller(this.email, {Key? key}) : super(key: key);
  final String email;
  final MainUrl mu = MainUrl();

  List<Map<String, dynamic>> orders = [];

  Future<void> fetchOrders(String email) async {
    String url1 = mu.getMainUrl();
    final String url = url1 + 'fetch_orders_seller.php';

    final response = await http.post(Uri.parse(url), body: {"email": email});
    final decodedResponse = jsonDecode(response.body) as List<dynamic>;
    // print(decodedResponse);

    decodedResponse.map((e) {
      orders.add(e);
    }).toList();

    print(orders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Received Orders'),
      ),
      body: FutureBuilder(
          future: fetchOrders(email),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (ctx, index) {
                          return OrderItem(
                            orderId: orders[index]['id'],
                            amount: orders[index]['total_amount'],
                            productName: orders[index]['product_name'],
                            user: orders[index]['user'],
                            userPhone: orders[index]['user_phone'],
                          );
                        }),
                  ),
                ),
              );
            }
          }),
    );
  }
}
