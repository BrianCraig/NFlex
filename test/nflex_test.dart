import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nflex/nflex.dart';

extension SetScreenSize on WidgetTester {
  Future<void> setScreenSize(
      {double width = 540,
      double height = 960,
      double pixelDensity = 1}) async {
    final size = Size(width, height);
    await binding.setSurfaceSize(size);
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = pixelDensity;
  }
}

Future<void> expectEqualWidget(
    WidgetTester tester, Widget original, Widget expected, String path) async {
  await tester.setScreenSize(width: 200, height: 200);
  await tester.pumpWidget(autoUpdateGoldenFiles ? original : expected);
  await expectLater(
    find.byWidget(autoUpdateGoldenFiles ? original : expected),
    matchesGoldenFile(path),
  );
}

void main() {
  testWidgets('Nflex with Padding', (WidgetTester tester) async {
    await expectEqualWidget(
      tester,
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Flex(
          direction: Axis.horizontal,
          textDirection: TextDirection.ltr,
          children: [
            Container(
              color: const Color.fromRGBO(255, 0, 0, 1),
              constraints:
                  const BoxConstraints.tightFor(width: 100, height: 100),
            ),
            Container(
              color: const Color.fromARGB(255, 200, 255, 0),
              constraints: const BoxConstraints.tightFor(width: 80, height: 80),
            ),
          ],
        ),
      ),
      NFlex(
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
      ),
      './goldens/nflex-with-padding.png',
    );
    await tester.setScreenSize(width: 200, height: 200);
  });
}
