import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      home: const ModernCalculatorApp(),
    );
  }
}

class ModernCalculatorApp extends StatefulWidget {
  const ModernCalculatorApp({super.key});

  @override
  State<ModernCalculatorApp> createState() => _ModernCalculatorAppState();
}

class _ModernCalculatorAppState extends State<ModernCalculatorApp> {
  String input = ''; // Expression input by the user
  String output = '0'; // The result/output displayed to the user

  /// Evaluates a mathematical expression manually.
  double evaluateExpression(String expression) {
    // Replace 'x' with '*' for easier parsing.
    expression = expression.replaceAll('x', '*');

    try {
      // Step 1: Handle parentheses recursively.
      while (expression.contains('(')) {
        int openIndex = expression.lastIndexOf('(');
        int closeIndex = expression.indexOf(')', openIndex);
        if (closeIndex == -1) throw Exception("Unmatched parentheses");

        String innerExpression = expression.substring(openIndex + 1, closeIndex);
        double innerResult = evaluateExpression(innerExpression);

        expression = expression.replaceRange(openIndex, closeIndex + 1, innerResult.toString());
      }

      // Step 2: Split by operators and calculate (* and / first, then + and -).
      List<String> tokens = expression.split(RegExp(r'([+\-*/])'));
      for (int i = 0; i < tokens.length; i++) {
        tokens[i] = tokens[i].trim();
      }

      // Step 3: Process multiplication and division.
      for (int i = 0; i < tokens.length; i++) {
        if (tokens[i] == '*' || tokens[i] == '/') {
          double left = double.parse(tokens[i - 1]);
          double right = double.parse(tokens[i + 1]);
          double result = (tokens[i] == '*') ? (left * right) : (left / right);

          tokens.replaceRange(i - 1, i + 2, [result.toString()]);
          i -= 1; // Adjust index for the reduced list.
        }
      }

      // Step 4: Process addition and subtraction.
      double finalResult = double.parse(tokens[0]);
      for (int i = 1; i < tokens.length; i += 2) {
        double nextNumber = double.parse(tokens[i + 1]);
        if (tokens[i] == '+') {
          finalResult += nextNumber;
        } else if (tokens[i] == '-') {
          finalResult -= nextNumber;
        }
      }

      return finalResult;
    } catch (e) {
      throw Exception("Invalid Expression");
    }
  }

  void onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        input = '';
        output = '0';
      } else if (buttonText == '=') {
        try {
          double result = evaluateExpression(input);
          output = result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 2);
        } catch (e) {
          output = 'Error';
        }
      } else {
        input += buttonText;
      }
    });
  }

  Widget createButton(String buttonText, Color textColor, Color buttonColor) {
    return ElevatedButton(
      onPressed: () => onButtonPressed(buttonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
      ),
      child: Text(
        buttonText,
        style: TextStyle(fontSize: 24, color: textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Calculator",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            // Input Display
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                input,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 24,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Output Display
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                output,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Spacer(),

            // Calculator Buttons
            GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              shrinkWrap: true,
              children: [
                createButton('C', Colors.black, Colors.yellow.shade200),
                createButton('(', Colors.black, Colors.grey.shade300),
                createButton(')', Colors.black, Colors.grey.shade300),
                createButton('/', Colors.white, Colors.orange),
                createButton('7', Colors.black, Colors.grey.shade200),
                createButton('8', Colors.black, Colors.grey.shade200),
                createButton('9', Colors.black, Colors.grey.shade200),
                createButton('x', Colors.white, Colors.orange),
                createButton('4', Colors.black, Colors.grey.shade200),
                createButton('5', Colors.black, Colors.grey.shade200),
                createButton('6', Colors.black, Colors.grey.shade200),
                createButton('-', Colors.white, Colors.orange),
                createButton('1', Colors.black, Colors.grey.shade200),
                createButton('2', Colors.black, Colors.grey.shade200),
                createButton('3', Colors.black, Colors.grey.shade200),
                createButton('+', Colors.white, Colors.orange),
                createButton('0', Colors.black, Colors.grey.shade200),
                createButton('.', Colors.black, Colors.grey.shade200),
                createButton('=', Colors.white, Colors.green),
              ],
            )
          ],
        ),
      ),
    );
  }
}
