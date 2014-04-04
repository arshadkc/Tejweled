/*
 *  TriggerSource.mm
 *  Blacklight
 *
 *  Created by Arshad K C on 14/12/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "TriggerSource.h"
#import "MGroup.h"
#import "MObject.h"

TriggerSource::TriggerSource()
{
	vecTargetID.clear();
}

TriggerSource::~TriggerSource()
{
	groupTriggerables.removeAllObjects();
}

void TriggerSource::loadTargets(MGroup* group)
{
	unsigned int count = vecTargetID.size();
	for (unsigned int i=0; i < count; i++)
	{
		int uuid = vecTargetID[i];
		MObject* obj = group->getObject(uuid);
		if ( obj )
			addTriggerable(obj);
	}
}

void TriggerSource::addTriggerable(MObject* obj)
{
	groupTriggerables.addObject(obj);
}

void TriggerSource::addTargetID(int targetID)
{
	vecTargetID.push_back(targetID);
}

void TriggerSource::triggerAll()
{
	vector<MObject*> _vecObjects = groupTriggerables.getMembers();
	for ( unsigned int i=0; i < _vecObjects.size(); i++)
	{
		MObject* obj = (MObject*)_vecObjects[i];
		obj->trigger(this);
	}
}

void TriggerSource::onAction( int type )
{
	
}