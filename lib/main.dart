import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final PersonUrl url;
  const LoadPersonsAction({required this.url}) : super();
}

enum PersonUrl {
  persons1,
  persons2,
}

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.persons1:
        return "https://10.0.2.2:8000/api/persons1.json";
      case PersonUrl.persons2:
        return "https://10.0.2.2:8000/api/persons2.json";
    }
  }
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
        home: BlocProvider(
          create: (_) => PersonsBloc(),
          child: const HomePage(),
        ));
  }
}

@immutable
class Person {
  final String name;
  final int age;

  const Person({
    required this.name,
    required this.age,
  });

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((request) => request.close())
    .then((response) => response.transform(utf8.decoder).join())
    .then((string) => json.decode(string) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;
  const FetchResult({
    required this.persons,
    required this.isRetrievedFromCache,
  });

  @override
  String toString() =>
      "FetchResult: ( isRetrievedFromCache: $isRetrievedFromCache, persons: $persons)";
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _cache = {};
  PersonsBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final url = event.url;
      if (_cache.containsKey(url)) {
        //we have the value in cache
        final cachedPersons = _cache[url]!;
        final result =
            FetchResult(persons: cachedPersons, isRetrievedFromCache: true);
        emit(result);
      } else {
        final persons = await getPersons(url.urlString);
        _cache[url] = persons;
        final result = FetchResult(
          persons: persons,
          isRetrievedFromCache: false,
        );
        emit(result);
      }
    });
  }
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  context
                      .read<PersonsBloc>()
                      .add(const LoadPersonsAction(url: PersonUrl.persons1));
                },
                child: const Text("Load JSON #1"),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<PersonsBloc>()
                      .add(const LoadPersonsAction(url: PersonUrl.persons2));
                },
                child: const Text("Load JSON #2"),
              ),
            ],
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
              buildWhen: (previousResult, currentResult) {
            return previousResult?.persons != previousResult?.persons;
          }, builder: ((context, fetchResult) {
            final persons = fetchResult?.persons;
            if (persons == null) {
              return const SizedBox();
            }
            return Expanded(
              child: ListView.builder(
                itemCount: persons.length,
                itemBuilder: ((context, index) {
                  final person = persons[index]!;
                  return ListTile(title: Text(person.name),);
                }),
              ),
            );
          })),
        ],
      ),
    );
  }
}
