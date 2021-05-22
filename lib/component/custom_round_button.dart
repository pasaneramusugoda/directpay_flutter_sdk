import 'package:flutter/material.dart';

class CustomRoundButton extends StatefulWidget {
  final Function()? onTap;
  final buttonTitle;
  final decoration;
  final textStyle;

  CustomRoundButton(
      {this.onTap, this.buttonTitle, this.decoration, this.textStyle});

  @override
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<CustomRoundButton> {
  var pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {

        setState(() {
          pressed = true;
        });
      },
      onTapUp: (_) {

        setState(() {
          pressed = false;
        });
      },
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(horizontal: pressed ? 2.5 : 0),
        duration: Duration(milliseconds: 100),
        width: 75 - (pressed ? 5.0 : 0.0),
        height: 40 - (pressed ? 5.0 : 0.0),
        decoration: widget.decoration,
        child: Center(
          child: Text(widget.buttonTitle,
              style: widget.textStyle.copyWith(
                  color: !pressed
                      ? widget.textStyle.color
                      : widget.textStyle.color.withOpacity(0.2))),
        ),
      ),
    );
  }
}
