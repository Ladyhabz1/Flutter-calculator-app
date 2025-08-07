// Import necessary Flutter packages
import 'package:flutter/material.dart'; // For UI components and Material Design
import 'dart:math'; // For mathematical operations like sqrt() and pow()

// Entry point of the Flutter application
void main() {
  runApp(CalculatorApp()); // Launch the calculator app
}

// Main app widget - defines the overall app structure and theme
class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scientific Calculator', // App title shown in task switcher
      
      // Dark theme configuration with custom colors
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
        primaryColor: Colors.tealAccent, // Main accent color
        
        // Custom styling for all elevated buttons in the app
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // White text on buttons
            backgroundColor: Colors.teal, // Teal background for buttons
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Button padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded button corners
            ),
            textStyle: const TextStyle(fontSize: 18), // Button text size
          ),
        ),
      ),
      
      home: const CalculatorScreen(), // Main screen of the app
      debugShowCheckedModeBanner: false, // Hide debug banner in top-right corner
    );
  }
}

// Main calculator screen - this is a StatefulWidget because it needs to manage changing data
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

// State class that manages the calculator's data and behavior
class _CalculatorScreenState extends State<CalculatorScreen> {
  // Text controllers to manage input from the text fields
  final TextEditingController _controller1 = TextEditingController(); // First number input
  final TextEditingController _controller2 = TextEditingController(); // Second number input
  
  // State variables to track calculator status
  String _result = ''; // Stores the calculation result to display
  String _error = ''; // Stores error messages to display
  String _selectedOperation = ''; // Tracks which operation was selected
  
  // Main calculation method - performs the selected mathematical operation
  void _calculate(String operation) {
    // Try to convert text input to numbers, returns null if invalid
    double? num1 = double.tryParse(_controller1.text);
    double? num2 = double.tryParse(_controller2.text);

    // Update the UI state
    setState(() {
      _selectedOperation = operation; // Remember which operation is active
      _error = ''; // Clear any previous error messages
      _result = ''; // Clear previous results

      // Special case for square root - only needs one number
      if (operation == '√') {
        if (num1 == null) {
          _error = 'Enter a number in the first field.';
          return; // Exit early if no valid number
        }
        _result = '√$num1 = ${sqrt(num1)}'; // Calculate and display square root
        return;
      }

      // For all other operations, we need two valid numbers
      if (num1 == null || num2 == null) {
        _error = 'Please enter valid numbers.';
        return; // Exit early if either number is invalid
      }

      // Perform the selected mathematical operation
      switch (operation) {
        case '+':
          _result = '$num1 + $num2 = ${num1 + num2}'; // Addition
          break;
        case '-':
          _result = '$num1 - $num2 = ${num1 - num2}'; // Subtraction
          break;
        case '×':
          _result = '$num1 × $num2 = ${num1 * num2}'; // Multiplication
          break;
        case '÷':
          // Check for division by zero to prevent errors
          if (num2 == 0) {
            _error = 'Cannot divide by zero';
            return;
          }
          _result = '$num1 ÷ $num2 = ${num1 / num2}'; // Division
          break;
        case '^':
          _result = '$num1 ^ $num2 = ${pow(num1, num2)}'; // Power/exponentiation
          break;
        case '%':
          _result = '$num1 % $num2 = ${num1 % num2}'; // Modulo (remainder)
          break;
        default:
          _error = 'Unknown operation'; // Fallback for unexpected operations
      }
    });
  }

  // Clear all inputs and results - reset calculator to initial state
  void _clear() {
    setState(() {
      _controller1.clear(); // Clear first input field
      _controller2.clear(); // Clear second input field
      _result = ''; // Clear result display
      _error = ''; // Clear error messages
      _selectedOperation = ''; // Clear selected operation
    });
  }

  // Helper method to create operation buttons with consistent styling
  Widget _operationButton(String symbol) {
    return ElevatedButton(
      onPressed: () => _calculate(symbol), // Call calculate when pressed
      child: Text(symbol), // Display the operation symbol
    );
  }

  // Build the user interface
  @override
  Widget build(BuildContext context) {
    // Check if current operation only needs one input (like square root)
    final isSingleInput = _selectedOperation == '√';

    return Scaffold(
      // App bar at the top with title
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
        centerTitle: true, // Center the title
      ),
      
      // Main body content
      body: SingleChildScrollView( // Allows scrolling if content is too tall
        padding: const EdgeInsets.all(20), // Add padding around everything
        
        child: Card( // Card container for elevated appearance
          elevation: 12, // Shadow depth
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
          color: const Color(0xFF1E1E1E), // Dark card background
          
          child: Padding(
            padding: const EdgeInsets.all(20), // Internal padding
            
            child: Column( // Vertical layout of all components
              children: [
                // Calculator icon at the top
                const Icon(Icons.calculate, size: 60, color: Colors.tealAccent),
                const SizedBox(height: 20), // Spacing
                
                // First number input field
                TextField(
                  controller: _controller1, // Connect to controller for text management
                  keyboardType: TextInputType.number, // Show numeric keyboard
                  style: const TextStyle(color: Colors.white), // White text
                  decoration: const InputDecoration(
                    labelText: 'First number', // Field label
                    labelStyle: TextStyle(color: Colors.tealAccent), // Label color
                    border: OutlineInputBorder(), // Border around field
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent), // Teal border when focused
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Spacing
                
                // Second number input field (only show if operation needs two inputs)
                if (!isSingleInput)
                  TextField(
                    controller: _controller2, // Connect to second controller
                    keyboardType: TextInputType.number, // Numeric keyboard
                    style: const TextStyle(color: Colors.white), // White text
                    decoration: const InputDecoration(
                      labelText: 'Second number', // Field label
                      labelStyle: TextStyle(color: Colors.tealAccent), // Label color
                      border: OutlineInputBorder(), // Border
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.tealAccent), // Focused border color
                      ),
                    ),
                  ),
                const SizedBox(height: 20), // Spacing
                
                // Operation buttons arranged in a wrap layout (flows to next line when needed)
                Wrap(
                  spacing: 10, // Horizontal spacing between buttons
                  runSpacing: 10, // Vertical spacing between rows
                  alignment: WrapAlignment.center, // Center the buttons
                  children: [
                    _operationButton('+'), // Addition button
                    _operationButton('-'), // Subtraction button
                    _operationButton('×'), // Multiplication button
                    _operationButton('÷'), // Division button
                    _operationButton('^'), // Power button
                    _operationButton('%'), // Modulo button
                    _operationButton('√'), // Square root button
                  ],
                ),
                const SizedBox(height: 20), // Spacing
                
                // Clear button with different styling (red background)
                ElevatedButton.icon(
                  onPressed: _clear, // Call clear method when pressed
                  icon: const Icon(Icons.refresh), // Refresh icon
                  label: const Text('Clear'), // Button text
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // Red background to indicate clearing
                  ),
                ),
                const SizedBox(height: 20), // Spacing
                
                // Error message display (only shows when there's an error)
                if (_error.isNotEmpty)
                  Text(
                    _error,
                    style: const TextStyle(color: Colors.red, fontSize: 16), // Red error text
                  ),
                
                // Result display (only shows when there's a result)
                if (_result.isNotEmpty)
                  Text(
                    _result,
                    style: const TextStyle(
                      color: Colors.tealAccent, // Teal accent color
                      fontSize: 22, // Larger font for result
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                    textAlign: TextAlign.center, // Center the result text
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}