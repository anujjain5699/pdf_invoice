import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClick;

  const ButtonWidget({
    @required this.text,
    @required this.onClick,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(40),
        elevation: 20,
        shadowColor: Colors.white,
      ),
      child: FittedBox(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      onPressed: onClick,
    );
  }
}
