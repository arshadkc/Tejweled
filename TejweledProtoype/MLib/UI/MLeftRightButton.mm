//
//  MLeftRightButton.mm
//  Blacklight
//
//  Created by Arshad K C on 21/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MLeftRightButton.h"


@implementation MLeftRightButton

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ( ![self containsTouchLocation:touch] ) return NO;
	
	printf("\n Press");
	CGPoint point = [touch locationInView:touch.view];
	[self generateEvents:point];
	
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	// If it weren't for the TouchDispatcher, you would need to keep a reference
	// to the touch from touchBegan and check that the current touch is the same
	// as that one.
	// Actually, it would be even more complicated since in the Cocos dispatcher
	// you get NSSets instead of 1 UITouch, so you'd need to loop through the set
	// in each touchXXX method.
	
	if ( ![self containsTouchLocation:touch] ) return;

	CGPoint point = [touch locationInView:touch.view];
	[self generateEvents:point];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ( [delegate respondsToSelector:@selector(onLeftRightButtonEvent:)] && prevEvent != 2)
	{
		[delegate onLeftRightButtonEvent:2];
		prevEvent = 2;
	}
}

-(void) generateEvents:(CGPoint) point
{
	CGRect rect = [self boundingBox];
	point.y = 320 - point.y;
	
	point.x = point.x - (rect.origin.x);
	point.y = point.y - (rect.origin.y);	
	
	if ( point.x < 87 )
	{
		if ( [delegate respondsToSelector:@selector(onLeftRightButtonEvent:)] && prevEvent != 0)
		{
			[delegate onLeftRightButtonEvent:0];
			prevEvent = 0;
		}
	}
	else 
	{
		if ( [delegate respondsToSelector:@selector(onLeftRightButtonEvent:)] && prevEvent != 1)
		{
			[delegate onLeftRightButtonEvent:1];		
			prevEvent = 1;
		}
	}

}

@end
