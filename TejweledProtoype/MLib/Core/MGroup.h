/*
 *  MGroup.h
 *  Blacklight
 *
 *  Created by Arshad K C on 07/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import "MBasic.h"
#import "MObject.h"
#import <vector.h>

class MGroup : public MBasic
{
protected:
	// MObject vector
	vector<MObject*> vecObjects;
	
public:	
	/* Methods */
	
	/* Constructor */
	MGroup();
	/* Destructor */
	virtual ~MGroup();	
	/* Update */
	virtual void update();	
	/* Add object to the vector.*/
	void addObject(MObject* obj);
    /* Add group to the vector */
    void addObject(MGroup* group);
	/* Remove object from the vector by tag*/
	void removeObject(int iD);
	/* Remove all objects.*/
	void removeAllObjects();
	/* Get object by tag.*/
	MObject* getObject(int uuid);
	/* Get first dead object.*/
	MObject* getFirstDead();
	/* Get first available object, useful for respawning*/
	MObject* getFirstAvailable();
	/* Get members */
	vector<MObject*>& getMembers();
	/* override kill, kill all the member objects too */
	virtual void kill();
	/* Get live Objects Count */
	int getLiveCount();
	
	 
};