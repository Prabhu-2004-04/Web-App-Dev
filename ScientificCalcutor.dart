import 'package:flutter/material.dart';
import 'dart:math';
 
void main() {
  runApp(ScientificCalculatorApp());
}
 
class ScientificCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scientific Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScientificCalculator(),
    );
  }
}
 
class ScientificCalculator extends StatefulWidget {
  @override
  _ScientificCalculatorState createState() => _ScientificCalculatorState();
}
 
class _ScientificCalculatorState extends State<ScientificCalculator> {
  String _output = "0";
  String _currentInput = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operator = "";
 
  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentInput = "";
        _num1 = 0;
        _num2 = 0;
        _operator = "";
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "×" || buttonText == "÷") {
        _num1 = double.parse(_currentInput);
        _operator = buttonText;
        _currentInput = "";
      } else if (buttonText == "=") {
        _num2 = double.parse(_currentInput);
        switch (_operator) {
          case "+":
            _output = (_num1 + _num2).toString();
            break;
          case "-":
            _output = (_num1 - _num2).toString();
            break;
          case "×":
            _output = (_num1 * _num2).toString();
            break;
          case "÷":
            _output = (_num1 / _num2).toString();
            break;
        }
        _currentInput = _output;
        _num1 = 0;
        _num2 = 0;
        _operator = "";
      } else if (buttonText == "√") {
        _output = sqrt(double.parse(_currentInput)).toString();
        _currentInput = _output;
      } else if (buttonText == "^") {
        _num1 = double.parse(_currentInput);
        _operator = buttonText;
        _currentInput = "";
      } else if (buttonText == "sin") {
        _output = sin(double.parse(_currentInput) * (pi / 180)).toString();
        _currentInput = _output;
      } else if (buttonText == "cos") {
        _output = cos(double.parse(_currentInput) * (pi / 180)).toString();
        _currentInput = _output;
      } else if (buttonText == "tan") {
        _output = tan(double.parse(_currentInput) * (pi / 180)).toString();
        _currentInput = _output;
      } else {
        _currentInput += buttonText;
        _output = _currentInput;
      }
    });
  }
 
  Widget _buildButton(String buttonText) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scientific Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Text(
                _output,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton("sin"),
                    _buildButton("cos"),
                    _buildButton("tan"),
                    _buildButton("√"),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("7"),
                    _buildButton("8"),
                    _buildButton("9"),
                    _buildButton("÷"),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("4"),
                    _buildButton("5"),
                    _buildButton("6"),
                    _buildButton("×"),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("1"),
                    _buildButton("2"),
                    _buildButton("3"),
                    _buildButton("-"),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("0"),
                    _buildButton("."),
                    _buildButton("C"),
                    _buildButton("+"),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("^"),
                    _buildButton("="),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}