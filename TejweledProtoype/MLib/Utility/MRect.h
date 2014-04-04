/*
 *  MRect.h
 *  Blacklight
 *
 *  Created by Arshad K C on 10/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

class MRect
{
public:
	MRect();
	MRect(float _x, float _y, float _width, float _height);
	float x,y;
	float width, height;
	
	void set(float _x, float _y, float w, float h);
	
	static MRect make(float _x, float _y, float w, float h);
};