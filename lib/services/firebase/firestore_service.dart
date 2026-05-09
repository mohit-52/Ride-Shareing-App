import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// ================= CREATE =================
  Future<String> create({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    try {
      final docRef = await _firestore.collection(collectionPath).add({
        ...data,
        "createdAt": FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      throw Exception("Create failed: $e");
    }
  }

  /// ================= READ (Single) =================
  Future<T?> getDocument<T>({
    required String collectionPath,
    required String docId,
    required T Function(Map<String, dynamic> data, String id) fromMap,
  }) async {
    try {
      final doc =
      await _firestore.collection(collectionPath).doc(docId).get();

      if (!doc.exists) return null;

      return fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception("Fetch failed: $e");
    }
  }

  /// ================= READ (List) =================
  Future<List<T>> getCollection<T>({
    required String collectionPath,
    required T Function(Map<String, dynamic> data, String id) fromMap,
    Query Function(Query query)? queryBuilder,
  }) async {
    try {
      Query query = _firestore.collection(collectionPath);

      if (queryBuilder != null) {
        query = queryBuilder(query);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception("Fetch collection failed: $e");
    }
  }

  /// ================= UPDATE =================
  Future<void> update({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).update({
        ...data,
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Update failed: $e");
    }
  }

  /// ================= DELETE =================
  Future<void> delete({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      throw Exception("Delete failed: $e");
    }
  }

  /// ================= COUNT (Aggregation) =================
  Future<int> countDocuments({
    required String collectionPath,
    Query Function(Query query)? queryBuilder,
  }) async {
    try {
      Query query = _firestore.collection(collectionPath);
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      final snapshot = await query.count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception("Count failed: $e");
    }
  }

  /// ================= SET (Create with custom ID) =================
  Future<void> setDocument({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).set({
        ...data,
        "created_at": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Set document failed: $e");
    }
  }

  /// ================= STREAM (REALTIME) =================
  Stream<List<T>> streamCollection<T>({
    required String collectionPath,
    required T Function(Map<String, dynamic> data, String id) fromMap,
    Query Function(Query query)? queryBuilder,
  }) {
    Query query = _firestore.collection(collectionPath);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) =>
        fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }
}