import 'package:flutter/material.dart';

class UndefinedView extends StatelessWidget {
  final String name;
  const UndefinedView({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("404", style: TextStyle(fontSize: 32)),
            Container(height: 100),
            Text('Route for $name is not defined')
          ],
        )
      ),
    );
  }
}