import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'Product.dart';

const String _baseURL = 'testingprojects.atwebpages.com';

class Page4 extends StatefulWidget {
  final String clientName;
  final int clientId;
  final List<Product> products;
  final double totalPrice;

  const Page4({
    Key? key,
    required this.clientName,
    required this.clientId,
    required this.products,
    required this.totalPrice
  }) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {

  bool _loading = false;
  TextEditingController _controllerLocation = TextEditingController();

  @override
  void dispose() {
    _controllerLocation.dispose();
    super.dispose();
  }

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Summary',
          style: TextStyle(color: Colors.white70, fontSize: 24),
        ),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Total Amount: \$${widget.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Selected Items:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                // Display each product with description
                ...widget.products.map((p) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink.shade100),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${p.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        p.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quantity: ${p.quantity}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            '\$${(p.price * p.quantity).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )).toList(),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 20),
                Text(
                  'Enter Delivery Location:',
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 350.0,
                  child: TextFormField(
                    controller: _controllerLocation,
                    style: const TextStyle(fontSize: 18.0),
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your address...',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _loading ? null : () {
                    if (_controllerLocation.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter delivery location'))
                      );
                      return;
                    }
                    setState(() => _loading = true);
                    saveOrder(
                      update,
                      widget.clientId,
                      _controllerLocation.text,
                      widget.products,
                      widget.totalPrice,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade100,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_loading) const CircularProgressIndicator(),
                const SizedBox(height: 30),
                Text(
                  'Thank you ${widget.clientName} for choosing us to be part of your daily routine. We appreciate your trust and hope you enjoy your new products!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void saveOrder(Function(String text) update, int clientId, String location, List<Product> products, double totalAmount) async {
  print("Saving order...");
  print("Client ID: $clientId");
  print("Location: $location");
  print("Total: $totalAmount");
  try {
    final response = await http.post(
        Uri.parse('http://$_baseURL/saveOrder.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, dynamic>{
          'Cid': clientId.toString(),
          'location': location,
          'totalAmount': totalAmount.toString(),
          'products': products.map((p) => {
            'Pid': p.Pid.toString(),
            'quantity': p.quantity.toString(),
          }).toList(),
          'key': 'password'
        })
    ).timeout(const Duration(seconds: 10));

    print("Response code: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      update(response.body);
    }
  } catch(e) {
    update("connection error");
  }
}