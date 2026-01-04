class Client{
  int Cid;
  String name;
  String password;
  String gender;
  String phone;
  String type;

Client ( this.Cid, this.name, this.password, this.gender,  this.phone,  this.type);
  factory Client.fromJson(Map<String, dynamic> json) {
  return Client(

  int.parse(json['Cid'].toString()),
  json['name'] ?? 'Unknown',
  json['password'] ?? '',
  json['gender'] ?? 'Not Specified',
  json['phone'] ?? '',
  json['Skin'] ?? 'Not Set',
  );
  }


  @override
  String toString() {
  return 'Client(ID: $Cid, Name: $name, Skin: $type)';
  }
  }



