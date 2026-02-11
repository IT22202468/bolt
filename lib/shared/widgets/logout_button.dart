import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.logout),
      label: const Text('Log Out'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFFF0000),
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Color(0xFFFF0000), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
