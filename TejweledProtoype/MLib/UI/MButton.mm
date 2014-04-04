//
//  MButton.mm
//  Blacklight
//
//  Created by Arshad K C on 17/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MButton.h"
#import "TransformUtils.h"
#if CC_SPRITEBATCHNODE_RENDER_SUBPIXEL
#define RENDER_IN_SUBPIXEL
#else
#define RENDER_IN_SUBPIXEL(__A__) ( (int)(__A__))
#endif

@implementation MButton

@synthesize pressed;

-(id) init
{
	if( (self=[super init]) ) {
	
	}
	
	return self;
}



@end
