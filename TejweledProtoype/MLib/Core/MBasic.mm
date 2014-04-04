/*
 *  MBasic.mm
 *  Blacklight
 *
 *  Created by Arshad K C on 07/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "MBasic.h"


MBasic::MBasic()
{
	exists = true;
	alive = true;
	UUID = -1;
}

MBasic::~MBasic()
{
}

void MBasic::preUpdate()
{
}

void MBasic::update()
{
}

void MBasic::postUpdate()
{
}

void MBasic::kill()
{
	alive = false;
	exists = false;	
}

void MBasic::revive()
{
	alive = true;
	exists = true;
}