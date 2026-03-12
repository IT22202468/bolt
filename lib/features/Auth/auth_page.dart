import 'package:bolt/features/Home_Dashboard/home_dashboard.dart';
import 'package:bolt/features/Auth/forgot_password_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'dart:math';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isSignUpSelected = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _selectedAvatarName = 'BoltUser_${Random().nextInt(1000)}';

  final List<String> _presetAvatars = List.generate(20, (index) => 'Avatar_$index');

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeDashboard()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Sign in failed')),
      );
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_emailController.text == 'n@gmail.com' &&
        _passwordController.text == 'asdf123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select an Avatar',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                    ),
                    itemCount: _presetAvatars.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedAvatarName = _presetAvatars[index]);
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedAvatarName == _presetAvatars[index]
                                  ? const Color(0xFF0A84FF)
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: AvatarPlus(_presetAvatars[index]),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    setState(() => _selectedAvatarName = 'BoltUser_${Random().nextInt(10000)}');
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Generate Random Avatar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A84FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              _buildLogo(),
              const SizedBox(height: 40),
              _buildAuthModeSelector(),
              const SizedBox(height: 32),
              if (_isSignUpSelected) ...[
                _buildAvatarSelection(),
                const SizedBox(height: 32),
              ],
              _buildTextField(
                  label: 'Email',
                  hint: 'your@email.com',
                  controller: _emailController),
              const SizedBox(height: 24),
              _buildTextField(
                  label: 'Password',
                  hint: '********',
                  obscureText: true,
                  controller: _passwordController),
              if (!_isSignUpSelected) _buildForgotPasswordLink(),
              const SizedBox(height: 32),
              _buildPrimaryButton(),
              const SizedBox(height: 16),
              _buildTermsText(),
              const SizedBox(height: 24),
              _buildDivider(),
              const SizedBox(height: 24),
              _buildGoogleButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Image.asset(
        'assets/images/bolt_logo.png',
        height: 40,
        color: Colors.white,
      ),
    );
  }

  Widget _buildAuthModeSelector() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment:
                _isSignUpSelected ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: (MediaQuery.of(context).size.width - 64) / 2,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isSignUpSelected = true),
                  child: Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: _isSignUpSelected
                            ? const Color(0xFF0A84FF)
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isSignUpSelected = false),
                  child: Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: !_isSignUpSelected
                            ? const Color(0xFF0A84FF)
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSelection() {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: _showAvatarPicker,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: AvatarPlus(
                  _selectedAvatarName,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showAvatarPicker,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF57A3FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
          );
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String label,
      required String hint,
      bool obscureText = false,
      required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.white, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton() {
    return ElevatedButton(
      onPressed: _isSignUpSelected ? () {} : _handleSignIn,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF57A3FF),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
      child: Text(
        _isSignUpSelected ? 'Create Account' : 'Sign In',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTermsText() {
    return Text(
      'By continuing, you agree to our Terms and Privacy Policy',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.white54)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('or', style: TextStyle(color: Colors.white.withOpacity(0.8))),
        ),
        const Expanded(child: Divider(color: Colors.white54)),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _handleGoogleSignIn,
      icon: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0A84FF)),
            )
          : Image.asset('assets/images/google_logo.png', height: 24),
      label: Text(_isLoading ? 'Signing in...' : 'Continue with Google'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
