import 'dart:async';
import 'package:bolt/features/Goal_Run/active_run_page.dart';
import 'package:flutter/material.dart';

class GoalRunPage extends StatefulWidget {
  const GoalRunPage({super.key});

  @override
  State<GoalRunPage> createState() => _GoalRunPageState();
}

class _GoalRunPageState extends State<GoalRunPage>
    with SingleTickerProviderStateMixin {
  bool _isDistanceSelected = true;
  bool _isCountingDown = false;

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
  }

  void _startCountdown() {
    setState(() {
      _isCountingDown = true;
    });
    _animationController.forward(from: 0);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
        _animationController.forward(from: 0);
      } else {
        timer.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ActiveGoalRunPage(isDistanceGoal: _isDistanceSelected),
          ),
        );
      }
    });
  }

  void _cancelCountdown() {
    _countdownTimer.cancel();
    setState(() {
      _isCountingDown = false;
      _countdown = 3;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (_countdownTimer.isActive) {
      _countdownTimer.cancel();
    }
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isCountingDown ? _buildCountdownUI() : _buildSetupUI(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSetupUI() {
    return Column(
      key: const ValueKey('setup'),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildGoalTypeSelector(),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isDistanceSelected ? _buildDistanceInputs() : _buildTimeInputs(),
        ),
        const Spacer(),
        _buildStartRunButton(),
        const SizedBox(height: 8),
        _buildCancelButton(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCountdownUI() {
    return Column(
      key: const ValueKey('countdown'),
      children: [
        _buildHeader(),
        _buildTipCard(),
        const Spacer(),
        _buildCountdown(),
        const Spacer(),
        _buildCancelButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _isCountingDown ? 'Starting Soon' : 'Goal Run',
          style: const TextStyle(
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
    );
  }

  Widget _buildGoalTypeSelector() {
    return Container(
      height: 50,
      width: 280,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment:
                _isDistanceSelected ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: 140,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF0088FF),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isDistanceSelected = true),
                  child: Center(
                    child: Text(
                      'Distance',
                      style: TextStyle(
                        color:
                            _isDistanceSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isDistanceSelected = false),
                  child: Center(
                    child: Text(
                      'Time',
                      style: TextStyle(
                        color:
                            !_isDistanceSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
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

  Widget _buildDistanceInputs() {
    return Column(
      key: const ValueKey('distance'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distance',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInputField('kms')),
            const SizedBox(width: 16),
            Expanded(child: _buildInputField('m')),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeInputs() {
    return Column(
      key: const ValueKey('time'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInputField('hrs')),
            const SizedBox(width: 16),
            Expanded(child: _buildInputField('mins')),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField(String hint) {
    return TextField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(vertical: 24),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xFF0088FF), width: 2),
        ),
      ),
    );
  }

  Widget _buildStartRunButton() {
    return OutlinedButton.icon(
      onPressed: _startCountdown,
      icon: const Icon(Icons.directions_run),
      label: const Text('Start Run'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF0088FF),
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Color(0xFF0088FF), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildCancelButton() {
    return OutlinedButton.icon(
      onPressed: () {
        if (_isCountingDown) {
          _cancelCountdown();
        } else if (Navigator.canPop(context)) {
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
            fontSize: 120,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0088FF),
          ),
        ),
      ),
    );
  }
}
