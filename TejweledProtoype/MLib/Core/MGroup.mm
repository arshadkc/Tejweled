/*
 *  MGroup.mm
 *  Blacklight
 *
 *  Created by Arshad K C on 07/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "MGroup.h"

MGroup::MGroup()
{
}

void MGroup::update()
{
	for ( unsigned int i=0; i < vecObjects.size(); i++)
	{
		MObject* obj = vecObjects[i];
		if( obj && obj->exists )
		{
			obj->preUpdate();
			obj->update();
			obj->postUpdate();
		}
	}	
}

MGroup::~MGroup()
{	
	while (!vecObjects.empty()) {
        // get first 'element'
        MObject* obj = vecObjects.front();
        
        // remove it from the list
        vecObjects.erase(vecObjects.begin());
		
        // delete the pointer
        delete obj;
	}
}

void MGroup::addObject(MObject* obj)
{
	vecObjects.push_back(obj);
}

void MGroup::addObject(MGroup* group)
{
    vector<MObject*> vecObjects = group->getMembers();
	for ( unsigned int i=0; i < vecObjects.size(); i++)
    {
        addObject(vecObjects[i]);
    }
}

void MGroup::removeObject(int iD)
{
}

void MGroup::removeAllObjects()
{
	while (!vecObjects.empty()) {
        // remove it from the list
        vecObjects.erase(vecObjects.begin());
	}	
}

MObject* MGroup::getObject(int uuid)
{
	MObject* obj = NULL;
	for ( unsigned int i =0; i<vecObjects.size(); i++)
	{
		obj = vecObjects[i];
		if (obj->UUID == uuid )
			break;
	}	
	return obj;
}

MObject* MGroup::getFirstDead()
{
	return NULL;
}

MObject* MGroup::getFirstAvailable()
{
	for ( unsigned int i =0; i<vecObjects.size(); i++)
	{
		MObject* obj = vecObjects[i];
		if (obj->exists == false )
			return obj;
	}
	return NULL;
}

vector<MObject*>& MGroup::getMembers()
{
	return vecObjects;
}

void MGroup::kill()
{
	for ( unsigned int i =0; i<vecObjects.size(); i++)
	{
		MObject* obj = vecObjects[i];
		if (obj)
			obj->kill();
	}
	MBasic::kill();
}

int MGroup::getLiveCount()
{
	int count = 0;
	for ( unsigned int i =0; i<vecObjects.size(); i++)
	{
		MObject* obj = vecObjects[i];
		if (obj->exists)
			count++;
	}
	return count;	
}