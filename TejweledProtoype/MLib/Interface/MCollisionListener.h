/*
 *  MCollisionListener.h
 *  Blacklight
 *
 *  Created by Arshad K C on 11/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
class MObject;

class MCollisionListener
{
public:
	virtual void onCollision(MObject* obj1, MObject* obj2) = 0;
	virtual void onOverlap(MObject* obj1, MObject* obj2) = 0;	
};
