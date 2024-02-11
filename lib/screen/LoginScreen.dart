import 'package:advance_navigation_2/model/user.dart';
import 'package:advance_navigation_2/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "EMail",
                  ),
                ),
                const SizedBox(height: 8,),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password"
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8,),
                context.watch<AuthProvider>().isLoadingLogin
                    ? const Center(child: CircularProgressIndicator(),)
                    : ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final User user = User(
                        email: emailController.text,
                        password: passwordController.text
                      );
                      final authRead = context.read<AuthProvider>();

                      final result = await authRead.login(user);
                      if (result) {
                        widget.onLogin();
                      } else {
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text("Your email or password is invalid")
                          ),
                        );
                      }
                    }
                  },
                  child: const Text("Login"),
                ),
                const SizedBox(height: 8,),
                OutlinedButton(
                  onPressed: () => widget.onRegister(),
                  child: const Text("REGISTER")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}