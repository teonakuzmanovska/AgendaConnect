import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  final String id;
  final String name;
  final String email;
  final String phone;

  Client(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone});

  static Client fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Client(
      id: doc.id,
      name: data['name'] as String,
      email: data['email'] as String,
      phone: data['phone'] as String,
    );
  }

  Map<String, dynamic> toFirestore(Client client) {
    return {
      'name': client.name,
      'email': client.email,
      'phone': client.phone,
    };
  }
}
