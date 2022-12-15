import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sim_keyboard_client/widgets/custom_button.dart';

import 'logger.dart';

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

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    final width = MediaQuery.of(context).size.width;
    log("isLandscape = $isLandscape, width = $width");

    return Scaffold(
      backgroundColor: const Color(0xffcfcfcf),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: GridView.count(
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          crossAxisCount: isLandscape ? 7 : 3,
          children: _buttonList(),
        ),
      ),
    );
  }

  List<Widget> _buttonList() {
    final List<Widget> a = [];
    a.addAll(buttonSetList
        .map(
          (buttonSet) => CustomButton(
            buttonSet: buttonSet,
            callback: null,
          ),
        )
        .toList()
        .sublist(0, 2));
    return a;
  }
}
