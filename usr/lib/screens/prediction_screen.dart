import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> with SingleTickerProviderStateMixin {
  bool _isAnalyzing = false;
  bool _showResult = false;
  String _statusText = "Ready for Wingo 30s";
  int _predictedNumber = 0;
  String _predictedSize = "";
  String _predictedColor = "";
  String _confidence = "0%";
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startPrediction() {
    setState(() {
      _isAnalyzing = true;
      _showResult = false;
      _statusText = "Syncing with Amar Club...";
    });

    // Simulate analysis steps - faster for 30s game
    Timer(const Duration(milliseconds: 800), () {
      setState(() => _statusText = "Analyzing 30s Trend...");
    });

    Timer(const Duration(milliseconds: 1600), () {
      setState(() => _statusText = "Calculating Next Result...");
    });

    Timer(const Duration(seconds: 3), () {
      _generateResult();
    });
  }

  void _generateResult() {
    setState(() {
      _isAnalyzing = false;
      _showResult = true;
      _statusText = "Prediction Ready";
      
      // Wingo Logic: 0-9
      _predictedNumber = Random().nextInt(10); 
      
      // Determine Size (0-4 Small, 5-9 Big)
      _predictedSize = _predictedNumber >= 5 ? "BIG" : "SMALL";
      
      // Determine Color
      // 0: Red+Violet, 5: Green+Violet
      // 1,3,7,9: Green
      // 2,4,6,8: Red
      if (_predictedNumber == 0) {
        _predictedColor = "Red + Violet";
      } else if (_predictedNumber == 5) {
        _predictedColor = "Green + Violet";
      } else if ([1, 3, 7, 9].contains(_predictedNumber)) {
        _predictedColor = "Green";
      } else {
        _predictedColor = "Red";
      }

      _confidence = "${88 + Random().nextInt(12)}%"; // 88-99%
    });
  }

  Color _getColorForText(String colorName) {
    if (colorName.contains("Green")) return Colors.green;
    if (colorName.contains("Red")) return Colors.red;
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WINGO 30S AI'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_showResult && !_isAnalyzing) ...[
              const Icon(Icons.timer_3_outlined, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                "Amar Club Wingo 30s Predictor\nTap below to analyze the current period.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const Spacer(),
              _buildPredictButton(),
              const SizedBox(height: 40),
            ] else if (_isAnalyzing) ...[
              const Spacer(),
              RotationTransition(
                turns: _controller,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFD700),
                      width: 4,
                      style: BorderStyle.solid,
                    ),
                    gradient: const LinearGradient(
                      colors: [Colors.transparent, Color(0xFFFFD700)],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _statusText,
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const LinearProgressIndicator(
                backgroundColor: Color(0xFF333333),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
              ),
              const Spacer(),
            ] else if (_showResult) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFFFD700), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "NEXT RESULT PREDICTION",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Number Display
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getColorForText(_predictedColor).withOpacity(0.2),
                            border: Border.all(color: _getColorForText(_predictedColor), width: 3),
                          ),
                          child: Center(
                            child: Text(
                              _predictedNumber.toString(),
                              style: TextStyle(
                                color: _getColorForText(_predictedColor),
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Details Display
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _predictedSize,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _predictedColor,
                              style: TextStyle(
                                color: _getColorForText(_predictedColor),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Win Probability: $_confidence",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Bet responsibly. This is a statistical prediction.",
                style: TextStyle(color: Colors.white38),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showResult = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "NEXT PERIOD",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPredictButton() {
    return GestureDetector(
      onTap: _startPrediction,
      child: Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.touch_app, color: Colors.black, size: 30),
            SizedBox(width: 15),
            Text(
              "GET LUCKY NUMBER",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
