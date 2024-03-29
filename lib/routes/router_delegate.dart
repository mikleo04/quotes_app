import 'package:advance_navigation_2/db/auth_repository.dart';
import 'package:advance_navigation_2/model/page_configuration.dart';
import 'package:advance_navigation_2/model/quote.dart';
import 'package:advance_navigation_2/screen/LoginScreen.dart';
import 'package:advance_navigation_2/screen/RegisterScreen.dart';
import 'package:advance_navigation_2/screen/SplashScreen.dart';
import 'package:advance_navigation_2/screen/from_screen.dart';
import 'package:advance_navigation_2/screen/quote_detail_screen.dart';
import 'package:advance_navigation_2/screen/quote_list_screen.dart';
import 'package:flutter/material.dart';

class MyRouterDelegate extends RouterDelegate<PageConfiguration>
  with ChangeNotifier, PopNavigatorRouterDelegateMixin {

    final GlobalKey<NavigatorState> _navigatorKey;
    final AuthRepository authRepository;
    MyRouterDelegate(
        this.authRepository
        ) : _navigatorKey = GlobalKey<NavigatorState>() {
      _init();
    }

    _init() async {
      isLoggedIn = await authRepository.isLoggedIn();
      notifyListeners();
    }

    // first override router delegate
    @override
    GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

    String? selectedQuote;  // state halaman membutuhkan data dari halaman sebelumnya (non bool)
    bool isForm = false; // state halaman tidak membutuhkan data dari halaman sebelumnya (bool)

    List<Page> historyStack = [];
    bool? isLoggedIn;
    bool isRegister = false;
    bool? isUnknown;

    // second override router delegate
    @override
    Widget build(BuildContext context) {
      if (isLoggedIn == null) {
        historyStack = _splashStack;
      } else if (isLoggedIn == true) {
        historyStack = _loggedInStack;
      } else {
        historyStack = _loggedOutStack;
      }
      return Navigator (
        key: navigatorKey,
        pages: historyStack,
        onPopPage: (route, result) {
          final didPop = route.didPop(result);
          if (!didPop) {
            return false;
          }

          isRegister = false;
          selectedQuote = null;
          isForm = false;
          notifyListeners();

          return true;
        },
      );
    }

    // third override router delegate
    @override
    Future<void> setNewRoutePath(PageConfiguration configuration) async {
      if (configuration.isUnknownPage) {
        isUnknown = true;
        isRegister = false;
      } else if (configuration.isRegisterPage) {
        isRegister = true;
      }else if (configuration.isHomePage ||
          configuration.isLoginPage ||
          configuration.isSplashPage) {
        isUnknown = false;
        selectedQuote = null;
        isRegister = false;
      } else if (configuration.isDetailPage) {
        isUnknown = false;
        isRegister = false;
        selectedQuote = configuration.quoteId.toString();
      } else {
        print(' Could not set new route');
      }
      notifyListeners();
    }

    @override
    PageConfiguration? get currentConfiguration {
      if (isLoggedIn == null) {
        return PageConfiguration.splash();
      } else if (isRegister == true) {
        return PageConfiguration.resgister();
      } else if (isLoggedIn == false) {
        return PageConfiguration.login();
      } else if (isUnknown == true) {
        return PageConfiguration.unknown();
      } else if (selectedQuote == null) {
        return PageConfiguration.home();
      } else if (selectedQuote != null) {
        return PageConfiguration.detailQuote(selectedQuote!);
      } else {
        return null;
      }
    }

    List<Page> get _splashStack => const [
      MaterialPage(
        key: ValueKey("SplashPage"),
        child: SplashScreen()
      )
    ];

    List<Page> get _loggedOutStack => [
      MaterialPage(
        key: const ValueKey("LoginPage"),
        child: LoginScreen(
          onLogin: () {
            isLoggedIn = true;
            notifyListeners();
          },
          onRegister: () {
            isRegister = true;
            notifyListeners();
          },
        ),
      ),
      if (isRegister == true)
        MaterialPage(
          key: const ValueKey("RegisterPage"),
          child: RegisterScreen(
            onRegister: () {
              isRegister = false;
              notifyListeners();
            },
            onLogin: () {
              isRegister = false;
              notifyListeners();
            },
          )
        )
    ];

    List<Page> get _loggedInStack => [
      MaterialPage(
        key: const ValueKey("QuoteListPage"),
        child: QuotesListScreen(
          quotes: quotes,
          onTapped: (String quoteId) {
            selectedQuote = quoteId;
            notifyListeners();
          },
          toFormScreen: () {
            isForm = true;
            notifyListeners();
          },
          onLogout: () {
            isLoggedIn = false;
            notifyListeners();
          },
        ),
      ),
      if (selectedQuote != null)
        QuoteDetailsPage(
          key: ValueKey(selectedQuote),
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
    ];

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