import 'package:advance_navigation_2/model/quote.dart';
import 'package:advance_navigation_2/router/router_delegate.dart';
import 'package:advance_navigation_2/screen/quote_detail_screen.dart';
import 'package:advance_navigation_2/screen/quote_list_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const QuotesApp());
}

class QuotesApp extends StatefulWidget {
  const QuotesApp({Key? key}) : super(key: key);

  @override
  State<QuotesApp> createState() => _QuotesAppState();
}

class _QuotesAppState extends State<QuotesApp> {
  late MyRouterDelegate myRouterDelegate;

  @override
  void initState() {
    super.initState();
    myRouterDelegate = MyRouterDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes App',
      home: Router(
        routerDelegate: myRouterDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}