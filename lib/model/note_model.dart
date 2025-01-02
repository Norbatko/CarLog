import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_log/model/note.dart';

class NoteModel {
  final CollectionReference carsCollection =
  FirebaseFirestore.instance.collection('cars');

  NoteModel();

  Stream<void> addNote(String carId, Note note) {
    carsCollection
        .doc(carId)
        .collection('notes')
        .add(note.toMap());
    return Stream.value(null);
  }

  Stream<void> deleteNote(String carId, String noteId) async* {
    await carsCollection
        .doc(carId)
        .collection('notes')
        .doc(noteId)
        .delete();
    yield null;
  }

  Stream<void> updateNote(String carId, String noteId, Note updatedNote) async* {
    await carsCollection
        .doc(carId)
        .collection('notes')
        .doc(noteId)
        .update(updatedNote.toMap());
    yield null;
  }

  Stream<List<Note>> getNotes(String carId) {
    return carsCollection
        .doc(carId)
        .collection('notes')
        .snapshots()
        .map((querySnapshot) {
      List<Note> notesList = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
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
