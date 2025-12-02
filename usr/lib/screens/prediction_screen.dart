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
  String _statusText = "Ready to Analyze";
  int _predictedNumber = 0;
  String _confidence = "0%";
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
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
      _statusText = "Connecting to Server...";
    });

    // Simulate analysis steps
    Timer(const Duration(seconds: 1), () {
      setState(() => _statusText = "Analyzing Past Trends...");
    });

    Timer(const Duration(seconds: 3), () {
      setState(() => _statusText = "Calculating Probabilities...");
    });

    Timer(const Duration(seconds: 5), () {
      setState(() {
        _isAnalyzing = false;
        _showResult = true;
        _statusText = "Analysis Complete";
        _predictedNumber = Random().nextInt(100); // Generates 0-99
        _confidence = "${85 + Random().nextInt(15)}%"; // 85-99%
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI PREDICTION'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_showResult && !_isAnalyzing) ...[
              const Icon(Icons.analytics_outlined, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                "Tap the button below to generate today's lucky winning number using our advanced AI algorithm.",
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
                padding: const EdgeInsets.all(30),
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
                      "PREDICTED NUMBER",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _predictedNumber.toString().padLeft(2, '0'),
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Confidence: $_confidence",
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
                "This prediction is valid for the next 2 hours.",
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
                    "TRY AGAIN",
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
              "START ANALYSIS",
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
