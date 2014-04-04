/*
 *  MDisplay.h
 *  Blacklight
 *
 *  Created by Arshad K C on 07/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "MObject.h"
#import <CoreGraphics/CoreGraphics.h>

class MDisplay : public MObject
{
protected:
	CCSprite* sprite;
	
	CCSpriteBatchNode* parentSpriteSheet;
public:
	/* Constructor */
	MDisplay();
	MDisplay(CCNode* parent);
	MDisplay(NSString* filename,CCNode* parent);
	
	/* Destructor */
	virtual ~MDisplay();
	
	/* Update */
	virtual void update();
	/* Add to the current layer */
	void add();
	/* Remove from the current layer */
	void remove();
	/* Kill */
	virtual void kill();
	/* Bring back the object to life */
	virtual void revive();	
	/* scale sprite */
	void scaleX(float scale);
    /* Get Sprite */
    CCSprite* getSprite();
    
};