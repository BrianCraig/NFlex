import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nflex/nflex.dart';

extension SetScreenSize on WidgetTester {
  Future<void> setScreenSize({
    double width = 540,
    double height = 960,
    double pixelDensity = 1,
  }) async {
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

List<Widget> childrenBoxExample = [
  Container(
    color: const Color.fromRGBO(255, 0, 0, 1),
    constraints: const BoxConstraints.tightFor(width: 100, height: 100),
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

const List<MainAxisAlignment> collisions = [
  MainAxisAlignment.spaceAround,
  MainAxisAlignment.spaceBetween,
  MainAxisAlignment.spaceEvenly,
];

void main() {
  for (final axis in axisMap.entries) {
    for (MainAxisAlignment maa in MainAxisAlignment.values) {
      for (CrossAxisAlignment caa in caas) {
        for (final padding in paddingMap.entries) {
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
                  children: childrenBoxExample,
                ),
              ),
              NFlex(
                padding: padding.value,
                direction: axis.value,
                mainAxisAlignment: maa,
                crossAxisAlignment: caa,
                children: childrenBoxExample,
              ),
              './goldens/matrix-${axis.key}-padding.${padding.key}-$maa-$caa.png',
            );
          });
        }
      }
    }
  }

  for (final collision in collisions) {
    test('gap: incompatible with $collision', () {
      expect(
        () => NFlex(
          direction: Axis.horizontal,
          mainAxisAlignment: collision,
          gap: 10,
        ),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            equals(
              'gap can\'t be set aside alignment: $collision. only start, end and center are valid options.',
            ),
          ),
        ),
      );
    });
    test('gap: negative gap throws assertion error', () {
      expect(
        () => NFlex(
          direction: Axis.horizontal,
          gap: -8,
        ),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            equals(
              'can\'t render negative gap values',
            ),
          ),
        ),
      );
    });
  }

  List<MainAxisAlignment> alignments = [
    MainAxisAlignment.start,
    MainAxisAlignment.center,
    MainAxisAlignment.end,
  ];
  for (final axis in axisMap.entries) {
    for (MainAxisAlignment maa in alignments) {
      for (CrossAxisAlignment caa in caas) {
        testWidgets('matrix-gap: ${axis.key}, $maa, $caa',
            (WidgetTester tester) async {
          await expectEqualWidget(
            tester,
            Padding(
              padding: const EdgeInsets.all(10),
              child: Flex(
                direction: axis.value,
                mainAxisAlignment: maa,
                crossAxisAlignment: caa,
                textDirection: TextDirection.ltr,
                children: gapEmulator(childrenBoxExample, 8),
              ),
            ),
            NFlex(
              padding: const EdgeInsets.all(10),
              direction: axis.value,
              mainAxisAlignment: maa,
              crossAxisAlignment: caa,
              gap: 8,
              children: childrenBoxExample,
            ),
            './goldens/matrix-gap-${axis.key}-$maa-$caa.png',
          );
        });
      }
    }
  }
}

List<Widget> gapEmulator(List<Widget> widgets, double gap) {
  return widgets
      .map((widget) => <Widget>[
            widget,
            SizedBox(
              width: gap,
              height: gap,
            )
          ])
      .expand((element) => element)
      .toList()
    ..removeLast();
}
