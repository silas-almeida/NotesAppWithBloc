// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';

import 'package:testingbloc_course/api/login_api.dart';
import 'package:testingbloc_course/api/notes_api.dart';
import 'package:testingbloc_course/bloc/actions.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/models/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(
          const AppState.empty(),
        ) {
    on<LoginAction>((event, emit) async {
      //Start loading
      emit(
        const AppState(
          isLoading: true,
          loginError: null,
          fetchedNotes: null,
          loginHandle: null,
        ),
      );
      final loginHandle =
          await loginApi.login(email: event.email, password: event.password);
      emit(
        AppState(
          isLoading: false,
          loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
          loginHandle: loginHandle,
          fetchedNotes: null,
        ),
      );
    });

    on<LoadNotesAction>((event, emit) async {
      emit(
        AppState(
          isLoading: true,
          loginError: null,
          loginHandle: state.loginHandle,
          fetchedNotes: null,
        ),
      );
      //get the loginHandle
      final loginHandle = state.loginHandle;
      if (loginHandle != const LoginHandle.fooBar()) {
        emit(
          AppState(
            isLoading: false,
            loginError: LoginErrors.invalidHandle,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
      } else {
        //valid loginHandle
        final notes = await notesApi.getNotes(
          loginHandle: loginHandle!,
        );
        emit(
          AppState(
            isLoading: false,
            loginError: null,
            loginHandle: loginHandle,
            fetchedNotes: notes,
          ),
        );
      }
    });
  }
}
