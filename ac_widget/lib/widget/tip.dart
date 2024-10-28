import 'package:ac_widget/ac_widget.dart';
import 'package:flutter/material.dart';

class Tip extends StatefulWidget {
  final String text;
  final Widget child;

  const Tip({super.key, this.text = '--', required this.child});

  @override
  State<Tip> createState() => _TipState();
}

class _TipState extends State<Tip> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return FollowPopup(
        width: constraints.minWidth,
        height: constraints.minHeight,
        follow: tip(),
        child: widget.child,
      );
    });
  }

  Widget tip() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Text(
        widget.text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
