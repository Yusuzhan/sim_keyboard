import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SimKeyboardApp());
}

class SimKeyboardApp extends StatelessWidget {
  const SimKeyboardApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class ButtonSet {
  final String title;
  final String msg;
  final String? image;

  const ButtonSet(this.title, this.msg, {this.image});
}

const buttonSetList = [
  ButtonSet('返回', 'esc', image: 'log-out.png'),
  ButtonSet('恢复巡航', 'left', image: 'cruise-control-reset.png'),
  ButtonSet('定速巡航', 'right', image: 'cruise-control-set.png'),
  ButtonSet('加速', 'up', image: 'speedup.png'),
  ButtonSet('减速', 'down', image: 'speeddown.png'),
  ButtonSet('导航缩放', 'f5', image: 'map.png'),
  ButtonSet('双闪', '|', image: 'hazard.png'),
  ButtonSet('左转', '[', image: 'right.png'),
  ButtonSet('右转', ']', image: 'left.png'),
  ButtonSet('车内视角', '1', image: 'steering.png'),
  ButtonSet('车外视角', '2', image: 'truck.png'),
  ButtonSet('近光灯', 'home', image: 'beam.png'),
  ButtonSet('远光灯', 'end', image: 'headlamp.png'),
];

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: GridView.count(
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            crossAxisCount: 7,
            children: _buttonList(),
          ),
        ) /* add child content here */,
      ),
    );
  }

  List<Widget> _buttonList() {
    return buttonSetList.map((buttonSet) => CarButton(buttonSet: buttonSet)).toList();
  }
}

class CarButton extends StatelessWidget {
  final ButtonSet buttonSet;
  const CarButton({
    super.key,
    required this.buttonSet,
  });

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              'assets/images/${buttonSet.image}',
              color: Colors.white,
            ),
          ),
          Text(
            buttonSet.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((state) {
            return const Color(0xff090909);
          }),
          shape: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.focused)) {
                return const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.red),
                );
              }
              if (states.contains(MaterialState.pressed)) {
                return const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  side: BorderSide(color: Colors.green),
                );
              }
              if (states.contains(MaterialState.hovered)) {
                return const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue),
                );
              }
            },
          ),
        ),
        child: _content(),
        onPressed: onPressed,
      ),
    );
  }

  void onPressed() {
    AudioPlayer().play(AssetSource('audio/click1.mp3'));
    HapticFeedback.heavyImpact();
  }
}
