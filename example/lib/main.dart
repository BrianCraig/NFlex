import 'package:flutter/widgets.dart';
import 'package:nflex/nflex.dart';

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return NFlex(
      padding: const EdgeInsets.all(10.0),
      direction: Axis.horizontal,
      children: [
        Container(
          color: const Color.fromRGBO(255, 0, 0, 1),
          constraints: const BoxConstraints.tightFor(width: 100, height: 100),
        ),
        Container(
          color: const Color.fromARGB(255, 200, 255, 0),
          constraints: const BoxConstraints.tightFor(width: 80, height: 80),
        ),
      ],
    );
  }
}
