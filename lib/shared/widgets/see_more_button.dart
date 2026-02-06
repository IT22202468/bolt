import 'package:flutter/material.dart';

class SeeMoreButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool hasMoreData;

  const SeeMoreButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.hasMoreData = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasMoreData) {
      return const SizedBox.shrink();
    }

    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withOpacity(0.7),
                ),
              ),
            )
          : const Icon(Icons.keyboard_arrow_down),
      label: Text(isLoading ? 'Loading...' : 'See more'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF0088FF),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
