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
import 'package:logging/logging.dart';
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
    g._itemsPerRow = itemsPerRow;
    return this;
  }

  Sand build() {
    return g;
  }
}

class Sand {
  static final Logger _log = Logger("Sand");

  Sand._();

  Tileable? _shape;
  SparseArray<Pile>? _piles;
  HashSet<int>? _exceeding;
  HashSet<int>? _exceedingNext;
  int _itemsPerRow = -1;

  bool topple() {
    bool toppled = false;

    if (_exceeding != null && _exceeding!.isNotEmpty) {
      _log.info("need to topple");

      int neighbourIndex;
      for (int at in _exceeding!) {
        _log.fine("processessing $at");

        _piles![at]!.value -= _shape!.sides;

        _testAndAdd(at, _exceedingNext!);

        for (int i = 0; i < _shape!.sides; i++) {
          neighbourIndex = _neighbour(i, at);

          if (neighbourIndex >= 0 && neighbourIndex < _piles!.length) {
            _piles!.get(neighbourIndex)!.value += 1;

            _testAndAdd(neighbourIndex, _exceedingNext!);
          }
        }
      }

      _swapExceedingLists();

      toppled = true;

      _log.info("toppled");
      _log.finest(this);
    }

    return toppled;
  }

  void _swapExceedingLists() {
    HashSet<int> temp = _exceeding!;
    temp.clear();

    _exceeding = _exceedingNext;
    _exceedingNext = temp;
  }

  void _testAndAdd(int at, HashSet<int> list) {
    if (_piles!.get(at)!.value > 3) {
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
        neighbour = PileHelper.neighbourTriangle(nth, at, itemsPerRow);
        break;
      case Tileable.square:
        neighbour = PileHelper.neighbourSquare(nth, at, itemsPerRow);
        break;
      case Tileable.hexagon:
        neighbour = PileHelper.neighbourHexagon(nth, at, itemsPerRow);
        break;
    }

    return neighbour;
  }

  void add(int grains, int at) {
    if (_piles == null) {
      _piles = SparseArray<Pile>();
      _exceeding = HashSet<int>();
      _exceedingNext = HashSet<int>();
    }

    Pile? s;
    if ((s = _piles!.get(at)) != null) {
      s!.value += grains;
    } else {
      s = Pile(0, grains);
      _piles![at] = s;
    }

    _testAndAdd(at, _exceeding!);
  }

  static Builder get builder {
    return Builder();
  }

  set shape(Tileable shape) {
    _shape = shape;
  }

  int grains(int at) {
    return _piles!.get(at)!.value;
  }

  Sand operator +(Sand g1) {
    if (g1._shape != _shape) {
      throw Exception("Runtime: Types are not compatible");
    }

    Sand r = Sand._();
    r._shape = _shape;

    if (_piles != null) {
      for (int i = 0; i < _piles!.length; i++) {
        r.add(_piles!.get(i)!.value + g1._piles!.get(i)!.value, i);
      }
    }

    return r;
  }

  int get itemsPerRow => _itemsPerRow > 0
      ? _itemsPerRow
      : (_itemsPerRow = sqrt(_piles!.length).toInt());

  @override
  bool operator ==(Object other) {
    bool equal = super == (other);
    if (!equal && other is Sand) {
      equal = _piles == other._piles;

      if (!equal) {
        equal = _piles!.length == other._piles!.length;

        if (equal) {
          for (int i = 0; i < _piles!.length; i++) {
            Pile? pv = _piles!.get(_piles!.keyAt(i));
            Pile? objPv = other._piles!.get(_piles!.keyAt(i));

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
    int x = itemsPerRow;

    for (int i = 0; i < _piles!.length; i++) {
      if (i % x == 0 && b.isNotEmpty) {
        b = StringBuffer(b.toString().substring(0, b.length - 1));
        b.write("\n");

        for (int j = 0; j < (x * 2) - 1; j++) {
          b.write("-");
        }
        b.write("\n");
      }

      b.write(_piles!.get(i)!.value);
      b.write("|");
    }
    b.write(b.length - 1);

    return b.toString();
  }

  @override
  int get hashCode => super.hashCode + 1;
}
