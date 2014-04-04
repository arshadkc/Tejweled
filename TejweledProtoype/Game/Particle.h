//
//  Particle.h
//  TejweledProtoype
//
//  Created by Arshad on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MDisplay.h"

class Particle : public MDisplay
{
    
public:
    
    float lifeTime;
    float lifeTimeCounter;
    
    Particle();
    
    virtual ~Particle();    
    
    Particle(CCNode* parent,NSString* filename);
    
    virtual void update();
    
    /* Reset the object */
	virtual void reset(float _x, float _y);
};