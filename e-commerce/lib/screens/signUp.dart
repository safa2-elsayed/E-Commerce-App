import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'resetPassword.dart';
import '../cubits/auth/auth_cubit.dart';
import '../cubits/auth/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final rememberMe = context.watch<AuthCubit>().rememberMe;

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Create your account',
                                style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 30),

                              _buildLabel("Username"),
                              _buildTextField(
                                controller: _usernameController,
                                hintText: "Enter your username",
                                validator: (value) =>
                                value!.isEmpty ? 'Please enter your username' : null,
                              ),
                              const SizedBox(height: 20),

                              _buildLabel("Email Address"),
                              _buildTextField(
                                controller: _emailController,
                                hintText: "Enter your email",
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) =>
                                value!.contains('@') ? null : 'Please enter a valid email',
                              ),
                              const SizedBox(height: 20),

                              _buildLabel("Password"),
                              _buildTextField(
                                controller: _passwordController,
                                hintText: "Enter your password",
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () =>
                                      setState(() => _obscurePassword = !_obscurePassword),
                                ),
                                validator: (value) => value!.length < 6
                                    ? 'Password must be at least 6 characters'
                                    : null,
                              ),
                              const SizedBox(height: 20),

                              _buildLabel("Confirm Password"),
                              _buildTextField(
                                controller: _confirmPasswordController,
                                hintText: "Confirm your password",
                                obscureText: _obscureConfirmPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => setState(() =>
                                  _obscureConfirmPassword = !_obscureConfirmPassword),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) return 'Please confirm your password';
                                  if (value != _passwordController.text) return 'Passwords do not match';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const ResetPasswordScreen()),
                                    );
                                  },
                                  child: Text(
                                    "Forget Password?",
                                    style: GoogleFonts.inter(color: Colors.red, fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Remember me
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Remember me",
                                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
                                  ),
                                  Switch(
                                    value: rememberMe,
                                    onChanged: (val) {
                                      context.read<AuthCubit>().toggleRememberMe(val);
                                    },
                                    activeColor: const Color(0xFF9775FA),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Sign up button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().signUp(
                              username: _usernameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9775FA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                          'Sign Up',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF9775FA),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF9775FA)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
