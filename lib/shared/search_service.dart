import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'items';

  Future<List<DocumentSnapshot>> getuserSearch() async => await _firestore
          .collection('users')
          .where('role', isEqualTo: 'student')
          .get()
          .then((snaps) {
        return snaps.docs;
      });
}
