/*
 *  GameLevel.h
 *  Blacklight
 *
 *  Created by Arshad K C on 07/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import "MGroup.h"

typedef enum _MSwipeDirection
{
	SWIPE_NONE,
	SWIPE_LEFT = -1,
	SWIPE_RIGHT = 1,
	SWIPE_UP = 2,
    SWIPE_DOWN = 3,
}MSwipeDirection;

class MState : public MGroup
{
public:
	/* Constructor */
	MState();
	
	/* Destructor */
	virtual ~MState();	
	
	/* Initializer */
	virtual void create();
	
	/* Update */
	virtual void update();	
	
	/* Handle touch */
	virtual void onTouch(MPoint point);
	
	/* Handle Swipe */
	virtual void onSwipe(MSwipeDirection direction);
	
};