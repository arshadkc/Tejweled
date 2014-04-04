/*
 *  MPoint.mm
 *  Blacklight
 *
 *  Created by Arshad K C on 07/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "MPoint.h"

MPoint::MPoint()
{
	x = 0.0f;
	y = 0.0f;
}

MPoint::MPoint(float _x, float _y)
{
	x = _x;
	y = _y;
}

void MPoint::make(float _x, float _y)
{
	x = _x;
	y = _y;
}