import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../mainurl.dart';

class DeliveryRequests extends StatelessWidget {
  static const routeName = '/delivery-requests';
  DeliveryRequests({Key? key}) : super(key: key);
  final MainUrl mu = MainUrl();

  List<Map<String, dynamic>> deliveries = [];

  Future<void> fetchdeliveries(String email) async {
    String url1 = mu.getMainUrl();
    final String url = url1 + 'get_delivery_requests.php';

    final response = await http.post(Uri.parse(url), body: {"email": email});
    final decodedResponse = jsonDecode(response.body) as List<dynamic>;
    // print(decodedResponse);

    decodedResponse.map((e) {
      deliveries.add(e);
    }).toList();

    print(deliveries);
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Received deliveries'),
      ),
      body: FutureBuilder(
          future: fetchdeliveries(email),
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
                        itemCount: deliveries.length,
                        itemBuilder: (ctx, index) {
                          return Container(
                            margin: EdgeInsets.all(4),
                              padding: EdgeInsets.all(8),
                              color: Colors.grey.shade100,
                              child: Column(
                                children: [
                                  Text('Delivery date : ${deliveries[index]['delivery_date']}'),
                                  Text('Seller : ${deliveries[index]['seller']}'),
                                  Text('Order id : ${deliveries[index]['order_id']}'),
                                ],
                              ));
                        }),
                  ),
                ),
              );
            }
          }),
    );
  }
}
