/*
 *  MU.mm
 *  Blacklight
 *
 *  Created by Arshad K C on 12/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "MU.h"


MU::MU()
{
}

float MU::srand(float seed)
{
	return ((69621 * int(seed * 0x7FFFFFFF)) % 0x7FFFFFFF) / 0x7FFFFFFF;
}