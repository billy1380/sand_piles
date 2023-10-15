//
//  Sand.java
//  sandpiles
//
//  Created by William Shakour (billy1380) on 18 Apr 2017.
//  Copyright © 2017 WillShex Limited. All rights reserved.
//  Ported to dart by William Shakour (billy1380) on 15 Oct 2023.
//
import 'dart:collection';
import 'dart:math';
import 'package:willshex/willshex.dart';

import 'package:sand_piles/sand_piles.dart';

class Builder {
  Sand g = Sand._();

  Builder shape(Tileable shape) {
    g.shape = shape;
    return this;
  }

  Builder start(int grains, int at) {
    g.add(grains, at);
    return this;
  }

  Builder grains(List<int> grains) {
    for (int i = 0; i < grains.length; i++) {
      start(grains[i], i);
    }
    return this;
  }

  Builder itemsPerRow(int itemsPerRow) {
    g.itemsPerRow = itemsPerRow;
    return this;
  }

  Sand build() {
    return g;
  }
}

class Sand {
  Sand._();

  Tileable? _shape;
  SparseArray<Pile>? piles;
  HashSet<int>? exceeding;
  HashSet<int>? exceedingNext;
  int itemsPerRow = -1;

  bool topple() {
    bool toppled = false;

    if (exceeding != null && exceeding!.isNotEmpty) {
      print("need to topple");
      //			print(this);

      int neighbourIndex;
      for (int at in exceeding!) {
        print("processessing $at");

        piles!.get(at)!.value -= _shape!.sides;

        _testAndAdd(at, exceedingNext!);

        for (int i = 0; i < _shape!.sides; i++) {
          neighbourIndex = _neighbour(i, at);

          if (neighbourIndex >= 0 && neighbourIndex < piles!.length) {
            piles!.get(neighbourIndex)!.value += 1;

            _testAndAdd(neighbourIndex, exceedingNext!);
          }
        }

        //print(this);
      }

      _swapExceedingLists();

      toppled = true;

      print("toppled");
      print(this);
    }

    return toppled;
  }

  void _swapExceedingLists() {
    HashSet<int> temp = exceeding!;
    temp.clear();

    exceeding = exceedingNext;
    exceedingNext = temp;
  }

  void _testAndAdd(int at, HashSet<int> list) {
    if (piles!.get(at)!.value > 3) {
      list.add(at);
    } else {
      if (list.contains(at)) {
        list.remove(at);
      }
    }
  }

  int _neighbour(int nth, int at) {
    int neighbour;

    switch (_shape!) {
      case Tileable.triangle:
        neighbour = PileHelper.neighbourTriangle(nth, at, getItemsPerRow());
        break;
      case Tileable.square:
        neighbour = PileHelper.neighbourSquare(nth, at, getItemsPerRow());
        break;
      case Tileable.hexagon:
        neighbour = PileHelper.neighbourHexagon(nth, at, getItemsPerRow());
        break;
    }

    return neighbour;
  }

  void add(int grains, int at) {
    if (piles == null) {
      piles = SparseArray<Pile>();
      exceeding = HashSet<int>();
      exceedingNext = HashSet<int>();
    }

    Pile? s;
    if ((s = piles!.get(at)) != null) {
      s!.value += grains;
    } else {
      s = Pile(0, grains);
      piles![at] = s;
    }

    _testAndAdd(at, exceeding!);
  }

  static Builder get builder {
    return Builder();
  }

  set shape(Tileable shape) {
    _shape = shape;
  }

  int grains(int at) {
    return piles!.get(at)!.value;
  }

  Sand sum(Sand g1) {
    if (g1._shape != _shape) {
      throw Exception("Runtime: Types are not compatible");
    }

    Sand r = Sand._();
    r._shape = _shape;

    if (piles != null) {
      for (int i = 0; i < piles!.length; i++) {
        r.add(piles!.get(i)!.value + g1.piles!.get(i)!.value, i);
      }
    }

    return r;
  }

  int getItemsPerRow() => itemsPerRow > 0
      ? itemsPerRow
      : (itemsPerRow = sqrt(piles!.length).toInt());

  @override
  bool operator ==(Object other) {
    bool equal = super == (other);
    if (!equal && other is Sand) {
      equal = piles == other.piles;

      if (!equal) {
        equal = piles!.length == other.piles!.length;

        if (equal) {
          for (int i = 0; i < piles!.length; i++) {
            Pile? pv = piles!.get(piles!.keyAt(i));
            Pile? objPv = other.piles!.get(piles!.keyAt(i));

            if ((pv == null) || (objPv == null) || (pv.value != objPv.value)) {
              equal = false;
              break;
            }
          }
        }
      }
    }

    return equal;
  }

  @override
  String toString() {
    StringBuffer b = StringBuffer();
    int x = getItemsPerRow();

    for (int i = 0; i < piles!.length; i++) {
      if (i % x == 0 && b.isNotEmpty) {
        b = StringBuffer(b.toString().substring(0, b.length - 1));
        b.write("\n");

        for (int j = 0; j < (x * 2) - 1; j++) {
          b.write("-");
        }
        b.write("\n");
      }

      b.write(piles!.get(i)!.value);
      b.write("|");
    }
    b.write(b.length - 1);

    return b.toString();
  }

  @override
  int get hashCode => super.hashCode + 1;
}
