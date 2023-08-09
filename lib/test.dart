import 'package:document_scanner/l10n/app_lang.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

Future<void> test() async {
  append("code here");
}

void example() {
  AppLang.i18n.example_plural_title(3);
}

void append(String msg, [List<Object>? args]) {
  const style = TextStyle(fontSize: 16, fontFamily: 'NotoSansMono');
  if (args == null) {
    console.add(Text(msg, style: style));
    return;
  }
  console.add(Text(sprintf(msg, args), style: style));
}

List<Text> console = [];

void main() async {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Shell',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConsolePagePage(title: 'Dart Test Shell'),
    );
  }
}

class ConsolePagePage extends StatefulWidget {
  const ConsolePagePage({super.key, required this.title});

  final String title;

  @override
  State<ConsolePagePage> createState() => _ConsolePagePageState();
}

class _ConsolePagePageState extends State<ConsolePagePage> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToEnd(dynamic x) {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    setState(() {});
  }

  void _execute() {
    test().then(_scrollToEnd).then((x) => setState(() {}));
  }

  void _clear() {
    console.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 75.0, top: 20, left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: console,
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: FloatingActionButton(
                onPressed: _execute,
                tooltip: 'Execute',
                child: const Icon(Icons.games_rounded),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: FloatingActionButton(
                onPressed: () => _scrollToEnd(null),
                tooltip: 'ScrollToEnd',
                child: const Icon(Icons.download),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: _clear,
              tooltip: 'Clear',
              child: const Icon(Icons.cleaning_services),
            ),
          ),
        ],
      ),
    );
  }
}
