//
//  Orbs.cpp
//  TejweledProtoype
//
//  Created by Arshad on 11/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "Orbs.h"
#import "MG.h"
#import "PlayState.h"
#import "GameLayer.h"
#import "LineSprite.h"
#import "ParticleManager.h"

#define RED 0
#define GREEN 1
#define BLUE 2
#define YELLOW 3
#define CYAN 4
#define MAGENTA 5
#define WHITE 6

int Orbs::crackCounter = 1;

Orbs::Orbs()
{
    isGrounded = false;
}

Orbs::Orbs(uint orbID, CCNode* parent):MDisplay(parent)
{
    isGrounded = false;
    //	sprite = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Icon.png"]];	
    setColor(orbID);
    
    elasticity = 0.0f;
    markKill = false;
}

void Orbs::setColor(int color )
{
    colorID = color;
    NSString* filename;
    switch (colorID) {
        case RED:
            filename = @"red.png";
            break;
        case GREEN:
            filename = @"green.png";
            break;
        case BLUE:
            filename = @"blue.png";
            break;
        case YELLOW:
            filename = @"yellow.png";
            break;
        case CYAN:
            filename = @"cyan.png";
            break;
        case MAGENTA:
            filename = @"magenta.png";
            break;
        case WHITE:
            filename = @"white.png";
            break;
        case YELLOW+10:
            filename = @"yellow_m.png";
            break;            
        case CYAN+10:
            filename = @"cyan_m.png";
            break;            
        case MAGENTA+10:
            filename = @"meganta_m.png";
            break; 
        case -1:
            filename = @"cross.png";
            break;             
        default:
            break;
    }
    
    if ( sprite != nil )
    {
        remove();
        [sprite release];
        sprite = nil;
    }
    sprite = [CCSprite spriteWithFile:filename];
    [sprite retain];
	
    CGRect rect = [sprite boundingBox];
	width = rect.size.width;
	height = rect.size.height;	
}

void Orbs::reset(float _x, float _y)
{
    deathCounter = 0.0f;
    markKill = false;
    isGrounded = false;
    immovable = false;
    setSolid(true);
    MDisplay::reset(_x, _y);
}

void Orbs::update()
{               
    if ( !solid )
    {
        deathCounter+=MG::dt;
        if ( deathCounter >= 0.1 )
        {
            deathCounter = 0.0f;
            kill();
            PlayState* ps = (PlayState*)MG::currentState;
            ps->particleManager->explode(colorID, MPoint(x+width/2,y+height/2));
        }
    }
    MDisplay::update();
}

int Orbs::canCombine(Orbs* orb )
{
    int color = -1;
    int orbColor = orb->colorID;
    
    if ( ( colorID == RED && orbColor == GREEN ) || ( colorID == GREEN && orbColor == RED ) )
        color = YELLOW;
    else if ( ( colorID == RED && orbColor == BLUE ) || ( colorID == BLUE && orbColor == RED ) )
        color = MAGENTA;
    else if ( ( colorID == GREEN && orbColor == BLUE ) || ( colorID == BLUE && orbColor == GREEN ) )
        color = CYAN;    
    else
        color = -1;
    return color;
}

void Orbs::showCrack()
{
    NSString* filename;
    switch (colorID) {
        case RED:
            filename = [NSString stringWithFormat:@"red_c%d.png",crackCounter] ;
            break;
        case GREEN:
            filename = [NSString stringWithFormat:@"green_c%d.png",crackCounter] ;
            break;
        case BLUE:
            filename = [NSString stringWithFormat:@"blue_c%d.png",crackCounter] ;            
            break;
        case YELLOW:
            filename = [NSString stringWithFormat:@"yellow_c%d.png",crackCounter] ;            
            break;
        case CYAN:
            filename = [NSString stringWithFormat:@"cyan_c%d.png",crackCounter] ;            
            break;
        case MAGENTA:
            filename = [NSString stringWithFormat:@"magenta_c%d.png",crackCounter] ;            
            break;
        case WHITE:
            filename = [NSString stringWithFormat:@"white_c%d.png",crackCounter] ;            
            break;
        default:
            break;
    }
    
    if ( sprite != nil )
    {
        remove();
        [sprite release];
        sprite = nil;
    }
    sprite = [CCSprite spriteWithFile:filename];
    [sprite retain];
	
    CGRect rect = [sprite boundingBox];
	width = rect.size.width;
	height = rect.size.height;	
    
    add();
    
    crackCounter+=1;
    if ( crackCounter > 3 )
        crackCounter = 1;
    
}

void Orbs::onHitBottom(MObject* obj)
{
    if ( isGrounded ) return;
    if ( obj->UUID == 11 )
    {
        Orbs* o = (Orbs*)obj;
        if ( !o->isGrounded ) return;
    }
    isGrounded = true;
    immovable = true;
    PlayState* state = (PlayState*)MG::currentState;
    state->addToGrid(this);
}


void Orbs::onOverlap(MObject* obj)
{
    GameLayer* layer = (GameLayer*)MG::currentLayer;
    
    if ( obj->UUID == 12 && layer->lineSprite->so == this)
    {
        Orbs* o = (Orbs*)obj;
        velocity.y = -40;
        setColor(canCombine(o));
        add();
        obj->kill();
        GameLayer* gl = (GameLayer*)MG::currentLayer;
        [gl->lineSprite reset];
        PlayState* ps = (PlayState*)MG::currentState;
        ps->particleManager->explode(colorID, MPoint(x+width/2,y+height/4));
    }
}
