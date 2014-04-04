/*
 *  MG.h
 *  Blacklight
 *
 *  Created by Arshad K C on 07/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

class MState;
class MCamera;
class MPoint;

class MG
{
public:
	
	static float globalSeed;
	static float dt;
	static CCLayer* currentLayer;
	static MState* currentState;
	static MCamera* currentCamera;
	static MPoint cameraVelocity;
	static float levelHeight;
	static float levelWidth;	
	
	static float random();
	static float randomNumber(float low=0.0f, float high=1.0f);	
};