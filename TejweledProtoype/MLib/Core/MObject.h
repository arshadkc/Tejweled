/*
 *  MObject.h
 *  Blacklight
 *
 *  Created by Arshad K C on 07/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import "MBasic.h"
#import "MPoint.h"
#import "MCollisionListener.h"
#import <vector.h>

class TriggerSource;

typedef struct _OBJECT_DATA
{
	NSString* objID;
	float x;
	float y;
	float width;
	float height;
	
} ObjectData;

class MObject : public MBasic
{
public:	
	/* Acceleration */
	MPoint acceleration;
	/* Velocity */	
	MPoint velocity;
	/* Health */
	float health;
	/* Automatic update enable/disable */
	bool moves;
	/* Object collide or not */
	bool solid;
	/* Object X Coordinate */
	float x;
	/* Object Y Coordinate */
	float y;
	/* Object Width */
	float width;
	/* Object Height */
	float height;	
	/* Object Mass */
	float mass;		
	/* Object Elasticity */
	float elasticity;
	/* Last update position */
	MPoint last;
	/* Gives the collided side */
	unsigned int touching;
	/* Previous frame collided side */
	unsigned int wasTouching;	
	/* Which and all side this object should collide */
	unsigned int allowCollisions;
	/* Whether an object will move/alter position after a collision.*/
	bool immovable;	
	bool unstoppable;
	/* Moves along camera */
	bool allowCamera;
	/* is sensor */
	bool isSensor;
	/* facing */
	unsigned int facing;
    /* Animation State */
    int animState;
	/* Type ID */
	int typeID;
	/* Trigger Source Object */
	TriggerSource* triggerSource;
	vector<TriggerSource*> vecTriggerSource;
	
    //Static Constants
	static unsigned int LEFT, RIGHT, UP, DOWN, ANY, NONE;
	static unsigned int WALL;	
	
public:
	
	/* Constructor */
	MObject();
	/* Destructor */
	virtual ~MObject();	
	/* Called before update */
	virtual void preUpdate();
	/* Update */
	virtual void update();
	/* Called after update */
	virtual void postUpdate();		
	/* update physics/motion */
	virtual void updateMotion();
	/* Setter/Getter */
	void setSolid(bool bSolid);	
	/* Seperate */
	static bool seperate(MObject* object1, MObject* object2);
	/* Seperate X*/
	static bool seperateX(MObject* object1, MObject* object2);
	/* Seperate Y*/
	static bool seperateY(MObject* object1, MObject* object2);	
	/* Reset the object */
	virtual void reset(float _x, float _y);
	/* Set x,y position of the object, it also resets the last positions */
	void setPosition(float _x, float _y);	
	/* Handy function to check which side the object is touching */
	bool isTouching(unsigned int direction);
	/* Handy function for checking if this object has just landed on a particular surface*/
	bool justTouched(unsigned int direction);
	/* Damage the object, once health is zero, kill() will be called on this object. */
	void hurt(float damage);
	/* Load from XML*/
	virtual void load(ObjectData _objData);
	/* On Hit */
	virtual void onHit(MObject* obj);
	/* On Overlap */
	virtual void onOverlap(MObject* obj);	
	/* Hit Left */
	virtual void onHitLeft(MObject* obj);
	/* Hit Right */
	virtual void onHitRight(MObject* obj);
	/* Hit Top */
	virtual void onHitTop(MObject* obj);
	/* Hit Bottom */
	virtual void onHitBottom(MObject* obj);	
	
#pragma mark Trigger
	virtual bool trigger(TriggerSource* source);
	void notifyAction(int actionType);
	
};