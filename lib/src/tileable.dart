//
//  Tileable.java
//  sandpiles
//
//  Created by William Shakour (billy1380) on 18 Apr 2017.
//  Copyright © 2017 WillShex Limited. All rights reserved.
//  Ported to dart by William Shakour (billy1380) on 15 Oct 2023.
//

enum Tileable {
	triangle(3),
	square(4),
	hexagon(6);

	final int _sides;

	int get sides => _sides;
	

	const Tileable (this._sides);
}
