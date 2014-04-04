/*
 *  MGx.mm
 *  Blacklight
 *
 *  Created by Arshad K C on 10/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "MGx.h"
#include <typeinfo>
#import "MObject.h"
#import "MGroup.h"
#import "MG.h"
#import "MQuadTree.h"

MCollisionListener* MGx::collisionListener = NULL;

MGx::MGx()
{
}

void MGx::collide(MGroup* group1, MGroup* group2, bool useQuadTree)
{
	MGx::overlap(group1,group2,true,useQuadTree);
}

bool MGx::overlap(MGroup* group1, MGroup* group2, bool seperate,bool useQuadTree)
{
	bool overlapped = false;	
	
	if ( useQuadTree )
	{
		MQuadTree* quadTree = new MQuadTree(0,0,MG::levelWidth,MG::levelHeight,NULL);
		quadTree->load(group1, group2);
		quadTree->_seperate = seperate;
		quadTree->_listener = collisionListener;
		overlapped = quadTree->execute();
		delete quadTree;
	}
	else
	{
		vector<MObject*> _vecObjects1 = group1->getMembers();
		vector<MObject*> _vecObjects2 = group2->getMembers();	
		
		for ( int i=0; i<_vecObjects1.size(); i++)
		{
			MObject* _object = (MObject*)_vecObjects1[i];
			for ( int j=0; j<_vecObjects2.size(); j++)
			{
				MObject* _checkObject = (MObject*)_vecObjects2[j];
				overlap(_object,_checkObject,seperate);
			}

		}
	}

	return overlapped;
}

bool MGx::overlap(MObject* object1, MObject* object2, bool seperate)
{
	bool overlapped = false;
    if ( !object1->exists || !object2->exists ) return false;
	// Collision detection code.
	MObject* _obj1 = (MObject*)object1;
	MObject* _obj2 = (MObject*)object2;		
	
	//calculate bulk hull for _object
	float _objectHullX = _obj1->x < _obj1->last.x?_obj1->x:_obj1->last.x;
	float _objectHullY = _obj1->y < _obj1->last.y?_obj1->y:_obj1->last.y;		
	float _objectHullWidth = _obj1->x - _obj1->last.x;
	_objectHullWidth = _obj1->width + (_objectHullWidth>0?_objectHullWidth:-_objectHullWidth);
	float _objectHullHeight = _obj1->y - _obj1->last.y;
	_objectHullHeight = _obj1->height + (_objectHullHeight>0?_objectHullHeight:-_objectHullHeight);	
	
	
	float _checkObjectHullX = _obj2->x < _obj2->last.x?_obj2->x:_obj2->last.x;
	float _checkObjectHullY = _obj2->y < _obj2->last.y?_obj2->y:_obj2->last.y;		
	float _checkObjectHullWidth = _obj2->x - _obj2->last.x;
	_checkObjectHullWidth = _obj2->width + (_checkObjectHullWidth>0?_checkObjectHullWidth:-_checkObjectHullWidth);
	float _checkObjectHullHeight = _obj2->y - _obj2->last.y;
	_checkObjectHullHeight = _obj2->height + (_checkObjectHullHeight>0?_checkObjectHullHeight:-_checkObjectHullHeight);		
	
	if ( _objectHullX + _objectHullWidth > _checkObjectHullX &&
		_objectHullX < _checkObjectHullX + _checkObjectHullWidth &&
		_objectHullY + _objectHullHeight > _checkObjectHullY &&
		_objectHullY < _checkObjectHullY + _checkObjectHullHeight )
	{
		overlapped = true;
//		printf("collision");
		if ( seperate )
		{
			if ( MObject::seperate(_obj1,_obj2) )
				if ( collisionListener)
					collisionListener->onCollision(_obj1, _obj2);
		}
		else
		{
			if ( collisionListener )
				collisionListener->onOverlap(_obj1, _obj2);
		}
	}

	return overlapped;
}

void MGx::setCollisionListener(MCollisionListener* listener)
{
	collisionListener = listener;
}

void MGx::shake(float intensity, float duration, unsigned int direction, bool force)
{
	if ( MG::currentCamera )
		MG::currentCamera->shake(intensity, duration, direction, force);
}

void MGx::fade(ccColor3B color, float duration, bool force)
{
	if ( MG::currentCamera )
		MG::currentCamera->fade(color, duration, force);
}

void MGx::flash(ccColor3B color, float duration, bool force)
{
	if ( MG::currentCamera )
		MG::currentCamera->flash(color, duration, force);
}

void MGx::resetGame()
{
	
}