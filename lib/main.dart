import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:foundlost/lostObjects/lostObjectDetail/views/index.dart';
import 'package:foundlost/start_app.dart';

import 'common/index.dart';
import 'global_bloc_observer.dart';
import 'lostObjects/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = GlobalBlocObserver();
  runApp(const App());
}


class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late Future<FirebaseApp> _initialization;

  @override
  void initState() {
    _initialization = StartApp.registers(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const CircularProgressIndicator();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
          alignment: Alignment.center,
          child: const CircularProgressIndicator()
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoundLost',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) {
          StartApp.initContext(context);
          return const LostObjectsListPage();
        },
        '/newLostObject': (context) => const LostObjectsFormPage(),
        '/viewLostObject': (context) => const LostObjectsDetailPage(),
      },
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            fallbackFile: 'es',
            basePath: 'assets/i18n'
          ),
          missingTranslationHandler: (key, locale) {
            log("--- Missing Key: $key, languageCode: ${locale!.languageCode}");
          },
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
      ],
      builder: FlutterI18n.rootAppBuilder()
    );
  }
}
