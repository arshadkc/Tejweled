/*
 *  MDisplay.mm
 *  Blacklight
 *
 *  Created by Arshad K C on 07/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "MDisplay.h"
#import "MG.h"
#import "MCamera.h"

MDisplay::MDisplay()
{
	sprite = nil;
	parentSpriteSheet = NULL;
}

MDisplay::MDisplay(CCNode* parent)
{
    sprite = nil;
	parentSpriteSheet = NULL;
	parentSpriteSheet = parent;
}

MDisplay::MDisplay(NSString* filename,CCNode* parent)
{
    sprite = nil;
	parentSpriteSheet = NULL;
	parentSpriteSheet = parent;    
	sprite = [CCSprite spriteWithFile:filename];
    [sprite retain];
//	CCTexture2D *texture = 
//	[[CCTextureCache sharedTextureCache] addImage:@"platform.png"];
//	sprite = [CCSprite spriteWithTexture:texture rect:CGRectMake(0, 0, 64, 20)];
	CGRect rect = [sprite boundingBox];
	width = rect.size.width;
	height = rect.size.height;
}

MDisplay::~MDisplay()
{
	remove();
	[sprite release];
}

void MDisplay::update()
{
	if ( exists )
	{
		[sprite setPosition:CGPointMake(x+width/2,y+height/2)];
	}
	
	MObject::update();
}

void MDisplay::add()
{
	if ( sprite.parent ==nil )
	{
		[parentSpriteSheet addChild:sprite];
		[sprite setPosition:CGPointMake(x+width/2,y+height/2)];
	}
}

void MDisplay::remove()
{
	if ( [sprite parent] != nil )
	{
		[parentSpriteSheet removeChild:sprite cleanup:false];
	}
}

void MDisplay::kill()
{
	remove();
	MObject::kill();
}

void MDisplay::revive()
{
	add();
	MObject::revive();
}

void MDisplay::scaleX(float scale)
{
	sprite.scaleX = scale;
}

CCSprite* MDisplay::getSprite()
{
    return sprite;
}