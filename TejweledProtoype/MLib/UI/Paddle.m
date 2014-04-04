/* TouchesTest (c) Valentin Milea 2009
 */
#import "Paddle.h"
#import "cocos2d.h"

@implementation Paddle
@synthesize delegate;

- (CGRect)rectInPixels
{
	CGSize s = [texture_ contentSizeInPixels];
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

- (CGRect)rect
{
	CGSize s = [texture_ contentSize];
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

+ (id)paddleWithTexture:(CCTexture2D *)aTexture
{
	return [[[self alloc] initWithTexture:aTexture] autorelease];
}

- (id)initWithTexture:(CCTexture2D *)aTexture
{
	if ((self = [super initWithTexture:aTexture]) ) {
	
		state = kPaddleStateUngrabbed;
	}
	prevEvent = -1;
	return self;
}

-(void) setEventID:(int)pressID :(int) releaseID
{
    pressEventID = pressID;
    releaseEventID = releaseID;
}
- (void)onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}	

- (BOOL)containsTouchLocation:(UITouch *)touch
{	
	CGPoint point = [touch locationInView:touch.view];
	point.y = 320 - point.y;	
	CGRect rect = [self boundingBox];
	return ( CGRectContainsPoint(rect, point) );
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ( ![self containsTouchLocation:touch] ) return NO;

	
	state = kPaddleStateGrabbed;
	printf("\n Press");
	if ( [delegate respondsToSelector:@selector(onPaddleButtonEvent:)] && prevEvent != pressEventID)
	{
		[delegate onPaddleButtonEvent:pressEventID];
		prevEvent = pressEventID;
	}
		
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
	
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ( [delegate respondsToSelector:@selector(onPaddleButtonEvent:)] && prevEvent != releaseEventID)
	{
		[delegate onPaddleButtonEvent:releaseEventID];
		prevEvent = releaseEventID;
	}
}
@end
