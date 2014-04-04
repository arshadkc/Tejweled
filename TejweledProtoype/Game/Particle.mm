//
//  Particle.m
//  TejweledProtoype
//
//  Created by Arshad on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Particle.h"
#import "MG.h"

Particle::Particle()
{
    
}

Particle::~Particle()
{
//    printf("\n removing particles");
}

Particle::Particle(CCNode* parent,NSString* filename):MDisplay(parent)
{
    lifeTimeCounter = 1.0f;
    sprite = [CCSprite spriteWithFile:filename];
    [sprite retain];
    CGRect rect = [sprite boundingBox];
	width = rect.size.width;
	height = rect.size.height;	
}

void Particle::update()
{
    lifeTimeCounter+=MG::dt;
    if ( lifeTimeCounter >= lifeTime )
        kill();
    MDisplay::update();
}

void Particle::reset(float _x, float _y)
{
    lifeTime = 0;
    lifeTimeCounter = 0;
    MDisplay::reset(_x, _y);
}