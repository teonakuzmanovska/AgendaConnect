import 'package:client_meeting_scheduler/models/location.dart';

class Client {
  String name;
  String email;
  String phone;
  Location address;

  Client(
      {required this.name,
      required this.email,
      required this.phone,
      required this.address});

  // factory Client.fromJson(Map<String, dynamic> json) {
  //   return Client(
  //     name: json['name'],
  //     email: json['email'],
  //     phone: json['phone'],
  //     address: json['address'],
  //   );
  // }

  // Map<String, dynamic> toJson() => {
  //       'name': name,
  //       'email': email,
  //       'phone': phone,
  //       'address': address,
  //     };
}
