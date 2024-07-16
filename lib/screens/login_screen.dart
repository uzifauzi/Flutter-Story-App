import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../provider/api_provider.dart';
import '../provider/auth_provider.dart';
import '../utils/enum.dart';
import '../widgets/text_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.titleApp,
                style: GoogleFonts.parisienne()
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(AppLocalizations.of(context)!.titleLogin),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextInput(
                      textEditingController: emailController,
                      title: 'Email',
                      hintText: AppLocalizations.of(context)!.emailInput,
                      textInputType: TextInputType.emailAddress,
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email.';
                        } else if (!RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return AppLocalizations.of(context)!.emailWarning;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextInput(
                      textEditingController: passwordController,
                      title: 'Password',
                      hintText: AppLocalizations.of(context)!.passwordInput,
                      textInputType: TextInputType.emailAddress,
                      obsecureText: true,
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inputan password tidak boleh kosong.';
                        } else if (value.length < 8) {
                          return 'Buat password dengan panjang minimal 8 karakter.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Consumer2<ApiProvider, AuthProvider>(
                        builder: (ctx, apiState, authState, _) {
                      if (apiState.state == ResultState.loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return AnimatedOpacity(
                          opacity:
                              apiState.state == ResultState.loading ? 0.5 : 1.0,
                          duration: const Duration(milliseconds: 500),
                          child: IgnorePointer(
                            ignoring: apiState.state == ResultState.loading,
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width / 2,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child:
                                    Text(AppLocalizations.of(context)!.loginBtn,
                                        style: GoogleFonts.quicksand(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        )),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    final email = emailController.text;
                                    final password = passwordController.text;

                                    final scaffoldMessenger =
                                        ScaffoldMessenger.of(context);

                                    try {
                                      final result = await apiState.fetchLogin(
                                          email, password);

                                      final loginResult = result.loginResult;
                                      authState
                                          .setLoginToken(loginResult.token);
                                      scaffoldMessenger.showSnackBar(
                                        SnackBar(content: Text(result.message)),
                                      );

                                      if (ctx.mounted) {
                                        ctx.goNamed('home');
                                      }
                                    } catch (error) {
                                      scaffoldMessenger.showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Login gagal: $error')),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                    const SizedBox(height: 15),
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black87),
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.accountAsked,
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                                text: AppLocalizations.of(context)!.regisNow,
                                style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.goNamed('register');
                                  })
                          ]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
