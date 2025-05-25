import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
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
  String input = '';
  String result = '0';

  final List<String> buttons = [
    'C',
    '⌫',
    '÷',
    '×',
    '7',
    '8',
    '9',
    '−',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '=',
    '0',
    '.',
    '',
    '',
  ];

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '0';
      } else if (value == '⌫') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == '=') {
        try {
          String finalInput = input
              .replaceAll('×', '*')
              .replaceAll('÷', '/')
              .replaceAll('−', '-');
          final eval = _evaluateExpression(finalInput);
          result = eval.toString();
        } catch (e) {
          result = 'Error';
        }
      } else {
        input += value;
      }
    });
  }

  double _evaluateExpression(String expression) {
    List<String> tokens = _tokenize(expression);
    return _calculate(tokens);
  }

  List<String> _tokenize(String exp) {
    final tokens = <String>[];
    final buffer = StringBuffer();
    for (int i = 0; i < exp.length; i++) {
      final char = exp[i];
      if ('0123456789.'.contains(char)) {
        buffer.write(char);
      } else {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString());
          buffer.clear();
        }
        tokens.add(char);
      }
    }
    if (buffer.isNotEmpty) {
      tokens.add(buffer.toString());
    }
    return tokens;
  }

  double _calculate(List<String> tokens) {
    final stack = <double>[];
    String? operator;

    for (var token in tokens) {
      if ('+-*/'.contains(token)) {
        operator = token;
      } else {
        double number = double.parse(token);
        if (operator == null) {
          stack.add(number);
        } else {
          double prev = stack.removeLast();
          switch (operator) {
            case '+':
              stack.add(prev + number);
              break;
            case '-':
              stack.add(prev - number);
              break;
            case '*':
              stack.add(prev * number);
              break;
            case '/':
              stack.add(prev / number);
              break;
          }
          operator = null;
        }
      }
    }

    return stack.isNotEmpty ? stack.first : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      input,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      result,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final btnText = buttons[index];
                    if (btnText.isEmpty) return const SizedBox();
                    return ElevatedButton(
                      onPressed: () => onButtonPressed(btnText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColor(btnText),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Text(
                        btnText,
                        style: TextStyle(
                          fontSize: 24,
                          color: _getTextColor(btnText),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getButtonColor(String value) {
    if (value == 'C' || value == '⌫') return Colors.redAccent;
    if (value == '=' || '+−×÷'.contains(value)) return Colors.orangeAccent;
    return Colors.grey.shade700;
  }

  Color _getTextColor(String value) {
    if ('C⌫=+−×÷'.contains(value)) return Colors.white;
    return Colors.white;
  }
}
