import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

// domain of your server
const String _baseURL = 'http://testingprojects.atwebpages.com';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  TextEditingController _controllerID = TextEditingController();
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  TextEditingController _controllerPrice = TextEditingController();
  TextEditingController _controllerImage = TextEditingController();
  TextEditingController _controllerSid = TextEditingController();
  bool _loading = false;


  @override
  void dispose() {
    _controllerID.dispose();
    _controllerName.dispose();
    _controllerDescription.dispose();
    _controllerPrice.dispose();
    _controllerImage.dispose();
    _controllerSid.dispose();

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

          title: const Text('Add Product',style: TextStyle(color: Colors.white70, fontSize: 24),),
          backgroundColor: Colors.pink,
          centerTitle: true,
        ),


        body: Center(child: Form(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 15.0),
              Text('Enter Product ID:', style: const TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const SizedBox(height: 20.0),
              const SizedBox(width: 9.0,),
              SizedBox(width: 300.0, height: 50.0,
              child: TextFormField(controller: _controllerID,
              style: const TextStyle(fontSize: 18.0),
              decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Product id ',
              hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              ),
              ),
              validator: (String? value) {
              if (value == null || value.isEmpty) {
              return 'Please enter product id';
              }
              return null;
              },
              ),
              ),
              ]
              ),
              const SizedBox(height: 15.0),
              Text('Enter Product name:', style: const TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const SizedBox(height: 20.0),
              SizedBox(width: 300.0, height: 50.0,
              child: TextFormField(controller: _controllerName,
              style: const TextStyle(fontSize: 18.0),
              decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Name ',
              hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              ),
              ),
              validator: (String? value) {
              if (value == null || value.isEmpty) {
              return 'Please enter product name';
              }
              return null;
              },
              ),
              ),
              ]
              ),
              const SizedBox(height: 15.0),
              Text('Enter Product description:', style: const TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const SizedBox(height: 20.0),
              SizedBox(width: 300.0, height: 50.0,
              child: TextFormField(controller: _controllerDescription,
              style: const TextStyle(fontSize: 18.0),
              decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Description ',
              hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              ),
              ),
              validator: (String? value) {
              if (value == null || value.isEmpty) {
              return 'Please enter product description';
              }
              return null;
              },
              ),
              ),
              ]
              ),
              const SizedBox(height: 15.0),
              Text('Enter Product price:', style: const TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const SizedBox(height: 20.0),
              SizedBox(width: 300.0, height: 50.0,
              child: TextFormField(controller: _controllerPrice,
              style: const TextStyle(fontSize: 18.0),
              decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Price ',
              hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              ),
              ),
              validator: (String? value) {
              if (value == null || value.isEmpty) {
              return 'Please enter product price';
              }
              return null;
              },
              ),
              ),
              ]
              ),

              const SizedBox(height: 15.0),
              Text('Enter Product image URL:', style: const TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const SizedBox(height: 20.0),
              SizedBox(width: 300.0, height: 50.0,
              child: TextFormField(controller: _controllerImage,
              style: const TextStyle(fontSize: 18.0),
              decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'image URL ',
              hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              ),
              ),
              validator: (String? value) {
              if (value == null || value.isEmpty) {
              return 'Please enter product image URL';
              }
              return null;
              },
              ),
              ),
              ]
              ),

              const SizedBox(height: 15.0),
              Text('Enter Product skin id:', style: const TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const SizedBox(height: 20.0),
              SizedBox(width: 300.0, height: 50.0,
              child: TextFormField(controller: _controllerSid,
              style: const TextStyle(fontSize: 18.0),
              decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: '1:Normal, 2:Dry, 3:Oily ',
              hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              ),
              ),
              validator: (String? value) {
              if (value == null || value.isEmpty) {
              return 'Please enter product skin ID';
              }
              return null;
              },
              ),
              ),
              ]
              ),
              const SizedBox(height: 10),
              ElevatedButton(

                onPressed: _loading ? null : () { // disable button while loading

                    setState(() {
                      _loading = true;
                    });
                    saveProduct(update, int.parse(_controllerID.text.toString()), _controllerName.text.toString(),_controllerDescription.text.toString(),double.parse(_controllerPrice.text.toString()),_controllerImage.text.toString(),int.parse(_controllerSid.text.toString()));
                  }
                ,style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade100,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
                child: const Text('Submit'),
              ),
              const SizedBox(height: 10),
              Visibility(visible: _loading, child: const CircularProgressIndicator())
            ],
          ),
        )));
  }
}

void saveProduct(Function(String text) update, int Pid, String name, String description, double price, String image, int Sid) async {
  try {


    final response = await http.post(
        Uri.parse('$_baseURL/AddProduct.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          'Pid': '$Pid', 'name': name, 'description': description, 'price':'$price','image':image, 'Sid':'$Sid'
        })).timeout(const Duration(seconds: 10));
    print(response.statusCode);
    if (response.statusCode == 200) {
      // if successful, call the update function
      update(response.body);
    }
  }
  catch(e) {
    update("connection error");
  }
}

