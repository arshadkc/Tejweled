//
//  Orbs.h
//  TejweledProtoype
//
//  Created by Arshad on 11/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef TejweledProtoype_Orbs_h
#define TejweledProtoype_Orbs_h

#import "MDisplay.h"


class Orbs : public MDisplay
{
public:
    int colorID;
    bool isGrounded;
    float deathCounter;
public:
    
    static int crackCounter;
    bool markKill;
    
    Orbs();
	
	Orbs(uint orbID , CCNode* parent);
    
    void setColor(int color );
	
    virtual void update();
    
    int canCombine(Orbs* orb );
    
    void showCrack();
    
    /* Hit Bottom */
	virtual void onHitBottom(MObject* obj);	
    
    /* On Overlap */
	virtual void onOverlap(MObject* obj);
    
    /* Reset the object */
	virtual void reset(float _x, float _y);
    
};

#endif
