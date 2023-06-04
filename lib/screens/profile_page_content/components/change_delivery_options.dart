import 'dart:convert';
import 'dart:async';

import 'package:ecommerce_int2/mainurl.dart';
import 'package:ecommerce_int2/screens/profile_page_content/components/osm_widget.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

class ChangeDeliveryOptions extends StatefulWidget {
  const ChangeDeliveryOptions(this.orderId, {Key? key}) : super(key: key);

  final String orderId;

  @override
  State<ChangeDeliveryOptions> createState() => _ChangeDeliveryOptionsState();
}

class _ChangeDeliveryOptionsState extends State<ChangeDeliveryOptions> {
  final MainUrl mu = MainUrl();

  Map<String, dynamic> order = {};
  int buildCount = 1;

  int deliveryServiceId = -1;

  bool isLoading = true;

  String _date = '..';

  String _distance = '..';

  String _time = '..';

  late double userLat;

  late double userLng;

  late double sellerLat;

  late double sellerLng;

  Future<void> fetchDetails(String id) async {
    final String url1 = mu.getMainUrl();
    final String url = url1 + 'fetch_single_order.php';
    final response = await http.post(Uri.parse(url), body: {"id": id});
    final decodedResponse = jsonDecode(response.body);
    order = decodedResponse;
    // print(decodedResponse.toString());
    print(order);
  }

  void setData(String date, double distance, double time) {
    if (!isLoading) {
      return;
    }

    setState(() {
      _date = date;
      _distance = distance.toStringAsFixed(2);
      _time = time.toStringAsFixed(2);
      isLoading = false;
    });
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime.now().add(const Duration(days: 15)))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        // _date = pickedDate as String ;
        _date = DateFormat("dd/MM/yyyy").format(pickedDate);
      });
    });
  }

  List<Map<String, dynamic>> services = [];

  Future<void> fetchDeliveryServices() async {
    if (buildCount != 1) {
      return;
    }
    final url1 = mu.getMainUrl();
    String url = url1 + 'fetch_delivery_services.php';
    final response = await http.get(Uri.parse(url));
    final decodedResponse = jsonDecode(response.body) as List<dynamic>;
    // print(decodedResponse);

    decodedResponse.map((e) {
      services.add(e);
    }).toList();

    print(services);
    buildCount++;
  }

  Future<void> addDelivery(String? orderId, String? deliveryDate,
      String? seller, int? deliveryServiceId) async {
    if (orderId == null ||
        deliveryDate == null ||
        seller == null ||
        deliveryServiceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select all the fields properly'),
        backgroundColor: Colors.yellow,
      ));
      return;
    }
    final url1 = mu.getMainUrl();
    String url = url1 + 'add_delivery.php';
    Map<String, dynamic> data = {
      'order_id': orderId,
      'delivery_date': deliveryDate,
      'seller': seller,
      'delivery_service_id': '$deliveryServiceId',
    };

    final response = await http.post(Uri.parse(url), body: data);
    final decodedResponse = jsonDecode(response.body);
    if (decodedResponse.toString() == 'Success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Delivery added successfully'),
        backgroundColor: Colors.green,
      ));
    } else if (decodedResponse.toString() == 'Failed') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add delivery'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchDetails(widget.orderId);
    fetchDeliveryServices();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Change delivery options'),
      ),
      body: FutureBuilder(
        future: fetchDetails(widget.orderId),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            userLat = double.parse(order['user_lat']);
            userLng = double.parse(order['user_lng']);
            sellerLat = double.parse(order['shop_lat']);
            sellerLng = double.parse(order['shop_lng']);
            // sellerLat = 28.7041;
            // sellerLng = 77.1025;
            return Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 8,
                      color: Colors.blueGrey,
                      shadowColor: Colors.blueAccent,
                      child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          height: 300,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery date',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blueGrey.shade100,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Chip(
                                    label: Text(_date),
                                    backgroundColor: Colors.orange.shade400,
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Distance from user',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blueGrey.shade100,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Chip(
                                    label: Text('$_distance km'),
                                    backgroundColor: Colors.blueGrey.shade100,
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Estimated Time',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blueGrey.shade100,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Chip(
                                    label: Text('$_time hours'),
                                    backgroundColor: Colors.blueGrey.shade100,
                                  )
                                ],
                              ),
                              // Expanded(child: SizedBox()),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 140,
                                    width: 120,
                                    child: OsmWidget(
                                      setData: setData,
                                      userLat: userLat,
                                      userLng: userLng,
                                      sellerLat: sellerLat,
                                      sellerLng: sellerLng,
                                    ),
                                  ),
                                  !isLoading
                                      ? OutlinedButton(
                                          onPressed: () {
                                            _presentDatePicker();
                                          },
                                          child: Text('Choose delivery date',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors
                                                      .orangeAccent.shade200,
                                                  fontWeight: FontWeight.bold)))
                                      : const CircularProgressIndicator(),
                                ],
                              )
                            ],
                          )),
                    ),
                    Card(
                      elevation: 8,
                      color: Colors.deepPurpleAccent.shade200,
                      shadowColor: Colors.purpleAccent,
                      child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          height: 300,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(),
                                  Text(
                                    'Choose delivery method',
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.blueGrey.shade300,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Own delivery service',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueGrey.shade100,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Radio(
                                      value: -1,
                                      groupValue: deliveryServiceId,
                                      onChanged: (value) {
                                        setState(() {
                                          deliveryServiceId = value as int;
                                        }); //selected value
                                      })
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'App delivery service',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueGrey.shade100,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Radio(
                                      value: -2,
                                      groupValue: deliveryServiceId,
                                      onChanged: (value) {
                                        setState(() {
                                          deliveryServiceId = value as int;
                                        });
                                      })
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Third party services :',
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Container(
                                height: 135,
                                child: ListView.builder(
                                    itemCount: services.length,
                                    itemBuilder: (ctx, index) {
                                      return Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.grey.shade400,
                                              width: 2),
                                        ),
                                        height: 55,
                                        child: RadioListTile(
                                            title: Text(services[index]
                                                ['service_name']),
                                            secondary:
                                                Text(services[index]['area']),
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                            value: int.parse(
                                                services[index]['id']),
                                            groupValue: deliveryServiceId,
                                            onChanged: (val) {
                                              // widget.isSelected(widget.title) ;
                                              setState(() {
                                                deliveryServiceId = int.parse(
                                                    services[index]['id']);
                                              });
                                            }),
                                      );
                                    }),
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              addDelivery(order['id'], _date, order['seller'],deliveryServiceId);
                            },
                            child: Text('Submit')))
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
