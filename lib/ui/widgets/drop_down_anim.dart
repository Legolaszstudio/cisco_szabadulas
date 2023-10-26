import 'package:flutter/material.dart';

class AnimatedDropdown extends StatefulWidget {
  final String title;
  final Widget child;
  AnimatedDropdown({super.key, required this.title, required this.child});

  @override
  State<AnimatedDropdown> createState() => _AnimatedDropdownState();
}

class _AnimatedDropdownState extends State<AnimatedDropdown>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          title: Text(widget.title),
          onTap: () {
            if (animationController.isCompleted) {
              animationController.reverse();
            } else {
              animationController.forward();
            }
          },
          trailing: RotationTransition(
            turns: Tween(begin: 0.0, end: 0.5).animate(animationController),
            child: Icon(Icons.arrow_drop_down),
          ),
        ),
        SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: animationController,
            curve: Curves.easeInOut,
          ),
          child: widget.child,
        ),
      ],
    );
  }
}
