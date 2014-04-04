/*
 *  MQuadTree.cpp
 *  Blacklight
 *
 *  Created by Arshad K C on 22/11/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "MQuadTree.h"
#import "MObject.h"
#import "MList.h"
#import "MGroup.h"

int MQuadTree::divisions = 6;
int MQuadTree::_min = 0;
const int MQuadTree::A_LIST = 0;
const int MQuadTree::B_LIST = 1;
MObject* MQuadTree::_object = NULL;
float MQuadTree::_objectLeftEdge = 0.0f;
float MQuadTree::_objectTopEdge= 0.0f;
float MQuadTree::_objectRightEdge= 0.0f;
float MQuadTree::_objectBottomEdge= 0.0f;
int   MQuadTree::_list = A_LIST;
bool  MQuadTree::_useBothLists = false;
MList* MQuadTree::_iterator = NULL;
float MQuadTree::_objectHullX= 0.0f;
float MQuadTree::_objectHullY= 0.0f;
float MQuadTree::_objectHullWidth= 0.0f;
float MQuadTree::_objectHullHeight= 0.0f;
float MQuadTree::_checkObjectHullX= 0.0f;
float MQuadTree::_checkObjectHullY= 0.0f;
float MQuadTree::_checkObjectHullWidth= 0.0f;
float MQuadTree::_checkObjectHullHeight= 0.0f;
bool MQuadTree::_seperate = false;
MCollisionListener* MQuadTree::_listener = NULL;

MQuadTree::MQuadTree(float x, float y, float width, float height, MQuadTree* _parent):MRect(x, y, width, height)
{
	_headA = _tailA = new MList();
	_headB = _tailB = new MList();
	
	if ( _parent != NULL )
	{
		MList* it;
		MList* ot;
		if ( _parent->_headA->object != NULL)
		{
			it = _parent->_headA;
			while (it != NULL) 
			{
				if (_tailA->object != NULL)
				{
					ot = _tailA;
					_tailA = new MList();
					ot->next = _tailA;
				}
				
				_tailA->object = it->object;
				it = it->next;
			}
		}
		if ( _parent->_headB->object != NULL)
		{
			it = _parent->_headB;
			while (it != NULL) 
			{
				if (_tailB->object != NULL)
				{
					ot = _tailB;
					_tailB = new MList();
					ot->next = _tailB;
				}
				
				_tailB->object = it->object;
				it = it->next;
			}
		}	
	}
	else
		_min = (width + height)/(2*divisions);
	_canSubdivide = (width > _min) || (height > _min);	
	
	
	//Set up comparison/sort helpers
	_northWestTree = NULL;
	_northEastTree = NULL;
	_southEastTree = NULL;
	_southWestTree = NULL;
	_leftEdge = x;
	_rightEdge = x+width;
	_halfWidth = width/2;
	_midpointX = _leftEdge+_halfWidth;
	_topEdge = y;
	_bottomEdge = y+height;
	_halfHeight = height/2;
	_midpointY = _topEdge+_halfHeight;
	
}

MQuadTree::~MQuadTree()
{

    MList* temp = _headA;
    MList* temp2 = NULL;
    while (temp) {
        temp2 = temp->next;
        delete temp;
        temp = temp2;
    }
    
    temp = _headB;
    temp2 = NULL;
    while (temp) {
        temp2 = temp->next;
        delete temp;
        temp = temp2;
    }
    
    _headA = NULL;
    _headB = NULL;
    _tailA = NULL;
    _tailB = NULL;
    
	if (_northEastTree)
		delete _northEastTree;
	if(_northWestTree)
		delete _northWestTree;
	if(_southEastTree)
		delete _southEastTree;
	if(_southWestTree)
		delete _southWestTree;
}

void MQuadTree::load(MGroup* _groupA, MGroup* _groupB)
{
	if ( _groupA == NULL || _groupA->getMembers().size() <= 0 )
		return;
	add(_groupA, A_LIST);
	
	if ( _groupB != NULL && _groupB->getMembers().size() > 0 )
	{
		add(_groupB, B_LIST);
		_useBothLists = true;
	}
	else
		_useBothLists = false;
	
}

void MQuadTree::add(MGroup* _group, const int list)
{
	_list = list;
	
	vector<MObject*> vecObjects = _group->getMembers();
	for (unsigned int i=0;i<vecObjects.size();i++)
	{
		_object = (MObject*)vecObjects[i];
		if (_object->exists && _object->allowCollisions)
		{
			_objectLeftEdge = _object->x;
			_objectTopEdge = _object->y;
			_objectRightEdge = _object->x + _object->width;
			_objectBottomEdge = _object->y + _object->height;
			addObject();			
		}
	}
	
}

void MQuadTree::addObject()
{
	// If this parent node is completely inside the object, then add it to itself and all its children.
	if ( !_canSubdivide || ( _leftEdge >= _objectLeftEdge && _rightEdge <= _objectRightEdge && _topEdge >= _objectTopEdge && _bottomEdge <= _objectBottomEdge ))
	{
		addToList();
		return;
	}
	
	// Check whether objects fits in nay of the children.
	if ( _objectLeftEdge > _leftEdge && _objectRightEdge < _midpointX )
	{
		if ( _objectTopEdge > _midpointY && _objectBottomEdge < _bottomEdge )
		{
			if ( _northWestTree == NULL )
				_northWestTree = new MQuadTree(_leftEdge,_midpointY,_halfWidth,_halfHeight,this);
			_northWestTree->addObject();
			return;
		}
		if ( _objectTopEdge > _topEdge && _objectBottomEdge < _midpointY )
		{
			if ( _southWestTree == NULL )
				_southWestTree = new MQuadTree(_leftEdge,_topEdge,_halfWidth,_halfHeight,this);
			_southWestTree->addObject();
			return;
		}
	}
	if ( _objectLeftEdge > _midpointX && _objectRightEdge < _rightEdge )
	{
		if ( _objectTopEdge > _midpointY && _objectBottomEdge < _bottomEdge )
		{
			if ( _northEastTree == NULL )
				_northEastTree = new MQuadTree(_midpointX,_midpointY,_halfWidth,_halfHeight,this);
			_northEastTree->addObject();
			return;
		}
		if ( _objectTopEdge > _topEdge && _objectBottomEdge < _midpointY )
		{
			if ( _southEastTree == NULL )
				_southEastTree = new MQuadTree(_midpointX,_topEdge,_halfWidth,_halfHeight,this);
			_southEastTree->addObject();
			return;
		}		
	}
	
	// Check whether objects partially fits in any of the children.
	if ( _objectRightEdge > _leftEdge && _objectLeftEdge < _midpointX && _objectBottomEdge > _midpointY && _objectTopEdge < _bottomEdge )
	{
		if ( _northWestTree == NULL )
			_northWestTree = new MQuadTree(_leftEdge,_midpointY,_halfWidth,_halfHeight,this);
		_northWestTree->addObject();		
	}
	if ( _objectRightEdge > _midpointX && _objectLeftEdge < _rightEdge && _objectBottomEdge > _midpointY && _objectTopEdge < _bottomEdge )
	{
		if ( _northEastTree == NULL )
			_northEastTree = new MQuadTree(_midpointX,_midpointY,_halfWidth,_halfHeight,this);
		_northEastTree->addObject();		
	}
	if ( _objectRightEdge > _leftEdge && _objectLeftEdge < _midpointX && _objectBottomEdge > _topEdge && _objectTopEdge < _midpointY )
	{
		if ( _southWestTree == NULL )
			_southWestTree = new MQuadTree(_leftEdge,_topEdge,_halfWidth,_halfHeight,this);
		_southWestTree->addObject();		
	}
	if ( _objectRightEdge > _midpointX && _objectLeftEdge < _rightEdge && _objectBottomEdge > _topEdge && _objectTopEdge < _midpointY )
	{
		if ( _southEastTree == NULL )
			_southEastTree = new MQuadTree(_midpointX,_topEdge,_halfWidth,_halfHeight,this);
		_southEastTree->addObject();		
	}
}

void MQuadTree::addToList()
{
	MList* ot;
	
	if ( _list == A_LIST )
	{
		if ( _tailA->object != NULL )
		{
			ot = _tailA;
			_tailA = new MList();
			ot->next = _tailA;
		}
		_tailA->object = _object;
	}
	else
	{
		if ( _tailB->object != NULL )
		{
			ot = _tailB;
			_tailB = new MList();
			ot->next = _tailB;
		}
		_tailB->object = _object;		
	}
	
	if ( !_canSubdivide )
		return;
	
	if(_northWestTree != NULL)
		_northWestTree->addToList();
	if(_northEastTree != NULL)
		_northEastTree->addToList();
	if(_southEastTree != NULL)
		_southEastTree->addToList();
	if(_southWestTree != NULL)
		_southWestTree->addToList();	
}

bool MQuadTree::execute()
{
	bool overlapProcessed = false;
	MList* iterator;
	
	if(_headA->object != NULL)
	{
		iterator = _headA;
		while(iterator != NULL)
		{
			_object = iterator->object;
			if(_useBothLists)
				_iterator = _headB;
			else
				_iterator = iterator->next;
			if(	_object->exists && (_object->allowCollisions > 0) &&
			   (_iterator != NULL) && (_iterator->object != NULL) &&
			   _iterator->object->exists &&overlapNode())
			{
				overlapProcessed = true;
			}
			iterator = iterator->next;
		}
	}
	
	//Advance through the tree by calling overlap on each child
	if((_northWestTree != NULL) && _northWestTree->execute())
		overlapProcessed = true;
	if((_northEastTree != NULL) && _northEastTree->execute())
		overlapProcessed = true;
	if((_southEastTree != NULL) && _southEastTree->execute())
		overlapProcessed = true;
	if((_southWestTree != NULL) && _southWestTree->execute())
		overlapProcessed = true;
	
	return overlapProcessed;	
}

bool MQuadTree::overlapNode()
{
	//Walk the list and check for overlaps
	bool overlapProcessed = false;
	MObject* checkObject = NULL;
	while(_iterator != NULL)
	{
		if(!_object->exists || (_object->allowCollisions <= 0))
			break;
		
		checkObject = _iterator->object;
		if((_object == checkObject) || !checkObject->exists || (checkObject->allowCollisions <= 0))
		{
			_iterator = _iterator->next;
			continue;
		}
		
		
		//calculate bulk hull for _object
		_objectHullX = (_object->x < _object->last.x)?_object->x:_object->last.x;
		_objectHullY = (_object->y < _object->last.y)?_object->y:_object->last.y;
		_objectHullWidth = _object->x - _object->last.x;
		_objectHullWidth = _object->width + ((_objectHullWidth>0)?_objectHullWidth:-_objectHullWidth);
		_objectHullHeight = _object->y - _object->last.y;
		_objectHullHeight = _object->height + ((_objectHullHeight>0)?_objectHullHeight:-_objectHullHeight);
		
		//calculate bulk hull for checkObject
		_checkObjectHullX = (checkObject->x < checkObject->last.x)?checkObject->x:checkObject->last.x;
		_checkObjectHullY = (checkObject->y < checkObject->last.y)?checkObject->y:checkObject->last.y;
		_checkObjectHullWidth = checkObject->x - checkObject->last.x;
		_checkObjectHullWidth = checkObject->width + ((_checkObjectHullWidth>0)?_checkObjectHullWidth:-_checkObjectHullWidth);
		_checkObjectHullHeight = checkObject->y - checkObject->last.y;
		_checkObjectHullHeight = checkObject->height + ((_checkObjectHullHeight>0)?_checkObjectHullHeight:-_checkObjectHullHeight);
		
		//check for intersection of the two hulls
		if(	(_objectHullX + _objectHullWidth > _checkObjectHullX) &&
		   (_objectHullX < _checkObjectHullX + _checkObjectHullWidth) &&
		   (_objectHullY + _objectHullHeight > _checkObjectHullY) &&
		   (_objectHullY < _checkObjectHullY + _checkObjectHullHeight) )
		{
			//Execute callback functions if they exist

			if ( _seperate )
			{
				if ( MObject::seperate(_object,checkObject) )
				{
					if ( _listener )
						_listener->onCollision(_object, checkObject);
				}
			}
			else
			{
				if ( _listener )
					_listener->onOverlap(_object, checkObject);				
			}
			overlapProcessed = true;
		}
		_iterator = _iterator->next;
	}
	
	return overlapProcessed;
}