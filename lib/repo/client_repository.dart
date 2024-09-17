import 'package:client_meeting_scheduler/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Client>> fetchAllClients() async {
    try {
      final querySnapshot = await _firestore.collection('clients').get();
      return querySnapshot.docs
          .map((doc) => Client.fromFirestore(doc))
          .toList();
    } catch (e) {
      // Handle errors
      print('Error fetching clients: $e');
      return [];
    }
  }

  // Fetch a single client by ID
  Future<Client?> getById(String id) async {
    try {
      final docSnapshot = await _firestore.collection('clients').doc(id).get();
      if (docSnapshot.exists) {
        return Client.fromFirestore(docSnapshot);
      } else {
        // Handle case where the document does not exist
        print('Client not found for ID: $id');
        return null;
      }
    } catch (e) {
      print('Error fetching client by ID: $e');
      return null;
    }
  }
}
