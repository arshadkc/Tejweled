/* TouchesTest (c) Valentin Milea 2009
 */
#import "cocos2d.h"

typedef enum tagPaddleState {
	kPaddleStateGrabbed,
	kPaddleStateUngrabbed
} PaddleState;

@interface Paddle : CCSprite <CCTargetedTouchDelegate> {
@private
	PaddleState state;
@protected
	int prevEvent;
	id delegate;
    
    int pressEventID;
    int releaseEventID;
}

@property(nonatomic, readonly) CGRect rect;
@property(nonatomic, readonly) CGRect rectInPixels;
@property(nonatomic) id delegate;

-(void) setEventID:(int)pressID :(int) releaseID;
+ (id)paddleWithTexture:(CCTexture2D *)texture;
@end
