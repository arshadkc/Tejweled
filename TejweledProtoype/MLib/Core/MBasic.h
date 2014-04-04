/*
 *  MBasic.h
 *  Blacklight
 *
 *  Created by Arshad K C on 07/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

class MBasic
{	
public:
	/* Dead or Alive */
	bool alive;
	/* Exist on the screen. */
	bool exists;
	/* Sprite visibility */
	bool visible;
	
	/* Object tag */
	int ID;
	/* UUID */
	int UUID;

public:	
	/* Constructor */
	MBasic();	
	/* Destructor */
	virtual ~MBasic();

	/* Called before update */
	virtual void preUpdate();
	/* Update */
	virtual void update();
	/* Called after update */
	virtual void postUpdate();	
	/* Kill the object */	
	virtual void kill();
	/* Bring back the object to life */
	virtual void revive();
};