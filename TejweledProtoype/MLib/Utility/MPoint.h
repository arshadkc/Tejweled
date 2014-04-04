/*
 *  MPoint.h
 *  Blacklight
 *
 *  Created by Arshad K C on 07/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

class MPoint
{
public:	
	float x;
	float y;
	
	/* Constructor */
	MPoint();
	MPoint(float _x, float _y);
	
	/* Set value for x and y*/
	void make(float _x=0, float _y=0);
	
};