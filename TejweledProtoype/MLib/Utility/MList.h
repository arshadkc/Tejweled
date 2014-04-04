/*
 *  MList.h
 *  Blacklight
 *
 *  Created by Arshad K C on 22/11/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

class MObject;

class MList
{
public:
	MObject* object;
	MList* next;
	
	MList();
	~MList();
};