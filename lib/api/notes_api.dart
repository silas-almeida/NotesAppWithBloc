import 'package:flutter/foundation.dart' show immutable;

import '../models/models.dart';

@immutable
abstract class NotesApiProtocol {
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle});
}

@immutable
class NotesApi implements NotesApiProtocol {
  //Singleton pattern
  const NotesApi._sharedInstance();
  static const NotesApi _instance = NotesApi._sharedInstance();
  factory NotesApi.instance() => _instance;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => loginHandle == const LoginHandle.fooBar() ? mockNotes : null,
      );
}

