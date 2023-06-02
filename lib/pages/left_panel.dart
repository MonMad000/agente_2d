import 'package:flutter/material.dart';
import 'app_horizontal.dart';
class LeftPanel extends StatefulWidget {
  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.tealAccent,
      child: Center(
        child: Text('Panel izquierdo'),
      ),
    );
  }
}