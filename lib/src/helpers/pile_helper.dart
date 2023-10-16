//
//  PileHelper.java
//  sandpiles
//
//  Created by William Shakour (billy1380) on 19 Apr 2017.
//  Copyright © 2017 WillShex Limited. All rights reserved.
//  Ported to dart by William Shakour (billy1380) on 15 Oct 2023.
//

class PileHelper {
  /// This assumes that the grid is inset on odd rows
  /// @param nth
  /// @param at
  /// @param x
  /// @return
  static int neighbourHexagon(int nth, int at, int x) {
    int row = at ~/ x;
    bool evenRow = row % 2 == 0;

    int neighbour = -1;

    switch (nth) {
      case 0:
        neighbour = at - 1;
        break;
      case 1:
        neighbour = at - x;
        if (!evenRow) {
          neighbour--;
        }
        break;
      case 2:
        neighbour = at - x;
        if (evenRow) {
          neighbour++;
        }
        break;
      case 3:
        neighbour = at + 1;
        break;
      case 4:
        neighbour = at + x;
        if (evenRow) {
          neighbour++;
        }
        break;
      case 5:
        neighbour = at + x;
        if (!evenRow) {
          neighbour--;
        }
        break;
    }

    if (neighbour < 0) {
      neighbour = -1;
    } else {
      if ((nth == 0 || nth == 3) && neighbour ~/ x != row) {
        neighbour = -1;
      }
    }

    return neighbour;
  }

  static int neighbourSquare(int nth, int at, int x) {
    int row = at ~/ x;

    int neighbour = -1;

    switch (nth) {
      case 0:
        neighbour = at - 1;
        break;
      case 1:
        neighbour = at - x;
        break;
      case 2:
        neighbour = at + 1;
        break;
      case 3:
        neighbour = at + x;
        break;
    }

    if (neighbour < 0) {
      neighbour = -1;
    } else {
      if ((nth == 0 || nth == 2) && neighbour ~/ x != row) {
        neighbour = -1;
      }
    }

    return neighbour;
  }

  /// This assumes that the grid is inset on odd rows
  /// @param nth
  /// @param at
  /// @return
  static int neighbourTriangle(int nth, int at, int x) {
    int row = at ~/ x;
    bool evenIndex = at % 2 == 0, evenRow = row % 2 == 0, evenGrid = x % 2 == 0;
    bool upsideDown = evenIndex == evenRow;

    if (!evenGrid && row > 0) {
      upsideDown = !upsideDown;
    }

    int neighbour = -1;

    switch (nth) {
      case 0:
        neighbour = at - 1;
        break;
      case 1:
        if (upsideDown) {
          neighbour = at + 1;
        } else {
          neighbour = at - x;
        }
        break;
      case 2:
        if (upsideDown) {
          neighbour = at + x;
        } else {
          neighbour = at + 1;
        }
        break;
    }

    if (neighbour < 0) {
      neighbour = -1;
    } else {
      int offRow = 1;

      if (upsideDown) {
        offRow = 2;
      }

      if (nth != offRow && neighbour ~/ x != row) {
        neighbour = -1;
      }
    }

    return neighbour;
  }
}
