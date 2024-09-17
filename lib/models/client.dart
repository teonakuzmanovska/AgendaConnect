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

  // Convert Client object to Firestore-friendly format
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
