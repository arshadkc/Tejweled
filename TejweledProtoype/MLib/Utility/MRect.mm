/*
 *  MRect.mm
 *  Blacklight
 *
 *  Created by Arshad K C on 10/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "MRect.h"

MRect::MRect()
{
	x = 0;
	y = 0;
	width = 0;
	height = 0;
}

MRect::MRect(float _x, float _y, float _width, float _height)
{
	x = _x;
	y = _y;
	width = _width;
	height = _height;
}

void MRect::set(float _x, float _y, float w, float h)
{
	x = _x;
	y = _y;
	width = w;
	height = h;
}

MRect MRect::make(float _x, float _y, float w, float h)
{
	MRect rect;
	rect.set(_x, _y, w, h);
	return rect;
}