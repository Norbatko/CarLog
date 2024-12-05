import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

class UserModel {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  UserModel();

  Stream<void> addUser(User user) async* {
    await usersCollection.doc(user.id).set(user.toMap());
    yield null;
  }

  Stream<void> deleteUser(String userId) async* {
    await usersCollection.doc(userId).delete();
    yield null;
  }

  Stream<void> updateUserFavorites(String userId, List<String> favoriteCars) async* {
    await usersCollection.doc(userId).update({'favoriteCars': favoriteCars});
    yield null;
  }

  Stream<List<User>> getUsers() {
    return usersCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return User.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<User?> getUserById(String userId) async* {
    final docSnapshot = await usersCollection.doc(userId).get();
    if (docSnapshot.exists) {
      yield User.fromMap(userId, docSnapshot.data() as Map<String, dynamic>);
    } else {
      yield null;
    }
  }
}
