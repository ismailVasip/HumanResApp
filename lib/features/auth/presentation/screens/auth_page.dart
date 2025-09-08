import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ikproject/features/auth/presentation/widgets/logo.dart';
import 'package:ikproject/features/auth/presentation/widgets/text_field.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<AuthPage> {
  bool isSignUpSelected = true;
  bool isShowPasswordClicked = false;

  final TextEditingController _signUpFullNameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController = TextEditingController();

  final TextEditingController _signInEmailController = TextEditingController();
  final TextEditingController _signInPasswordController = TextEditingController();

  @override
  void dispose() {
    _signUpFullNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }

            if (state is AuthSuccess) {
              Navigator.pushReplacementNamed(context, '/roleCheckPage');
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return SafeArea(
              child: ConstrainedBox(//kaydırma alanını tam ekran yaptım
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(//çocuğun yüksekliğine göre kendini ayarlamasına izin verdim
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //logo
                      AuthLogo(),

                      const SizedBox(height: 25),

                      // login!
                      Text(
                        isSignUpSelected ? 'Kayıt Ol' : 'Giriş Yap',
                        style: TextStyle(color: Colors.grey[700], fontSize: 23),
                      ),

                      const SizedBox(height: 25),

                      //fields
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black, blurRadius: 4),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isSignUpSelected = true;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSignUpSelected
                                          ? Colors.black
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 24,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.people_sharp,
                                          color: isSignUpSelected
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Kayıt Ol",
                                          style: TextStyle(
                                            color: isSignUpSelected
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isSignUpSelected = false;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSignUpSelected
                                          ? Colors.white
                                          : Colors.black,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 24,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.admin_panel_settings_sharp,
                                          color: isSignUpSelected
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Giriş Yap",
                                          style: TextStyle(
                                            color: isSignUpSelected
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 12),

                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: isSignUpSelected
                                  ? _buildSignUpContent(isLoading)
                                  : _buildLoginContent(isLoading),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSignUpContent(bool isLoading) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          MyTextFormfield(
            controller: _signUpFullNameController,
            hintText: 'Ad - Soyad',
            obscureText: false,
          ),
          const SizedBox(height: 16),
          MyTextFormfield(
            controller: _signUpEmailController,
            hintText: 'E-posta',
            obscureText: false,
          ),
          const SizedBox(height: 16),
          MyTextFormfield(
            controller: _signUpPasswordController,
            hintText: 'Şifre',
            obscureText: true,
            showPasswordFunc: (){
              setState(() {
                isShowPasswordClicked = !isShowPasswordClicked;
              });
            },
            showPassword: isShowPasswordClicked,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    final email = _signUpEmailController.text.trim();
                    final password = _signUpPasswordController.text.trim();
                    final fullName = _signUpFullNameController.text.trim();

                    context.read<AuthBloc>().add(
                      AuthSignUp(fullName, email, password),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(300, 50),
            ),
            child: isLoading
                ? CircularProgressIndicator()
                : Text(
                    "Kayıt Ol",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginContent(bool isLoading) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          MyTextFormfield(
            controller: _signInEmailController,
            hintText: 'E-posta',
            obscureText: false,
          ),
          const SizedBox(height: 16),
          MyTextFormfield(
            controller: _signInPasswordController,
            hintText: 'Şifre',
            obscureText: true,
            showPasswordFunc: (){
              setState(() {
                isShowPasswordClicked = !isShowPasswordClicked;
              });
            },
            showPassword: isShowPasswordClicked,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    final email = _signInEmailController.text.trim();
                    final password = _signInPasswordController.text.trim();

                    context.read<AuthBloc>().add(AuthSignIn(email, password));
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(300, 50),
            ),
            child: isLoading
                ? CircularProgressIndicator()
                : Text(
                    "Giriş Yap",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
