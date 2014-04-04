/*
 *  MQuadTree.h
 *  Blacklight
 *
 *  Created by Arshad K C on 22/11/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "MRect.h"
#import "MCollisionListener.h"

class MObject;
class MList;
class MGroup;


class MQuadTree : public MRect
{
protected:
	
	MList* _headA;
	MList* _headB;	
	MList* _tailA;
	MList* _tailB;	

	
	MQuadTree* _northWestTree;
	MQuadTree* _northEastTree;
	MQuadTree* _southWestTree;
	MQuadTree* _southEastTree;	
	
	bool _canSubdivide;
	
	float _leftEdge;
	float _rightEdge;
	float _topEdge;
	float _bottomEdge;
	float _halfWidth;
	float _halfHeight;
	float _midpointX;
	float _midpointY;
	
public:
	static const int A_LIST;
	static const int B_LIST;	
	static int _min;
	static int divisions;
	static MObject* _object;
	static float _objectLeftEdge;
	static float _objectTopEdge;
	static float _objectRightEdge;
	static float _objectBottomEdge;
	static int   _list;
	static bool  _useBothLists;
	static MList* _iterator;
	static float _objectHullX;
	static float _objectHullY;
	static float _objectHullWidth;
	static float _objectHullHeight;
	static float _checkObjectHullX;
	static float _checkObjectHullY;
	static float _checkObjectHullWidth;
	static float _checkObjectHullHeight;		
	
	static bool _seperate;
	static MCollisionListener* _listener;
public:
	
	MQuadTree(float x, float y, float width, float height, MQuadTree* _parent); 
	
	~MQuadTree();
	
	void load(MGroup* _groupA, MGroup* _groupB);
	
	bool execute();
	
protected:
	
	void add(MGroup* _group, const int list);
	
	void addObject();
	
	void addToList();
	
	bool overlapNode();
	
};