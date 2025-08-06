import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scientific Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.tealAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String _result = '';
  String _error = '';
  String _selectedOperation = '';

  void _calculate(String operation) {
    double? num1 = double.tryParse(_controller1.text);
    double? num2 = double.tryParse(_controller2.text);

    setState(() {
      _selectedOperation = operation;
      _error = '';
      _result = '';

      if (operation == '√') {
        if (num1 == null) {
          _error = 'Enter a number in the first field.';
          return;
        }
        _result = '√$num1 = ${sqrt(num1)}';
        return;
      }

      if (num1 == null || num2 == null) {
        _error = 'Please enter valid numbers.';
        return;
      }

      switch (operation) {
        case '+':
          _result = '$num1 + $num2 = ${num1 + num2}';
          break;
        case '-':
          _result = '$num1 - $num2 = ${num1 - num2}';
          break;
        case '×':
          _result = '$num1 × $num2 = ${num1 * num2}';
          break;
        case '÷':
          if (num2 == 0) {
            _error = 'Cannot divide by zero';
            return;
          }
          _result = '$num1 ÷ $num2 = ${num1 / num2}';
          break;
        case '^':
          _result = '$num1 ^ $num2 = ${pow(num1, num2)}';
          break;
        case '%':
          _result = '$num1 % $num2 = ${num1 % num2}';
          break;
        default:
          _error = 'Unknown operation';
      }
    });
  }

  void _clear() {
    setState(() {
      _controller1.clear();
      _controller2.clear();
      _result = '';
      _error = '';
      _selectedOperation = '';
    });
  }

  Widget _operationButton(String symbol) {
    return ElevatedButton(
      onPressed: () => _calculate(symbol),
      child: Text(symbol),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSingleInput = _selectedOperation == '√';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFF1E1E1E),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.calculate, size: 60, color: Colors.tealAccent),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller1,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'First number',
                    labelStyle: TextStyle(color: Colors.tealAccent),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (!isSingleInput)
                  TextField(
                    controller: _controller2,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Second number',
                      labelStyle: TextStyle(color: Colors.tealAccent),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.tealAccent),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _operationButton('+'),
                    _operationButton('-'),
                    _operationButton('×'),
                    _operationButton('÷'),
                    _operationButton('^'),
                    _operationButton('%'),
                    _operationButton('√'),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _clear,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 20),
                if (_error.isNotEmpty)
                  Text(
                    _error,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                if (_result.isNotEmpty)
                  Text(
                    _result,
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
