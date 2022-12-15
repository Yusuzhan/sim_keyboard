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
      begin: const Color(0xffc3c3c3),
      end: const Color(0xffd3d3d3),
      // end: Colors.white,
    ).animate(_animationController);
    _contentColorAnimation = ColorTween(
      begin: const Color(0xFF787878),
      end: const Color(0xFF535353),
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
    return Padding(
      padding: EdgeInsets.only(
        top: _paddingAnimation.value,
        left: _paddingAnimation.value / 2,
        bottom: 4 - _paddingAnimation.value,
        right: (4 - _paddingAnimation.value) / 2,
      ),
      child: PhysicalModel(
        color: const Color(0xffb6b6b6),
        elevation: 8,
        shadowColor: Colors.blue,
        child: InkWell(
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
              padding: const EdgeInsets.all(2),
              child: Container(
                color: const Color(0xffb6b6b6),
                child: _content(),
              ),
            ),
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
