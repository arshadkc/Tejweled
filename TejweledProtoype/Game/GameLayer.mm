//
//  MyCocos2DClass.m
//  TejweledProtoype
//
//  Created by Arshad on 11/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "MDisplay.h"
#import "MG.h"
#import "PlayState.h"
#import "MGx.h"
#import "LineSprite.h"
#import "Orbs.h"
#import "MVector.h"
#import "MDisplay.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation GameLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		        
        isFlick = false;
        
        [self scheduleUpdate];
        
		// Set current layer.
		MG::currentLayer = self;
		
//		//Create the camera
//		MG::currentCamera = MCamera::getInstance();
		
		// Create game state.
		state = new PlayState();
		// Set current state.
		MG::currentState = state;
		
		state->create();
        
        MG::levelHeight = 480;
        MG::levelWidth = 320;
        
        
        [self setIsTouchEnabled:true];
        // Set Gestures
//		UISwipeGestureRecognizer* swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
//		[swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
//        [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:swipeGestureLeft];
//		
//		UISwipeGestureRecognizer* swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
//		[swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
//        [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:swipeGestureRight];
        
        bgLayer = [[CCLayer alloc] init];
        [self addChild:bgLayer z:-10];
        
        CCSprite* bgSprite = [CCSprite spriteWithFile:@"bg2.png"];
        [bgSprite setPosition:CGPointMake(160, 240)];
        [bgLayer addChild:bgSprite];
        
        topLayer = [[CCLayer alloc] init];
        [self addChild:topLayer z:10];
        
        lineSprite = [[LineSprite alloc] init];
        [lineSprite reset];
        [self addChild:lineSprite z:1000];
        ccColor3B myColor = ccc3(255, 0, 255);
        streak = [CCMotionStreak streakWithFade:2.0f minSeg:1.0 width:10 color:myColor textureFilename:@"line.png"];
        [self addChild:streak z:10001];
        
        restart = false;
    
        outputColor = new Orbs(0,(CCNode*)topLayer);
        outputColor->kill();
        
	}
	return self;
}


-(void) update:(ccTime)delta
{
    if ( restart )
    {
        restart = false;
        [self reset];
    }
    MG::dt = delta;
    outputColor->update();
    [streak update:delta];
    state->update();
}

- (void)timerFired:(NSTimer*)timer
{
    //	NSLog(@"timerFired: %d",isTap);
	
	[timer invalidate];
    isFlick = false;
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent*)event;
{
//	printf("\n back layer")
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:touch.view];    
    
    MPoint mPoint(point.x,480-point.y);
    MG::currentState->onTouch(mPoint);
    touchPoint = mPoint;
    
    isFlick = true;
    [NSTimer scheduledTimerWithTimeInterval:0.2 
                                     target:self 
                                   selector:@selector(timerFired:) 
                                   userInfo:nil 
                                    repeats:NO];
    
    [lineSprite reset];
    [streak reset];
    if ( ((PlayState*)MG::currentState)->selectedOrb && !((PlayState*)MG::currentState)->selectedOrb->isGrounded )
    {
        Orbs* o = ((PlayState*)MG::currentState)->selectedOrb;
        [lineSprite addFirstOrb:o];
        [lineSprite addSecondOrb:o];        
        [streak setPosition:CGPointMake(o->x+o->width/2, o->y + o->height/2)];
    }

}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:touch.view];    
    MPoint mPoint(point.x,480-point.y);
    
    PlayState* ps = (PlayState*)MG::currentState;
    
    if ( !isFlick && ps->selectedOrb && !ps->selectedOrb->isGrounded)
    {
        [lineSprite addSecondOrb:NULL];
        [lineSprite addSecondPoint:CGPointMake(mPoint.x, mPoint.y)];
        [streak setPosition:CGPointMake(mPoint.x, mPoint.y)];
        
        Orbs* o = ps->findOrbsAtPosition(mPoint);
        if ( o && !o->isGrounded )
        {
            outputColor->reset(o->x  , o->y + o->height);
            int color = o->canCombine(ps->selectedOrb);
            if ( color != -1 )
                color += 10;
            outputColor->setColor(color);
            outputColor->add();
        }
        else {
            outputColor->kill();
        }
    }
    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent*)event
{
 //   printf("end");
    outputColor->kill();
    UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:touch.view];
    MPoint mPoint(point.x,480-point.y);    
    if ( isFlick)
    {
        float xDistance = fabs(mPoint.x - touchPoint.x);
        float yDistance = fabs(mPoint.y - touchPoint.y);
        if ( xDistance > yDistance + 5  )
        {
            if ( mPoint.x > touchPoint.x )
                MG::currentState->onSwipe(SWIPE_RIGHT);
            if ( mPoint.x < touchPoint.x )
                MG::currentState->onSwipe(SWIPE_LEFT);
        }
        
        else if ( yDistance > xDistance + 5  )
        {
            if ( mPoint.y > touchPoint.y )
                MG::currentState->onSwipe(SWIPE_UP);
            if ( mPoint.y < touchPoint.y )
                MG::currentState->onSwipe(SWIPE_DOWN);
        }
        
        [lineSprite reset];
        [streak reset];
    }
    
    else 
    {
        PlayState* ps = (PlayState*)MG::currentState;
        Orbs* o = ps->findOrbsAtPosition(mPoint);
        if ( o && ps->selectedOrb && !o->isGrounded && !ps->selectedOrb->isGrounded && o->canCombine(ps->selectedOrb) != -1)
        {
            [streak setPosition:CGPointMake(o->x+o->width/2, o->y + o->height/2)];
            [lineSprite addSecondOrb:o];
            o->velocity.y = 0;
            // kill the real one and start animation
            float x ,y,color;
            x = ps->selectedOrb->x;
            y = ps->selectedOrb->y;
            color = ps->selectedOrb->colorID;
            ps->selectedOrb->kill();
            ps->selectedOrb = NULL;
            Orbs* mOrb = (Orbs*)ps->c_groupMixOrbs->getFirstAvailable();
            mOrb->reset(x, y);
            mOrb->setColor(color);
            mOrb->add();
            MVector v( (o->x - x ), (o->y - y) );
            float mag = v.getMagnitude();
            v.normalize();
            mOrb->velocity.x = v.x*5*mag;
            mOrb->velocity.y = v.y*5*mag;
            [lineSprite addFirstOrb:mOrb];
        }
        else
        {
            [lineSprite reset];
            [streak reset];
        }
    }
    if ( isFlick )
        isFlick = false;
//    [lineSprite reset];
}

- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender 
{
 //       printf("swipe");
	UISwipeGestureRecognizerDirection direction = [sender direction];
	
	switch (direction) {
		case UISwipeGestureRecognizerDirectionRight:
			MG::currentState->onSwipe(SWIPE_RIGHT);
			break;
		case UISwipeGestureRecognizerDirectionLeft:
			MG::currentState->onSwipe(SWIPE_LEFT);
			break;
		case UISwipeGestureRecognizerDirectionUp:
			MG::currentState->onSwipe(SWIPE_UP);
			break;
		default:
			break;
	}
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[topLayer release];
    [bgLayer release];
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) gameOver
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" 
                                                    message:@"You Lost !" 
                                                   delegate:self 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    restart = true;
}
-(void) reset
{
    
	//Reset Camera
//	MCamera::getInstance()->reset();
	
	// destroy state.
	delete state;
	MG::currentState = NULL;
	state = NULL;
	
	// Create game state.
	state = new PlayState();
	
	// Set current state.
	MG::currentState = state;
	
	state->create();
    
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
