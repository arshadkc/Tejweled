//
//  ParticleManager.h
//  TejweledProtoype
//
//  Created by Arshad on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBasic.h"
#import "MGroup.h"

class Particle;

class ParticleManager : public MBasic
{
  
    CCNode* parent;
    vector<MGroup*> vecParticleGroup;    
    
public:
    
    ~ParticleManager();
    
    ParticleManager();
    
    ParticleManager(CCNode* node );
    
    void explode(int index, MPoint pos);
    
    virtual void update();
};