import 'package:flutter/material.dart';
import 'Page3.dart';
import 'skinType.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

const String _baseURL = 'testingprojects.atwebpages.com';
class Page2 extends StatefulWidget {
  final String clientName;
  final int clientId;

  const Page2({
    Key? key,
    required this.clientName,
    required this.clientId
  }) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {

skinType? _selectedSkin;




@override
void initState() {
  super.initState();

  updateSkin((success) {
    if (success) {
      setState(() {});
    }
  });
}

List<DropdownMenuItem<skinType>> buildItems() {
  List<DropdownMenuItem<skinType>> menuItems = [];
  for (var skin in _skins) {
    menuItems.add(
      DropdownMenuItem(
        value: skin,
        child: Text(skin.description),
      ),
    );
  }
  return menuItems;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome ${widget.clientName}!',
          style: TextStyle(color: Colors.white70, fontSize: 24),
        ),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset('assets/image2.jpg',height:300,width:10000),
            Text(
              'Select your skin type:',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: DropdownMenu<skinType>(
                initialSelection: _selectedSkin,




                expandedInsets: EdgeInsets.zero,

                dropdownMenuEntries: _skins.map<DropdownMenuEntry<skinType>>((skinType skin) {
                  return DropdownMenuEntry<skinType>(
                    value: skin,
                    label: skin.description,
                    enabled: _skins.isNotEmpty,
                  );
                }).toList(),

                onSelected: (skinType? val) {
                  setState(() {
                    _selectedSkin = val;
                  });
                },
              )
            ),

            const SizedBox(height: 30),



            const SizedBox(height: 40),

            Text(
              'You selected: ${_selectedSkin?.description ?? "Nothing yet"}',
              style: TextStyle(
                fontSize: 22,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Page3(
                          skinId: _selectedSkin!.Sid,
                          clientName: widget.clientName,
                          clientId: widget.clientId
                      ),
                    )
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade100,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'Show Products',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<skinType> _skins = [];

void updateSkin(Function(bool success) update) async {
  try {
    final url = Uri.http(_baseURL, 'getSkinType.php');
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5));

    print("${response.statusCode}");

    _skins.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        skinType s = skinType(
          int.parse(row['Sid'].toString()),
          row['description'].toString(),
        );
        _skins.add(s);
      }
      update(true);
    }
  }
  catch(e) {
    print(e.toString());
    update(false);
  }
}

