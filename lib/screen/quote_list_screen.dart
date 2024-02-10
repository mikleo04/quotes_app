import 'package:advance_navigation_2/model/quote.dart';
import 'package:advance_navigation_2/routes/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuotesListScreen extends StatelessWidget {
  final List<Quote> quotes;
  final Function(String) onTapped;
  final Function() toFormScreen;

  const QuotesListScreen({
    Key? key,
    required this.quotes, required this.onTapped, required this.toFormScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes App"),
        actions: [
          IconButton(
            onPressed: () async {
              final scaffoldMessengerState = ScaffoldMessenger.of(context);
              toFormScreen();
              final dataString =
                  await context.read<PageManager>().waitForResult();

              scaffoldMessengerState.showSnackBar(
                SnackBar(content: Text("My name is $dataString")),
              );
            },
            icon: const Icon(Icons.quiz),
          )
        ],
      ),
      body: ListView(
        children: [
          for (var quote in quotes)
            ListTile(
              title: Text(quote.author),
              subtitle: Text(quote.quote),
              isThreeLine: true,
              onTap: () => onTapped(quote.id),
            )
        ],
      ),
    );
  }
}