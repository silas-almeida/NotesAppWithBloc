import 'package:flutter/foundation.dart';
import 'package:testingbloc_course/models/models.dart';

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNotes;

  const AppState.empty(): isLoading = false, loginError = null, loginHandle = null, fetchedNotes = null;
  
  const AppState({
    required this.isLoading,
    required this.loginError,
    required this.loginHandle,
    required this.fetchedNotes,
  });

  @override
  String toString() {
    return 'AppState: ${{
      'isLoading': isLoading,
      'loginError': loginError,
      'loginHandle': loginHandle,
      'fethedNotes': fetchedNotes
    }.toString()}';
  }
}
