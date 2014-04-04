//
//  MButton.h
//  Blacklight
//
//  Created by Arshad K C on 17/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MButton : CCSprite {

	int pressed;
}
@property(nonatomic) int pressed;
-(id) init;
@end
