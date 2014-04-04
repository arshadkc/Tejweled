//
//  LineSprite.h
//  TejweledProtoype
//
//  Created by Arshad on 13/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

class Orbs;

@interface LineSprite : CCSprite {
   @public 
    Orbs* fo;
    Orbs* so;
    CGPoint fp;
    CGPoint sp;    
}

-(id) init;

-(void) draw;

-(void) addFirstOrb:(Orbs*) orb;
-(void) addSecondOrb:(Orbs*) orb;

-(void) addFirstPoint:(CGPoint) p;
-(void) addSecondPoint:(CGPoint) p;

-(void) reset;
@end
