import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sim_keyboard_client/main.dart';

typedef TapCallback = Function();

class CustomButton extends StatefulWidget {
  final ButtonSet buttonSet;
  final TapCallback? callback;

  const CustomButton({
    super.key,
    required this.buttonSet,
    this.callback,
  });

  @override
  State<StatefulWidget> createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> with TickerProviderStateMixin {
  bool pressing = false;
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _contentColorAnimation;
  late Animation<double> _paddingAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: Colors.green[600],
      end: Colors.green[100],
    ).animate(_animationController);
    _contentColorAnimation = ColorTween(
      begin: const Color(0xFFE0E0E0),
      end: Colors.green[200],
    ).animate(_animationController);
    _paddingAnimation = Tween<double>(
      begin: 2,
      end: 4,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) {
        setState(() {
          pressing = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          pressing = false;
        });
      },
      onTapCancel: () {
        setState(() {
          pressing = false;
        });
      },
      onTap: () async {
        widget.callback?.call();
        AudioPlayer().play(
          AssetSource('audio/click1.mp3'),
          mode: PlayerMode.lowLatency,
        );
        HapticFeedback.heavyImpact();
        await _animationController.forward();
        _animationController.reset();
      },
      child: Container(
        color: _colorAnimation.value,
        child: Padding(
          padding: EdgeInsets.all(_paddingAnimation.value),
          child: Container(
            color: Colors.black,
            child: _content(),
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              'assets/images/${widget.buttonSet.image}',
              //'assets/images/cancel.png',
              color: _contentColorAnimation.value,
            ),
          ),
          Text(
            // buttonSet.title,
            widget.buttonSet.title,
            style: TextStyle(
              fontSize: 16,
              color: _contentColorAnimation.value,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
