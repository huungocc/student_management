import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:student_management/managers/manager.dart';
import 'package:student_management/screens/classname.dart';
import 'package:student_management/screens/account.dart';
import 'package:student_management/screens/classes.dart';
import 'package:student_management/screens/notif.dart';
import 'screens/screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: Consumer<LocaleProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            initialRoute: Routes.loading,
            routes: {
              Routes.loading: (context) => Loading(),
              Routes.login: (context) => Login(),
              Routes.home: (context) => Home(),
              Routes.notif: (context) => Notif(),
              Routes.subject: (context) => Subject(),
              Routes.account: (context) => Account(),
              Routes.classes: (context) => Classes(),
              Routes.classmame: (context) => Classname()

            },
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: L10n.all,
            locale: provider.locale,
          );
        },
      ),
    );
  }
}
