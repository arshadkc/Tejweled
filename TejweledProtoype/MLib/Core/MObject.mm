/*
 *  MObject.mm
 *  Blacklight
 *
 *  Created by Arshad K C on 07/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "MObject.h"
#import "MG.h"
#import "MRect.h"
#import "TriggerSource.h"

unsigned int MObject::LEFT	=	0x0001;
unsigned int MObject::RIGHT =	0x0010;
unsigned int MObject::UP	=	0x0100;
unsigned int MObject::DOWN	=	0x1000;
unsigned int MObject::ANY	=	LEFT | RIGHT | UP | DOWN;
unsigned int MObject::NONE	=	0x0000;
unsigned int MObject::WALL	=   LEFT | RIGHT;

MObject::MObject()
{
	x = 0.0f;
	y = 0.0f;
	width = height = 0.0f;
	mass = 1.0f;
	elasticity = 1.0f;
	health = 0.0f;
	moves = true;
	solid = true;
	touching = NONE;
	wasTouching = NONE;
	allowCollisions = ANY;
	facing = RIGHT;
	immovable = false;
	unstoppable = false;
	allowCamera = false;
	isSensor = false;
	typeID = -1;
	triggerSource = NULL;
	
}

MObject::~MObject()
{
	triggerSource = NULL;
	while (!vecTriggerSource.empty()) {
        // remove it from the list
        vecTriggerSource.erase(vecTriggerSource.begin());
	}	
}

void MObject::preUpdate()
{
	last.x = x;
	last.y = y;
}

void MObject::update()
{
}

void MObject::postUpdate()
{
	if ( moves )
	{
		updateMotion();
	}
	wasTouching = touching;
	touching = NONE;
}

void MObject::updateMotion()
{
	// Update Velocity
	velocity.x = velocity.x + acceleration.x * MG::dt;
	velocity.y = velocity.y + acceleration.y * MG::dt;	
	
	// Update Position
	x = x + velocity.x * MG::dt;
	y = y + velocity.y * MG::dt;	
	if ( allowCamera )
	{
		x += MG::cameraVelocity.x;
		y += MG::cameraVelocity.y;		
	}
}

void MObject::setSolid(bool bSolid)
{
	solid = bSolid;
	if (bSolid)
		allowCollisions = ANY;
	else
		allowCollisions = NONE;
}

bool MObject::seperate(MObject* object1, MObject* object2)
{
	bool speratedX = seperateX(object1, object2);
	bool speratedY = seperateY(object1, object2);	
	return speratedX || speratedY;
}

bool MObject::seperateX(MObject* object1, MObject* object2)
{
	//can't separate two immovable objects
	bool obj1Immovable = object1->immovable;
	bool obj2Immovable = object2->immovable;
	
	if ( obj1Immovable && obj2Immovable )
		return false;
	
	float overlap = 0.0f;
	float obj1Delta = object1->x - object1->last.x;
	float obj2Delta = object2->x - object2->last.x;
	
	if ( obj1Delta != obj2Delta )
	{
		// Abs
		float obj1DeltaAbs = obj1Delta > 0.0f ? obj1Delta : -obj1Delta;
		float obj2DeltaAbs = obj2Delta > 0.0f ? obj2Delta : -obj2Delta;		
		
		//Check if the X hulls actually overlap
		MRect obj1rect , obj2rect;
		obj1rect.set(object1->x-((obj1Delta > 0)?obj1Delta:0),object1->last.y,object1->width+((obj1Delta > 0)?obj1Delta:-obj1Delta),object1->height);
		obj2rect.set(object2->x-((obj2Delta > 0)?obj2Delta:0),object2->last.y,object2->width+((obj2Delta > 0)?obj2Delta:-obj2Delta),object2->height);
		if((obj1rect.x + obj1rect.width > obj2rect.x) && (obj1rect.x < obj2rect.x + obj2rect.width) && (obj1rect.y + obj1rect.height > obj2rect.y) && (obj1rect.y < obj2rect.y + obj2rect.height))
		{
			float maxOverlap = obj1DeltaAbs + obj2DeltaAbs + 4.0f;
			
			if ( obj1Delta > obj2Delta )
			{
				overlap = object1->x + object1->width - object2->x;
				if ( (overlap > maxOverlap) || !( object1->allowCollisions & RIGHT ) || !( object2->allowCollisions & LEFT ) )
					overlap = 0.0f;
				else
				{
					object1->touching |= RIGHT;
					object2->touching |= LEFT;
				}
			}
			else if ( obj1Delta < obj2Delta )
			{
				overlap = object1->x - object2->width - object2->x;
				if ( ( -overlap > maxOverlap ) || !( object1->allowCollisions & LEFT ) || !( object2->allowCollisions & RIGHT ) )
					overlap = 0.0f;
				else 
				{
					object1->touching |= LEFT;
					object2->touching |= RIGHT;				
				}

			}
		}
		
		//Then adjust their positions and velocities accordingly (if there was any overlap)
		if (overlap != 0.0f)
		{
			float obj1v = object1->velocity.x;
			float obj2v = object2->velocity.x;
			
			if ( !obj1Immovable && !obj2Immovable )
			{
				overlap *= 0.5f;
				object1->x -= overlap;
				object2->x += overlap;
				
				float obj1velocity = sqrt((obj2v * obj2v * object2->mass)/object1->mass) * ( (obj2v > 0.0f ? 1.0f : -1.0f ) );
				float obj2velocity = sqrt((obj1v * obj1v * object1->mass)/object2->mass) * ( (obj1v > 0.0f ? 1.0f : -1.0f ) );				
				float average = ( obj1velocity + obj2velocity ) * 0.5f;
				
				obj1velocity -= average;
				obj2velocity -= average;
				
				object1->velocity.x = average + obj1velocity * object1->elasticity;
				object2->velocity.x = average + obj2velocity * object2->elasticity;				
			
			}
			else if (!obj1Immovable )
			{
				object1->x -= overlap;
				object1->velocity.x = obj2v - obj1v * object1->elasticity;
			}
			else if ( !obj2Immovable )
			{
				object2->x += overlap;
				object2->velocity.x = obj1v - obj2v * object2->elasticity;
			}
				
		}
		else
			return false;
	}
	return true;	
}

bool MObject::seperateY(MObject* object1, MObject* object2)
{
	//can't separate two immovable objects
	bool obj1Immovable = object1->immovable;
	bool obj2Immovable = object2->immovable;
	
	if ( obj1Immovable && obj2Immovable )
		return false;
	
	float overlap = 0.0f;
	float obj1Delta = object1->y - object1->last.y;
	float obj2Delta = object2->y - object2->last.y;
	
	if ( obj1Delta != obj2Delta )
	{
		// Abs
		float obj1DeltaAbs = obj1Delta > 0.0f ? obj1Delta : -obj1Delta;
		float obj2DeltaAbs = obj2Delta > 0.0f ? obj2Delta : -obj2Delta;		
		
		//Check if the X hulls actually overlap
		MRect obj1rect , obj2rect;
		obj1rect.set(object1->x,object1->y-((obj1Delta > 0)?obj1Delta:0),object1->width,object1->height+obj1DeltaAbs);
		obj2rect.set(object2->x,object2->y-((obj2Delta > 0)?obj2Delta:0),object2->width,object2->height+obj2DeltaAbs);
		if((obj1rect.x + obj1rect.width > obj2rect.x) && (obj1rect.x < obj2rect.x + obj2rect.width) && (obj1rect.y + obj1rect.height > obj2rect.y) && (obj1rect.y < obj2rect.y + obj2rect.height))
		{
			float maxOverlap = obj1DeltaAbs + obj2DeltaAbs + 4.0f;
			
			if ( obj1Delta > obj2Delta )
			{
				overlap = object1->y + object1->height - object2->y;
				if ( (overlap > maxOverlap) || !( object1->allowCollisions & UP ) || !( object2->allowCollisions & DOWN ) )
					overlap = 0.0f;
				else
				{
					object1->touching |= UP;
					object2->touching |= DOWN;
				}
			}
			else if ( obj1Delta < obj2Delta )
			{
				overlap = object1->y - object2->height - object2->y;
				if ( ( -overlap > maxOverlap ) || !( object1->allowCollisions & DOWN ) || !( object2->allowCollisions & UP ) )
					overlap = 0.0f;
				else 
				{
					object1->touching |= DOWN;
					object2->touching |= UP;				
				}
				
			}
		}
		
		//Then adjust their positions and velocities accordingly (if there was any overlap)
		if (overlap != 0.0f)
		{
			float obj1v = object1->velocity.y;
			float obj2v = object2->velocity.y;
			
			if ( !obj1Immovable && !obj2Immovable )
			{
				overlap *= 0.5f;
				object1->y -= overlap;
				object2->y += overlap;
				
				float obj1velocity = sqrt((obj2v * obj2v * object2->mass)/object1->mass) * ( (obj2v > 0.0f ? 1.0f : -1.0f ) );
				float obj2velocity = sqrt((obj1v * obj1v * object1->mass)/object2->mass) * ( (obj1v > 0.0f ? 1.0f : -1.0f ) );				
				float average = ( obj1velocity + obj2velocity ) * 0.5f;
				
				obj1velocity -= average;
				obj2velocity -= average;
				
				object1->velocity.y = average + obj1velocity * object1->elasticity;
				object2->velocity.y = average + obj2velocity * object2->elasticity;				
				
			}
			else if (!obj1Immovable )
			{
				object1->y -= overlap;
				object1->velocity.y = obj2v - obj1v * object1->elasticity;
			}
			else if ( !obj2Immovable )
			{
				object2->y += overlap;
				object2->velocity.y = obj1v - obj2v * object2->elasticity;
			}
			
		}
		else
			return false;
	}
	return true;	
	
}

void MObject::reset(float _x, float _y)
{
	touching = NONE;
	wasTouching = NONE;
	x = _x;
	y = _y;
	last.x = x;
	last.y = y;
	velocity.x = 0;
	velocity.y = 0;	
	revive();	
}

void MObject::setPosition(float _x, float _y)
{
	touching = NONE;
	wasTouching = NONE;	
	x = _x;
	y = _y;
	last.x = x;
	last.y = y;
}

bool MObject::isTouching(unsigned int direction)
{
	return ( touching & direction ) > NONE; 
}

bool MObject::justTouched(unsigned int direction)
{
	return ((touching & direction) > NONE) && ((wasTouching & direction) <= NONE);
}

void MObject::hurt(float damage)
{
	health -= damage;
	if ( health <= 0.0f)
		kill();
}

void MObject::load(ObjectData _objData)
{
	x = _objData.x;
	y = _objData.y;
	width = _objData.width;
	height = _objData.height;	
}

void MObject::onHit(MObject* obj)
{
}

void MObject::onOverlap(MObject* obj)
{
}

void MObject::onHitLeft(MObject* obj)
{
//	printf("\n Hit Left");
}

void MObject::onHitRight(MObject* obj)
{
//	printf("\n Hit Right");	
}

void MObject::onHitTop(MObject* obj)
{
//	printf("\n Hit Top");	
}

void MObject::onHitBottom(MObject* obj)
{
//	printf("\n Hit Bottom");	
}

#pragma mark Trigger

bool MObject::trigger(TriggerSource* source)
{
	triggerSource = source;
	
	// Find whether source is already in vecTriggerSource
	bool isFound = false;
	for ( unsigned int i=0; i < vecTriggerSource.size(); i++)
	{
		if ( vecTriggerSource[i] == source )
			isFound = true;
	}
	if ( !isFound )
		vecTriggerSource.push_back(source);
	
	return true;
}

// Send notifications to trigger sources.
void MObject::notifyAction(int actionType)
{
	for( unsigned int i=0; i < vecTriggerSource.size(); i++)
	{
		TriggerSource* ts = vecTriggerSource[i];
		ts->onAction(actionType);
	}
}
