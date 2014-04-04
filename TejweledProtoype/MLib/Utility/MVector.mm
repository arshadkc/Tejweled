//
//  MVector.m
//  TejweledProtoype
//
//  Created by Arshad on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MVector.h"


void MVector::normalize()
{
	int xsquared = powf(x, 2);
	int ysquared = powf(y, 2);
	
	float denominator = sqrtf( xsquared + ysquared );
	
	if ( denominator > 0.00000001f )
	{
		x /=  denominator;
		y /=  denominator;
	}
	
}

float MVector::getMagnitude()
{
	int xsquared = powf(x, 2);
	int ysquared = powf(y, 2);
	
	float result = sqrtf( xsquared + ysquared );
	
	return result;
}