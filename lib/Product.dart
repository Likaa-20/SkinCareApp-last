import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'Page4.dart';

const String _baseURL = 'testingprojects.atwebpages.com';


class Product {
  final int Pid;
  final String name;
  final String description;
  final double price;
  final String image;
  final String skinType;
  bool _selected = false;
  int _quantity = 0;


  Product(this.Pid,this.name,this.description, this.price, this.image, this.skinType);

  // getter
  bool get selected => _selected;
  set selected(bool e) => _selected = e;

  int get quantity => _quantity;
  set quantity(int q) => _quantity = q;


  @override
  String toString() {
    return '$name - \$$price';
  }
}


List<Product> _products = [];
Map<int, Product> _productSelections = {};


void updateProduct(int Sid,Function(bool success) update) async {
  try {
    final url = Uri.http(_baseURL, 'getProduct.php',{'Sid': Sid.toString()});
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5));


    if (response.statusCode == 200) {
      _products.clear();
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        Product p = Product(
          int.parse(row['Pid'].toString()),
          row['name'].toString(),
          row['description'].toString() ,
          double.parse(row['price'].toString()),
          row['image'].toString(),
          row['skinType'].toString(),
        );

        if (_productSelections.containsKey(p.Pid)) {
          p.selected = _productSelections[p.Pid]!.selected;
          p.quantity = _productSelections[p.Pid]!.quantity;
        }

        _products.add(p);
      }
      update(true);
    }
    else{
      update(false);
    }
  }
  catch(e) {
    print(e.toString());
    update(false);
  }
}


void searchProduct(int Sid, String query, Function(bool success) update) async {
  try {
    final url = Uri.http(_baseURL, 'searchProduct.php', {
      'Sid': Sid.toString(),
      'query': query
    });

    final response = await http.get(url).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      _products.clear();
      final jsonResponse = convert.jsonDecode(response.body);

      if (jsonResponse.isEmpty) {
        update(true);
      } else {
        for (var row in jsonResponse) {
          Product p = Product(
            int.parse(row['Pid'].toString()),
            row['name'].toString(),
            row['description'].toString(),
            double.parse(row['price'].toString()),
            row['image'].toString(),
            row['skinType'].toString(),
          );

          if (_productSelections.containsKey(p.Pid)) {
            p.selected = _productSelections[p.Pid]!.selected;
            p.quantity = _productSelections[p.Pid]!.quantity;
          }

          _products.add(p);
        }
        update(true);
      }
    } else {
      update(false);
    }
  } catch (e) {
    print(e.toString());
    update(false);
  }
}


class ShowProducts extends StatefulWidget {

  const ShowProducts({ super.key});

  @override
  State<ShowProducts> createState() =>_ShowProductsState();

}


class _ShowProductsState extends State<ShowProducts> {

  double sum = 0;
  String t = 'Total of products: 0 \$';

  void calculateTotal() {
    sum = 0;
    for (var product in _productSelections.values) {
      if (product.selected && product.quantity > 0) {
        sum += product.price * product.quantity;
      }
    }
    setState(() {
      t = 'Total sum of products: ${sum.toStringAsFixed(2)} \$';
    });
  }

  void saveSelection(Product product) {
    if (product.selected && product.quantity > 0) {
      _productSelections[product.Pid] = product;
    } else {
      _productSelections.remove(product.Pid);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(height: 10),
                      Image.asset(
                        'assets/${product.image}',
                        width: 100,
                        height: 100,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('${product.name}: ${product.price} \$'),
                      ),
                      Checkbox(
                        value: product.selected,
                        onChanged: (bool? newValue) {
                          setState(() {
                            product.selected = newValue ?? false;
                            if (!product.selected) {
                              product.quantity = 0;
                            } else {
                              product.quantity = 1;
                            }
                            saveSelection(product);
                            calculateTotal();
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Quantity: ', style: TextStyle(fontSize: 16)),
                      IconButton(
                        onPressed: product.selected && product.quantity > 0 ? () {
                          setState(() {
                            product.quantity--;
                            if (product.quantity == 0) {
                              product.selected = false;
                            }
                            saveSelection(product);
                            calculateTotal();
                          });
                        } : null,
                        icon: Icon(Icons.remove),
                      ),
                      Text('${product.quantity}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: product.selected ? () {
                          setState(() {
                            product.quantity++;
                            saveSelection(product);
                            calculateTotal();
                          });
                        } : null,
                        icon: Icon(Icons.add),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {

              List<Product> allSelectedProducts = _productSelections.values
                  .where((p) => p.selected && p.quantity > 0)
                  .toList();

              if (allSelectedProducts.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select at least one product'))
                );
                return;
              }


              double totalPrice = 0;
              for (var product in allSelectedProducts) {
                totalPrice += product.price * product.quantity;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Page4(
                    clientName: 'User',
                    clientId: 1,
                    products: allSelectedProducts,
                    totalPrice: totalPrice,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text(
              'Proceed to Checkout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}