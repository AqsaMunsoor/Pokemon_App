import 'package:flutter/material.dart';
import 'package:pokemon_app/helpers/files_exports.dart';

import 'package:pokemon_app/helpers/packages_export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/back.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 100,
          leading: Image.asset(
            'assets/icon.png',
          ),
          title: const Text(
            'Log In',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              letterSpacing: 5,
              fontFamily: 'Pokemon',
              color: Colors.blue,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FormBuilder(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white54,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FormBuilderTextField(
                          name: 'email',
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.blue,
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                          ]),
                        ),
                        const Gutter(),
                        FormBuilderTextField(
                          name: 'password',
                          decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(
                                Icons.lock_outlined,
                                color: Colors.blue,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.blue,
                                ),
                              )),
                          obscureText: _obscureText,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                        ),
                        const Gutter(),
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is AuthLoggedInState) {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            } else if (state is AuthErrorState) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(state.errorMessage),
                                backgroundColor: Colors.red,
                                duration: const Duration(milliseconds: 600),
                              ));
                            }
                          },
                          builder: (context, state) {
                            if (state is AuthLoadingState) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.amber,
                                backgroundColor: Colors.blue,
                                // padding: EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8), // Border radius
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.saveAndValidate()) {
                                  final formData = _formKey.currentState!.value;
                                  final email = formData['email'];
                                  final password = formData['password'];

                                  BlocProvider.of<AuthCubit>(context)
                                      .loginWithEmailPassword(email, password);
                                }
                              },
                              child: Text('Login',
                                  style: GoogleFonts.pressStart2p(
                                      fontSize: 10, color: Colors.amber)),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Gutter(),
                Row(
                  children: [
                    Text('Don\'t have an account:',
                        style: GoogleFonts.pressStart2p(
                            fontSize: 10, color: Colors.blue)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()));
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 11,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
