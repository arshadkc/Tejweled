/*
 *  MGx.h
 *  Blacklight
 *
 *  Created by Arshad K C on 10/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import "MGroup.h"
#import "MObject.h"
#import "MCollisionListener.h"
#import "MCamera.h"

class MGx
{
	MGx();
	static MCollisionListener* collisionListener;
public:

	/* Checks collision between two groups */
	static void collide(MGroup* group1, MGroup* group2,bool useQuadTree = true);
	static bool overlap(MGroup* group1, MGroup* group2, bool seperate = false,bool useQuadTree = true);	
	static bool overlap(MObject* object1, MObject* object2, bool seperate = false);	
	
	/* Collision Listener interface for collide */
	static void setCollisionListener(MCollisionListener* listener);
	/* Shakes the screen */
	static void shake(float intensity=6.0f, float duration = 0.3f,unsigned int direction = MCamera::SHAKE_BOTH_AXIS, bool force = false);	
	/* Fade the screen */
	static void fade(ccColor3B color = ccWHITE, float duration = 2.0f, bool force = false);
	/* Flash the screen */
	static void flash(ccColor3B color = ccRED, float duration = 2.0f, bool force = false);		
	/* Reset Game */
	static void resetGame();
	
};