import 'package:flutter/material.dart';
import 'package:testingbloc_course/api/login_api.dart';
import 'package:testingbloc_course/api/notes_api.dart';
import 'package:testingbloc_course/bloc/actions.dart';
import 'package:testingbloc_course/bloc/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/dialogs/generic_dialog.dart';
import 'package:testingbloc_course/dialogs/loading_screen.dart';
import 'package:testingbloc_course/models/models.dart';
import 'package:testingbloc_course/strings.dart';
import 'package:testingbloc_course/views/iterable_list_view.dart';
import 'package:testingbloc_course/views/login_view.dart';

import 'bloc/app_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        acceptedLoginHandle: const LoginHandle.fooBar(),
        loginApi: LoginApi.instance(),
        notesApi: NotesApi.instance(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            //Loading Screen
            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: Strings.pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }
            //Display Possible errors
            final loginError = state.loginError;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: Strings.loginErrorDialogTitle,
                content: Strings.loginErrorDialogContent,
                optionsBuilder: () => {
                  Strings.ok: true,
                },
              );
            }
            //Logged in, but no fetched notes
            if (state.isLoading == false &&
                state.loginError == null &&
                state.loginHandle == const LoginHandle.fooBar() &&
                state.fetchedNotes == null) {
              context.read<AppBloc>().add(
                    const LoadNotesAction(),
                  );
            }
          },
          builder: (context, state) {
            final notes = state.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: ((email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                }),
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
