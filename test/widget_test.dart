import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Define the MyApp class
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Counter App')),
        body: CounterWidget(),
      ),
    );
  }
}

// Define a simple CounterWidget for demonstration
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$_counter', style: TextStyle(fontSize: 24)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _incrementCounter,
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: _decrementCounter,
            ),
          ],
        ),
      ],
    );
  }
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the counter starts at 0.
    expect(find.text('0'), findsOneWidget, reason: 'Counter should start at 0');
    expect(find.text('1'), findsNothing,
        reason: 'Counter should not start at 1');

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the counter has incremented to 1.
    expect(find.text('0'), findsNothing,
        reason: 'Counter should no longer show 0');
    expect(find.text('1'), findsOneWidget,
        reason: 'Counter should increment to 1');
  });

  testWidgets('Counter decrements smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Tap the '+' icon twice to increment the counter to 2.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the counter is now 2.
    expect(find.text('2'), findsOneWidget,
        reason: 'Counter should increment to 2');

    // Tap the '-' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    // Verify that the counter has decremented to 1.
    expect(find.text('2'), findsNothing,
        reason: 'Counter should no longer show 2');
    expect(find.text('1'), findsOneWidget,
        reason: 'Counter should decrement to 1');
  });
}
