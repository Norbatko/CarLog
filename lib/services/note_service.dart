import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_log/model/note.dart';

class NoteService {
  final CollectionReference carsCollection =
  FirebaseFirestore.instance.collection('cars');

  NoteService();

  Stream<void> addNote(Note note, String carId) {
    carsCollection.doc(carId).collection('notes').add(note.toMap());
    return Stream.value(null);
  }

  Stream<String> deleteNote(String carId, String noteId) async* {
    try {
      await carsCollection
          .doc(carId)
          .collection('notes')
          .doc(noteId)
          .delete();
      yield 'success';
    } catch (e) {
      yield 'error: ${e.toString()}';
    }
  }


  Stream<String> updateNote(String carId, String noteId, Note updatedNote) async* {
    try {
      await carsCollection
          .doc(carId)
          .collection('notes')
          .doc(noteId)
          .update(updatedNote.toMap());
      yield 'success';
    } catch (e) {
      yield 'error: ${e.toString()}';
    }
  }

  Stream<List<Note>> getNotes(String carId) {
    return carsCollection
        .doc(carId)
        .collection('notes')
        .snapshots()
        .map((querySnapshot) {
      List<Note> notesList = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        notesList.add(Note.fromMap(doc.id, data));
      }
      notesList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return notesList;
    });
  }

  Stream<Note?> getNoteById(String carId, String noteId) async* {
    final docSnapshot = await carsCollection
        .doc(carId)
        .collection('notes')
        .doc(noteId)
        .get();
    if (docSnapshot.exists) {
      yield Note.fromMap(noteId, docSnapshot.data() as Map<String, dynamic>);
    } else {
      yield null;
    }
  }
}
