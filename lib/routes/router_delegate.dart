import 'package:advance_navigation_2/model/quote.dart';
import 'package:advance_navigation_2/screen/from_screen.dart';
import 'package:advance_navigation_2/screen/quote_detail_screen.dart';
import 'package:advance_navigation_2/screen/quote_list_screen.dart';
import 'package:flutter/material.dart';

class MyRouterDelegate extends RouterDelegate
  with ChangeNotifier, PopNavigatorRouterDelegateMixin {

    final GlobalKey<NavigatorState> _navigatorKey;
    MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

    @override
    GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

    String? selectedQuote;  // state halaman membutuhkan data dari halaman sebelumnya (non bool)
    bool isForm = false; // state halaman tidak membutuhkan data dari halaman sebelumnya (bool)

    @override
    Widget build(BuildContext context) {
      return Navigator (
        key: navigatorKey,
        pages: [
          MaterialPage(
            key: const ValueKey("QuoteListPage"),
            child: QuotesListScreen(quotes: quotes,
              onTapped: (String quoteId) {
                selectedQuote = quoteId;
                notifyListeners();
              },
              toFormScreen: () {
                isForm = true;
                notifyListeners();
              },
            ),
          ),
          if (selectedQuote != null)
            QuoteDetailsPage(
                key: ValueKey("QuoteDetailsPage-$selectedQuote"),
                child: QuoteDetailsScreen(
                  quoteId: selectedQuote!,
                )
            ),
          if (isForm)
            MaterialPage(
              key: ValueKey("FormScreen"),
              child: FormScreen(
                onSend: () {
                  isForm = false;
                  notifyListeners();
                },
              )
            ),
        ],
        onPopPage: (route, result) {
          final didPop = route.didPop(result);
          if (!didPop) {
            return false;
          }

          selectedQuote = null;
          isForm = false;
          notifyListeners();

          return true;
        },
      );
      throw UnimplementedError();
    }

    @override
    Future<void> setNewRoutePath(configuration) async {

    }
  }

class QuoteDetailsPage extends Page {
  final Widget child;

  const QuoteDetailsPage({
    LocalKey? key,
    required this.child,
  }) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        final tween = Tween(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        );
        final curveTween = CurveTween(curve: Curves.easeInOut);
        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: child,
        );
      },
    );
  }
}