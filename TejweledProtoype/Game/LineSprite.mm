//
//  LineSprite.mm
//  TejweledProtoype
//
//  Created by Arshad on 13/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LineSprite.h"
#import "Orbs.h"

@implementation LineSprite


-(id) init
{
    if ( self = [super init ] )
    {
        fo = NULL;
        so = NULL;
    }
    return self;
}

-(void) draw
{
	CGPoint _fp,_sp;
    if ( fo )
    {
        _fp.x = (fo->x+fo->width/2);
        _fp.y = (fo->y+fo->height/2);
    }
    else
    {
        _fp = fp;
    }
    
    if ( so )
    {
        _sp.x = (so->x+so->width/2);
        _sp.y = (so->y+so->height/2);
    }
    else
    {
        _sp = sp;
    }
    
    ccPointSize(4);
    ccDrawColor4B(255,0,0,255);
    ccDrawLine(_fp, _sp);

}

-(void) reset
{
    fo = NULL;
    so = NULL;
    fp.x = fp.y = 0;
    sp.x = sp.y = 0;    
}

-(void) addFirstOrb:(Orbs*) orb
{
    fo = orb;
}

-(void) addSecondOrb:(Orbs*) orb
{
    so = orb;
}

-(void) addFirstPoint:(CGPoint) p
{
    fp = p;
}

-(void) addSecondPoint:(CGPoint) p
{
    sp = p;
}

@end
