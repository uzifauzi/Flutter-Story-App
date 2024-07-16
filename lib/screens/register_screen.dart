import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/models/user_model.dart';
import '../provider/api_provider.dart';
import '../utils/enum.dart';
import '../widgets/text_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: IconButton(
          onPressed: () {
            context.goNamed('login');
          },
          icon: const Icon(Icons.arrow_back)),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.titleApp,
                  style: GoogleFonts.parisienne()
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 28),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(AppLocalizations.of(context)!.titleRegister),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(height: 15),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextInput(
                          textEditingController: nameController,
                          title: 'Nama',
                          hintText: AppLocalizations.of(context)!.nameInput,
                          onValidate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Input nama tidak boleh kosong!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextInput(
                          textEditingController: emailController,
                          title: 'Email',
                          hintText: AppLocalizations.of(context)!.emailInput,
                          textInputType: TextInputType.emailAddress,
                          onValidate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan email anda.';
                            } else if (!RegExp(
                                    r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return (AppLocalizations.of(context)!
                                  .emailWarning);
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
                        Consumer<ApiProvider>(
                          builder: (ctx, apiState, _) {
                            if (apiState.state == ResultState.loading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return SizedBox(
                                width: MediaQuery.sizeOf(context).width / 2,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      final scaffoldMessenger =
                                          ScaffoldMessenger.of(context);
                                      final userModel = UserModel(
                                        nameController.text,
                                        emailController.text,
                                        passwordController.text,
                                      );

                                      try {
                                        final response = await apiState
                                            .fetchRegister(userModel);

                                        if (ctx.mounted) {
                                          scaffoldMessenger.showSnackBar(
                                              SnackBar(
                                                  content:
                                                      Text(response.message)));

                                          ctx.goNamed('login');
                                        }
                                      } catch (e) {
                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Register gagal: ${e.toString()}')),
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.registerBtn,
                                    style: GoogleFonts.quicksand(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
