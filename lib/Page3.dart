import 'package:flutter/material.dart';
import 'AddProduct.dart';
import 'Product.dart';

const String _baseURL = 'testingprojects.atwebpages.com';

class Page3 extends StatefulWidget {
  final int skinId;
  const Page3({Key? key, required this.skinId}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {

  bool _load = false;
  String t = '';

  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void update(bool success) {
    setState(() {
      _load = true;
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('failed to load data')));
      }
    });
  }

  @override
  void initState() {
    updateProduct(widget.skinId, update);
    super.initState();
  }

  void searchProducts(String query) {
    setState(() {
      _load = false;
    });
    searchProduct(widget.skinId, query, update);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      screenWidth = screenWidth * 0.8;
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: !_load ? null : () {
                setState(() {
                  _load = false;
                  _searchController.clear();
                  updateProduct(widget.skinId, update);
                });
              },
              icon: const Icon(Icons.refresh)
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AddProduct())
                  );
                });
              },
              icon: const Icon(Icons.add)
          )
        ],
        title: const Text(
            'Available Products',
            style: TextStyle(color: Colors.white70, fontSize: 30)
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search, color: Colors.pink),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.pink, width: 2),
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  searchProducts(value.trim());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _load = false;
                  _searchController.clear();
                  updateProduct(widget.skinId, update);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade100,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'Show All Products',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _load
                ? const ShowProducts()
                : const Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator()
                )
            ),
          ),
        ],
      ),
    );
  }
}