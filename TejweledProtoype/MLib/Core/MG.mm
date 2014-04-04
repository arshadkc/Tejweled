/*
 *  MG.mm
 *  Blacklight
 *
 *  Created by Arshad K C on 07/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "MG.h"
#import "MU.h"
#import "MPoint.h"

float MG::dt = 0.0f;
CCLayer* MG::currentLayer = NULL;
MState* MG::currentState = NULL;
MCamera* MG::currentCamera = NULL;
float MG::globalSeed = 0.5f;
MPoint MG::cameraVelocity;
float MG::levelHeight = 0.0f;
float MG::levelWidth = 0.0f;	

float MG::random()
{
	return globalSeed = MU::srand(globalSeed);
}

float MG::randomNumber(float low, float high)
{
	return floor(((float)rand()/RAND_MAX) * (1+high-low)) + low;
}