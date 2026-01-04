import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'Page2.dart';


const String _baseURL = 'testingprojects.atwebpages.com';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);
  @override
  State<Welcome> createState() => _WelcomeState();
}
class _WelcomeState extends State<Welcome> {
  bool showregister=false;
  bool showlogin=false;

  String? _selectedGender;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerID = TextEditingController();
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerPhone = TextEditingController();
  TextEditingController _controllerSid = TextEditingController();

  bool _loading = false;


  @override
  void dispose() {
    _controllerID.dispose();
    _controllerName.dispose();
    _controllerPassword.dispose();
    _controllerPhone.dispose();
    _controllerSid.dispose();
    super.dispose();
  }

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

    setState(() {
      _loading = false;
    });

    bool isRegisterSuccess = text.trim() == "Record Added";

    bool isLoginSuccess = text.contains("Login Successful");

    if (isRegisterSuccess || isLoginSuccess) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Page2(clientName: _controllerName.text)
          )
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Skin_care Application",
              style:TextStyle(
                  color: Colors.white70,
                  fontSize: 30
              )
          ),
          backgroundColor: Colors.pink,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child:Form(
                key: _formKey,
            child:Center(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                const SizedBox(height: 10.0),

                Image.asset('assets/skin.jpg',height:200,width:2000),
                const SizedBox(height: 40.0),

                Text(
                  'Welcome to our application, your destination to let your face glow up!',
                  style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                Text(
                  'If this is the first time you use our application please click on "Register" button,'
                      ' if not please click on "Login" button',
                  style: TextStyle(color: Colors.deepPurple),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),


                showregister
                    ?Column(
                    children: <Widget>[

                      const SizedBox(height: 30.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Text('Enter your ID:', style: const TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                            const SizedBox(width: 9.0,),
                            SizedBox(width: 300.0, height: 50.0, child: TextFormField(controller: _controllerID,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter ID',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter id';
                                }
                                return null;
                              },
                            )),
                            ]
                      ),
                      const SizedBox(height: 10.0,),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20.0),
                            Text('Enter your name:', style: const TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                            const SizedBox(width: 9.0,),
                            SizedBox(width: 300.0, height: 50.0,
                              child: TextFormField(controller: _controllerName,
                                style: const TextStyle(fontSize: 18.0),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(), hintText: 'Name',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },

                              ),
                            ),
                          ]
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20.0),
                            Text('Enter password:', style: const TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                            const SizedBox(width: 9.0,),
                            SizedBox(width: 300.0, height: 50.0,
                              child: TextFormField(controller: _controllerPassword,
                                style: const TextStyle(fontSize: 18.0),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(), hintText: 'password',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  return null;
                                },

                              ),
                            ),
                          ]
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20.0),
                            Text('Enter your number:', style: const TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                            const SizedBox(width: 9.0,),
                            SizedBox(width: 300.0, height: 50.0,
                              child: TextFormField(controller: _controllerPhone,
                                style: const TextStyle(fontSize: 18.0),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(), hintText: '../......',
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your number';
                                  }
                                  return null;
                                },

                              ),
                            ),
                          ]
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20.0),
                            Text("Select Skin Type: ", style: const TextStyle(fontSize: 18.0)), const SizedBox(width: 9.0,),
                            SizedBox(width: 300.0, height: 50.0,
                              child: TextFormField(controller: _controllerSid,
                                style: const TextStyle(fontSize: 18.0),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(), hintText: '1:Normal, 2:Dry, 3:Oily',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter skin id';
                                  }
                                  return null;
                                },

                              ),
                            ),
                          ]
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Gender', style: TextStyle(fontSize: 18.0),),
                            Radio<String>(
                              value:"female" ,
                              groupValue: _selectedGender,//ignore: deprecated_member_use
                              onChanged: (value) {//ignore: deprecated_member_use
                                setState(() {
                                  _selectedGender = value!;
                                });
                              },
                            ),
                            const Text('Female', style: TextStyle(fontSize: 18.0),),
                            Radio<String>(
                              value: "male",
                              groupValue: _selectedGender,//ignore: deprecated_member_use
                              onChanged: (value) { //ignore: deprecated_member_use
                                setState(() {
                                  _selectedGender = value!;
                                });
                              },
                            ),
                            const Text('Male', style: TextStyle(fontSize: 18.0),),
                          ]
                      ),


                      const SizedBox(height: 10),
                      ElevatedButton(onPressed: _loading ? null : () {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _loading = true);
                          saveClient(
                            update,
                            int.parse(_controllerID.text),
                            _controllerName.text,
                            _controllerPassword.text,
                            _controllerPhone.text,
                            _selectedGender ?? "female",
                            int.parse(_controllerSid.text),
                          );
                        }

                      },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade100,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child:Text('Sign up',style:TextStyle(
                              color: Colors.white70,
                          ))
                      )


                ],)
                    :

               ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showregister = true;
                      showlogin=false;
                    });
                  },style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.pink.shade100,
                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
               ),
                  child: Text('Register',style:TextStyle(
                      color: Colors.white70,
                  )),
                ),
                const SizedBox(height: 20.0),

                showlogin
                    ?Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15.0),
                          Text('Enter your name:', style: const TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                          const SizedBox(width: 9.0,),
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
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ]
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20.0),
                          Text('Enter password:', style: const TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                          const SizedBox(width: 9.0,),
                          SizedBox(width: 300.0, height: 50.0,
                            child: TextFormField(controller: _controllerPassword,
                              style: const TextStyle(fontSize: 18.0),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(), hintText: 'Password ',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(onPressed: (){

                    loginUser(context,update, _controllerName.text.toString(), _controllerPassword.text.toString());
                    },style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade100,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ), child: Text('OK',style:TextStyle(
                        color: Colors.white70,
                    )))

                  ],
                )
                    :
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showlogin = true;
                        showregister=false;
                      });

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade100,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text('Login', style:TextStyle(
                      color: Colors.white70,
                  )),
                ),
              ],
            )
        )
    )
        ));
  }

}

void saveClient(Function(String text) update, int Cid, String name, String password, String phone, String gender, int Sid) async {
  try {

    final response = await http.post(
        Uri.parse('http://$_baseURL/saveClient.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          'Cid': '$Cid', 'name': name, 'password': password,'phone':phone,'gender':gender, 'Sid':'$Sid','key': 'password'
        })).timeout(const Duration(seconds: 10));
    print(response.statusCode);
    if (response.statusCode == 200) {

      update(response.body);
    }
  }
  catch(e) {
    update("connection error");
  }
}

void loginUser(BuildContext context, Function(String text) update, String name, String password) async {
  try {
    final response = await http.post(
      Uri.parse('http://$_baseURL/login.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: convert.jsonEncode({
        'name': name,
        'password': password,
        'key': 'password',
      }),
    ).timeout(const Duration(seconds: 10));

    var data = convert.jsonDecode(response.body);

    if (data['status'] == "success") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Page2(clientName: '$name')
          )
      );

    } else {
      update(data['message']);
    }
  } catch (e) {
    update("Login failed: $e");
  }
}

