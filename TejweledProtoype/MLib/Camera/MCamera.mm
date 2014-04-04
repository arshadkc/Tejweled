/*
 *  MCamera.mm
 *  Blacklight
 *
 *  Created by Arshad K C on 11/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "MCamera.h"
#import "MG.h"
#import "MObject.h"
#import "MRect.h"

#define EPSILON 0.00001f;

MCamera* MCamera::g_Camera = NULL;
float y = 0;

unsigned int MCamera::SHAKE_BOTH_AXIS = 0;
unsigned int MCamera::SHAKE_HORIZONTAL_ONLY = 1;
unsigned int MCamera::SHAKE_VERTICAL_ONLY = 2;

MCamera::MCamera()
{
	//vluPerspective(60.0f, 320.0f/480.0f, 0.001f, 1000);
	
	x = 0;
	y = 0;
	width = 480;
	height = 320;
	
	velocity.y = 0;
	
	shakeIntensity = 0.0f;
	shakeDuration = 0.0f;
	shakeDirection = 0;
	shakeOffset.make();	
	
	fadeAlpha = 0.0f;
	fadeDuration = 0.0f;
	fadeColor = ccWHITE;
	
	flashAlpha = 0.0f;
	flashDuration = 0.0f;
	flashColor = ccRED;
	
}

MCamera::~MCamera()
{
	x = 0.0f;
	y = 0.0f;

	// Reset the camera lookAt
	[MG::currentLayer.camera setCenterX:x  centerY:y centerZ:0.0f];
	[MG::currentLayer.camera setEyeX:x   eyeY:y eyeZ:0.1f];	
	
}

MCamera* MCamera::getInstance()
{
	if ( g_Camera == NULL )
	{
		g_Camera = new MCamera();
		
		// Add BG layer
		g_Camera->bgLayer = [CCSprite spriteWithFile:@"bg.png"];
		[g_Camera->bgLayer setPosition:CGPointMake(g_Camera->width/2,g_Camera->height/2)];
		[MG::currentLayer addChild:g_Camera->bgLayer z:-10000];
		
		g_Camera->cameraLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 0) width:g_Camera->width height:g_Camera->height];
//		[g_Camera->cameraLayer setPosition:CGPointMake(g_Camera->width/2,g_Camera->height/2)];
		// Add screen layer to topmost
		[MG::currentLayer addChild:g_Camera->cameraLayer z:10000];
		
//		g_Camera->uiLayer = [[UILayer alloc] init];
//		[MG::currentLayer addChild:g_Camera->uiLayer z:200000];
	}
	return g_Camera;
}

void MCamera::vluPerspective(GLfloat fovy, GLfloat aspect, GLfloat zNear, GLfloat zFar)
{	
	GLfloat xmin, xmax, ymin, ymax;
	
	ymax = zNear * (GLfloat)tanf(fovy * (float)M_PI / 360);
	ymin = -ymax;
	xmin = ymin * aspect;
	xmax = ymax * aspect;
	
//	glFrustumf(xmin, xmax,
//			   ymin, ymax,
//			   zNear, zFar);	
}

void MCamera::update()
{
//	static bool first = true;
//	if ( first )
//		vluPerspective(60.0f, 1, 0.001f, 1000);
//	first = false;

	/* Shake Camera */
	if ( shakeDuration > 0.0f )
	{
		shakeDuration -= MG::dt;
		if ( shakeDuration <= 0.0f )
		{
			shakeDuration = 0.0f;
			shakeOffset.make();
		}
		else
		{
			if ( shakeDirection == SHAKE_BOTH_AXIS || shakeDirection == SHAKE_HORIZONTAL_ONLY )
				shakeOffset.x = (MG::randomNumber()-0.5f) * shakeIntensity;
				
			if ( shakeDirection == SHAKE_BOTH_AXIS || shakeDirection == SHAKE_VERTICAL_ONLY )	
				shakeOffset.y = (MG::randomNumber()-0.5f) * shakeIntensity;		
		}
	}
	
	/* Fade camera layer */
	if ( fadeAlpha > 0.0f && fadeAlpha < 1.0f )
	{
		fadeAlpha += MG::dt / fadeDuration;
		if ( fadeAlpha >= 1.0f )
		{
			fadeAlpha = 1.0f;
		}
	}
	
	/* Flash camera layer */
	if ( flashAlpha > 0.0f )
	{
		flashAlpha -= MG::dt / flashDuration;
		if ( flashAlpha <= 0.0f )
		{
			flashAlpha = 0.0f;
		}
	}	
	
	
	/* Update velocity */
	velocity.x += acceleration.x * MG::dt;
	velocity.y += acceleration.y * MG::dt;	
	
	/* Update position */
