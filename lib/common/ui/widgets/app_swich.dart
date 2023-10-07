import 'package:flutter/material.dart';

class AppSwitch extends StatefulWidget {
  const AppSwitch({super.key, required this.initialSwitchValue});
  final bool initialSwitchValue;
  @override
  State<AppSwitch> createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch> {
  bool isOn = false;
  @override
  void initState() {
    super.initState();
    isOn = widget.initialSwitchValue;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.5,
      child: Switch.adaptive(
        value: isOn,
        onChanged: (value) {
          setState(() {
            isOn = value;
          });
        },
      ),
    );
  }
}
