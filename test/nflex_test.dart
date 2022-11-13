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
  const Map<String, EdgeInsets> paddingMap = {
    'zero': EdgeInsets.zero,
    '10': EdgeInsets.all(10.0),
    'different': EdgeInsets.fromLTRB(8, 10, 16, 4),
  };

  const Map<String, Axis> axisMap = {
    'nrow': Axis.horizontal,
    'ncolumn': Axis.vertical,
  };

  List<CrossAxisAlignment> caas = List.from(CrossAxisAlignment.values)
    ..remove(CrossAxisAlignment.baseline);
  for (final axis in axisMap.entries) {
    for (MainAxisAlignment maa in MainAxisAlignment.values) {
      for (CrossAxisAlignment caa in caas) {
        for (final padding in paddingMap.entries) {
          List<Widget> children = [
            Container(
              color: const Color.fromRGBO(255, 0, 0, 1),
              constraints:
                  const BoxConstraints.tightFor(width: 100, height: 100),
            ),
            Container(
              color: const Color.fromARGB(255, 200, 255, 0),
              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            ),
            Container(
              color: const Color.fromARGB(255, 0, 255, 21),
              constraints: const BoxConstraints.tightFor(width: 8, height: 8),
            ),
          ];
          testWidgets('matrix: ${axis.key}, padding.${padding.key}, $maa, $caa',
              (WidgetTester tester) async {
            await expectEqualWidget(
              tester,
              Padding(
                padding: padding.value,
                child: Flex(
                  direction: axis.value,
                  mainAxisAlignment: maa,
                  crossAxisAlignment: caa,
                  textDirection: TextDirection.ltr,
                  children: children,
                ),
              ),
              NFlex(
                padding: padding.value,
                direction: axis.value,
                mainAxisAlignment: maa,
                crossAxisAlignment: caa,
                children: children,
              ),
              './goldens/matrix-${axis.key}-padding.${padding.key}-$maa-$caa.png',
            );
          });
        }
      }
    }
  }
}
