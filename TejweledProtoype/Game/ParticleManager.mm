//
//  ParticleManager.m
//  TejweledProtoype
//
//  Created by Arshad on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParticleManager.h"
#import "Particle.h"
#import "MGroup.h"

ParticleManager::ParticleManager()
{
    
}

ParticleManager::~ParticleManager()
{
    for ( int i=0; i < vecParticleGroup.size(); i++)
    {
        delete vecParticleGroup[i];
        vecParticleGroup[i] = NULL;
    }
    vecParticleGroup.clear();
}

ParticleManager::ParticleManager(CCNode* node )
{
    float maxParticle = 150;
    int x = 0;
    parent = node;
    for ( int i=0 ; i < 6 ; i++)
        vecParticleGroup.push_back(new MGroup());
    
    x = 0;
    for ( int i=0; i < maxParticle; i++)
    {
        Particle* p = new Particle(parent,[NSString stringWithFormat:@"red_p%d.png",x]);
        p->lifeTime = 1.0f;
        p->kill();
        x++;
        if ( x > 3 ) x = 0;
        vecParticleGroup[0]->addObject(p);        
    }
    
    x = 0;
    for ( int i=0; i < maxParticle; i++)
    {
        Particle* p = new Particle(parent,[NSString stringWithFormat:@"green_p%d.png",x]);
        p->lifeTime = 1.0f;
        p->kill();
        x++;
        if ( x > 3 ) x = 0;
        vecParticleGroup[1]->addObject(p);
    }
    
    x = 0;
    for ( int i=0; i < maxParticle; i++)
    {
        Particle* p = new Particle(parent,[NSString stringWithFormat:@"blue_p%d.png",x]);
        p->lifeTime = 1.0f;
        p->kill();
        x++;
        if ( x > 3 ) x = 0;
        vecParticleGroup[2]->addObject(p);
    }
    
    x = 0;
    for ( int i=0; i < maxParticle; i++)
    {
        Particle* p = new Particle(parent,[NSString stringWithFormat:@"yellow_p%d.png",x]);
        p->lifeTime = 1.0f;
        p->kill();
        x++;
        if ( x > 3 ) x = 0;
        vecParticleGroup[3]->addObject(p);
    }
    
    x = 0;
    for ( int i=0; i < maxParticle; i++)
    {
        Particle* p = new Particle(parent,[NSString stringWithFormat:@"cyan_p%d.png",x]);
        p->lifeTime = 1.0f;
        p->kill();
        x++;
        if ( x > 3 ) x = 0;
        vecParticleGroup[4]->addObject(p);
    } 
    
    x = 0;
    for ( int i=0; i < maxParticle; i++)
    {
        Particle* p = new Particle(parent,[NSString stringWithFormat:@"magenta_p%d.png",x]);
        p->lifeTime = 1.0f;
        p->kill();
        x++;
        if ( x > 3 ) x = 0;
        vecParticleGroup[5]->addObject(p);
    }     
}

void ParticleManager::update()
{
    for ( int i=0; i < vecParticleGroup.size(); i++)
        vecParticleGroup[i]->update();
    MBasic::update();
}

void ParticleManager::explode(int index, MPoint pos)
{
    float s = 0 , c = 0;
    for ( int i=0; i < 25 ; i++)
    {
        Particle* p = (Particle*)vecParticleGroup[index]->getFirstAvailable();
        if ( p )
        {
            float varianceX = (((float)rand()/RAND_MAX - 0.5) * 5);
            float varianceY = (((float)rand()/RAND_MAX - 0.5) * 5);
            p->reset(pos.x+varianceX, pos.y+varianceY);
            p->velocity.y  = sin(s) * 60;
            p->velocity.x  = cos(c) * 60;  
            p->acceleration.y = -40;
            p->lifeTime = (float)rand()/RAND_MAX * 0.6f;
            p->add();
            s++;
            c++;
        }
    }
}
