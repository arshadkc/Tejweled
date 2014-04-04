/*
 *  TriggerSource.h
 *  Blacklight
 *
 *  Created by Arshad K C on 14/12/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import "MGroup.h"

class MObject;

class TriggerSource
{
protected:
	MGroup groupTriggerables;
	
	vector<int> vecTargetID;
	
	virtual void triggerAll();
	
public:

	TriggerSource();
	
	~TriggerSource();
	
	void loadTargets(MGroup* group);
	
	void addTargetID(int targetID);
	
	void addTriggerable(MObject* obj);
	
	virtual void onAction( int type );

};