import 'package:flutter/material.dart';
import 'sqlite_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localizations Sample App',
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('ja', ''), // Japanese, no country code
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SQLiteHelper _sq = SQLiteHelper();

  Future<List<Widget>> sqliteDemo() async {
    List<Widget> listWidgets = [];

    //get a current language setting
    Locale locale = Localizations.localeOf(context);
    String languageCode = locale.languageCode;
    debugPrint(languageCode);

    //create a database
    await _sq.dbCreate();

    //get data
    List<Map> list = await _sq.dataSelect(languageCode);

    //make some text widgets
    for (var item in list) {
      Widget text = Text(
        item['name'].toString(),
        style: const TextStyle(fontSize: 30.0),
      );
      listWidgets.add(text);
    }
    return listWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.applicationTitle),
      ),
      body: FutureBuilder<List<Widget>>(
          future: sqliteDemo(), // a previously-obtained Future<String> or null
          builder:
              (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = snapshot.data!;
            } else if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home),
          BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: AppLocalizations.of(context)!.search),
          BottomNavigationBarItem(
              icon: const Icon(Icons.bookmark),
              label: AppLocalizations.of(context)!.bookmark),
        ],
      ),
    );
  }
}
