import 'dart:math';

import 'package:ecommerce_int2/screens/profile_page_content/components/change_delivery_options.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatefulWidget {
  OrderItem(
      {required this.orderId,
      required this.amount,
      required this.productName,
      required this.user,
      required this.userPhone});

  final String orderId;

  final String amount;
  final String productName;

  final String user;

  final String userPhone;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      // height: _expanded ? min(widget.order.products.length * 20 + 200 , 250) : 95,
      height: _expanded ? min(5 * 20 + 200, 250) : 95,
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('₹${widget.amount}'),
              subtitle: Text('${widget.productName}'),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              // height: _expanded ? min(widget.order.products.length * 20 + 100 , 150) : 0,
              height: _expanded ? min(5 * 20 + 100, 150) : 0,
              child: ListView(
                // children: widget.order.products.map(
                //         (product) => Padding(
                //       padding: const EdgeInsets.all(10.0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(product.title , style: Theme.of(context).textTheme.subtitle1?.copyWith( fontWeight: FontWeight.w500,fontSize: 20 , color: Theme.of(context).accentColor),),
                //           Text('${product.quantity} x \$${product.price}' ,style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.w500,fontSize: 18 , color: Colors.grey))
                //         ],
                //       ),
                //     )
                // ).toList(),
                children: [
                  Container(
                      color: Colors.blueGrey.shade100,
                      child: Column(
                        children: [
                          Text(
                            widget.user,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(widget.userPhone,
                              style: TextStyle(fontSize: 18)),
                          SizedBox(
                            height: 4,
                          )
                        ],
                      )),
                  Container(
                    color: Colors.blueGrey.shade200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ChangeDeliveryOptions(widget.orderId)));
                            },
                            child: Text('Choose date')),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text('Delivery date'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.blueGrey.shade100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ChangeDeliveryOptions(widget.orderId)));
                            },
                            child: Text('Choose driver')),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text('driver'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
