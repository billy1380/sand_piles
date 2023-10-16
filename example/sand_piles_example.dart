import 'package:logging/logging.dart';
import 'package:sand_piles/sand_piles.dart';
import 'package:willshex/willshex.dart';

final Logger _log = Logger("main");

void main() {
  setupLogging();

  test1();
  test2();
  test3();
  test4();
  test5();
  test6();
  test7();
  test8();
}

void test1() {
  test("test1", Tileable.square, <int>[1, 2, 0, 2, 1, 1, 0, 1, 3],
      <int>[2, 1, 3, 1, 0, 1, 0, 1, 0]);
}

void test2() {
  test("test2", Tileable.square, <int>[2, 2, 0, 2, 1, 1, 0, 1, 3],
      <int>[2, 1, 3, 1, 0, 1, 0, 1, 0]);
}

void test3() {
  test("test3", Tileable.square, <int>[2, 2, 0, 2, 1, 1, 0, 1, 3],
      <int>[0, 0, 0, 0, 0, 0, 0, 0, 0]);
}

void test4() {
  test("test4", Tileable.square, <int>[2, 2, 0, 2, 1, 1, 0, 1, 3],
      <int>[2, 1, 2, 1, 0, 1, 2, 1, 2]);
}

void test5() {
  test("test5", Tileable.square, <int>[3, 3, 3, 3, 3, 3, 3, 3, 3],
      <int>[3, 3, 3, 3, 1, 3, 3, 3, 3]);
}

void test6() {
  test("test6", Tileable.square, <int>[2, 2, 2, 2, 2, 2, 2, 2, 2],
      <int>[2, 1, 2, 1, 0, 1, 2, 1, 2]);
}

void test7() {
  test("test7", Tileable.square, <int>[2, 1, 2, 1, 0, 1, 2, 1, 2],
      <int>[2, 1, 2, 1, 0, 1, 2, 1, 2]);
}

void test8() {
  test("test8", Tileable.square, <int>[2, 1, 1, 2], <int>[2, 2, 2, 2]);
}

void test(String name, Tileable type, List<int> sand1, List<int> sand2) {
  Sand g1 = Sand.builder.shape(Tileable.square).grains(sand1).build();
  Sand g2 = Sand.builder.shape(Tileable.square).grains(sand2).build();
  Sand gT = g2 + g1;

  _log.fine(gT);

  while (gT.topple()) {
    _log.info("more toppling required");
    _log.fine(gT);
  }

  _log.info("$name complete");
  _log.fine(gT);
}
