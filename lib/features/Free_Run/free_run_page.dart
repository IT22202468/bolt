import 'dart:async';
import 'package:flutter/material.dart';

class FreeRunPage extends StatefulWidget {
  const FreeRunPage({super.key});

  @override
  State<FreeRunPage> createState() => _FreeRunPageState();
}

class _FreeRunPageState extends State<FreeRunPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Timer _countdownTimer;
  int _countdown = 3;

  final String _tip = 'Stay Hydrated.. Don\'t forget to drink water';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _startCountdown();
  }

  void _startCountdown() {
    _animationController.forward(from: 0);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
        _animationController.forward(from: 0);
      } else {
        timer.cancel();
        // TODO: Navigate to the actual run tracking screen
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Placeholder
          Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.map_outlined, size: 100, color: Colors.grey),
            ),
          ),

          // Bottom Sheet Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, -4),
                  )
                ],
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  _buildTipCard(),
                  const Spacer(),
                  _buildCountdown(),
                  const Spacer(),
                  _buildCancelButton(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Free Run',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Implement settings navigation
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD6ECFF),
        border: Border.all(color: const Color(0xFF0088FF)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _tip,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, color: Color(0xFF0088FF)),
      ),
    );
  }

  Widget _buildCountdown() {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Text(
          _countdown.toString(),
          style: const TextStyle(
            fontSize: 100,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0088FF),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 60),
      child: OutlinedButton.icon(
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        icon: const Icon(Icons.close),
        label: const Text('Cancel'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFFF0000),
          minimumSize: const Size(double.infinity, 50),
          side: const BorderSide(color: Color(0xFFFF0000), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
