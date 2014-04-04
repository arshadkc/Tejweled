//
//  MVector.h
//  TejweledProtoype
//
//  Created by Arshad on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef _VECTOR_2F_H
#define _VECTOR_2F_H
#import "MPoint.h"
//class Tuple2f;
class MVector : public MPoint
{
public:
    // Contructors
    
    MVector () : MPoint( 0.0f, 0.0f )
    {
    }
    
    MVector(float x, float y ) : MPoint(x,y)
    {
        
    }
    
    void normalize();
    
    float getMagnitude();
    
};


#endif
