//
//  MyCocos2DClass.h
//  TejweledProtoype
//
//  Created by Arshad on 11/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GameKit/GameKit.h>
#import "MState.h"
#import "MPoint.h"

@class LineSprite;
class Orbs;

@interface GameLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
@public
    MState* state;
    LineSprite* lineSprite;
    MPoint touchPoint;
    Orbs* tempOrb;
    bool isFlick;
    CCMotionStreak* streak; 
    bool restart;
    Orbs* outputColor;
    
    CCLayer* topLayer;
    CCLayer* bgLayer;
}

-(void) update:(ccTime)delta;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void) gameOver;

-(void) reset;

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent*)event;
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent*)event;
- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender;

@end