//	x += velocity.x * MG::dt;
//	y += velocity.y * MG::dt;	
	
	/* if target is present, follow target */
	if ( m_target )
	{
		x = m_target->x - g_Camera->width/2;
		y = m_target->y - g_Camera->height/2;
		
		if ( x < 0 )
			x = 0;
		if ( y < 0 )
			y = 0;
		if ( (x + g_Camera->width) > MG::levelWidth )
		{
			float diff = (x + g_Camera->width) - MG::levelWidth;
			//printf("\n diff %f , %f , %f",MG::levelWidth,(x + g_Camera->width),diff);			
			x -= diff;
		}
		if ( (y + g_Camera->height) > MG::levelHeight )
		{
			float diff = (y + g_Camera->height) - MG::levelHeight;
			y -= diff;
		}		
	}

	/* Update Camera with position + Camera shake offset */
	[MG::currentLayer.camera setCenterX:(x+shakeOffset.x)  centerY:(y+shakeOffset.y) centerZ:0.0f];
	[MG::currentLayer.camera setEyeX:(x+shakeOffset.x)   eyeY:(y+shakeOffset.y) eyeZ:0.001f];	
	
	
	/* Update BG */
	[g_Camera->bgLayer setPosition:CGPointMake(x+g_Camera->width/2,y+g_Camera->height/2)];
//	[g_Camera->uiLayer setPosition:CGPointMake(x,y)];	
	[g_Camera->cameraLayer setPosition:CGPointMake(x,y)];
	
	/* Fade effect */
	if ( fadeAlpha < 1.0f )
		[cameraLayer setOpacity:fadeAlpha * 255];
	/* Flash effect */
	if ( flashAlpha > 0.0f )
		[cameraLayer setOpacity:flashAlpha * 255];	
}

void MCamera::shake(float intensity, float duration, unsigned int direction, bool force)
{
	if ( !force && (shakeOffset.x != 0.0f || shakeOffset.y != 0.0f))
		return;
	shakeIntensity = intensity;
	shakeDuration = duration;
	shakeDirection = direction;
	shakeOffset.make();
}

void MCamera::fade(ccColor3B color, float duration, bool force)
{
	if ( !force && fadeAlpha > 0.0f )
		return;
	
	fadeColor = color;
	if ( duration < 0.0f )
		duration = 0.0f;
	fadeDuration = duration;
	fadeAlpha = EPSILON;
	[cameraLayer setColor:fadeColor];
}

void MCamera::flash(ccColor3B color, float duration, bool force)
{
	if ( !force && flashAlpha > 0.0f )
		return;
	
	flashColor = color;
	if ( duration < 0.0f )
		duration = 0.0f;
	flashDuration = duration;
	flashAlpha = 1.0f;
	[cameraLayer setColor:flashColor];
	[cameraLayer setOpacity:255];
}

MRect MCamera::getScreenBounds()
{
 //   printf(" Camera : %f , %f , %f , %f",x , y  , g_Camera->width, g_Camera->height);
	return  MRect::make( x  , y  , g_Camera->width, g_Camera->height);
}

bool MCamera::inScreen(MObject* obj)
{
	return ( inScreenX(obj) && inScreenY(obj) );
}

bool MCamera::inScreenX(MObject* obj)
{
	bool result = false;
	MRect screenRect = getScreenBounds();
	float _x = obj->x;
	
	if ( _x >= screenRect.x && _x <= ( screenRect.x + screenRect.width ))
	{
		result = true;
	}
	return result;
}

bool MCamera::inScreenY(MObject* obj)
{
	bool result = false;
	MRect screenRect = getScreenBounds();
	float _y = obj->y;
	
	if ( _y >= screenRect.y && _y <= ( screenRect.y + screenRect.height ) )
	{
		result = true;
	}
	return result;
}

bool MCamera::outOfScreen(MObject* obj)
{
	return ( !inScreenX(obj) || !inScreenY(obj) );
}

bool MCamera::outOfScreenX(MObject* obj)
{
	return !inScreenX(obj);
}

bool MCamera::outOfScreenY(MObject* obj)
{
	return !inScreenY(obj);
}

void MCamera::reset()
{
	x = 0;
	y = 0;
	width = 480;
	height = 320;
	
	velocity.y = 0;
	
	shakeIntensity = 0.0f;
	shakeDuration = 0.0f;
	shakeDirection = 0;
	shakeOffset.make();	
	
	fadeAlpha = 0.0f;
	fadeDuration = 0.0f;
	fadeColor = ccWHITE;
	
	flashAlpha = 0.0f;
	flashDuration = 0.0f;
	flashColor = ccRED;
	
	// Reset the camera lookAt
	[MG::currentLayer.camera setCenterX:x  centerY:y centerZ:0.0f];
	[MG::currentLayer.camera setEyeX:x   eyeY:y eyeZ:0.1f];		
}

void MCamera::setTarget(MObject* _target)
{
	m_target = _target;
}
