//
//  MLeftRightButton.h
//  Blacklight
//
//  Created by Arshad K C on 21/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Paddle.h"

@interface MLeftRightButton : Paddle {

}
-(void) generateEvents:(CGPoint) point;
@end
