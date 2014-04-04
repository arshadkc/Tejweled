/*
 *  MCamera.h
 *  Blacklight
 *
 *  Created by Arshad K C on 11/10/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import "MPoint.h"
class MObject;
class MRect;

class MCamera
{
	MPoint velocity;
	MPoint acceleration;
	float x;
	float y;
	float width;
	float height;
	
	/* Shake */
	float shakeIntensity;
	float shakeDuration;
	unsigned int shakeDirection;
	MPoint shakeOffset;
	
	/* Fade */
	ccColor3B fadeColor;
	float fadeDuration;
	float fadeAlpha;
	
	/* Flash */
	ccColor3B flashColor;
	float flashDuration;
	float flashAlpha;	
	
	CCLayerColor* cameraLayer;
	CCSprite* bgLayer;
	
	MObject* m_target;
	
	/* Static Constants*/
public:
	static unsigned int SHAKE_BOTH_AXIS, SHAKE_HORIZONTAL_ONLY, SHAKE_VERTICAL_ONLY;
	
	static MCamera* g_Camera;
	
	MCamera();
	
	virtual ~MCamera();	
	
	/* Returns Singleton Camera object */
	static MCamera* getInstance();
	/* Set perspective */
	void vluPerspective(GLfloat fovy, GLfloat aspect, GLfloat zNear, GLfloat zFar);
	/* Update Camera */
	void update();
	/* Shakes the camera */
	void shake(float intensity=6.0f, float duration = 0.3f,unsigned int direction = SHAKE_BOTH_AXIS, bool force = false);
	/* Fade the screen */
	void fade(ccColor3B color = ccWHITE, float duration = 2.0f, bool force = false);
	/* Flash the screen */
	void flash(ccColor3B color = ccRED, float duration = 3.0f, bool force = false);	
	/* Get Screen bounding rect */
	MRect getScreenBounds();
	/* Check if object is in screen both X-Y*/
	bool inScreen(MObject* obj);
	/* Check if object is in screen both X*/
	bool inScreenX(MObject* obj);	
	/* Check if object is in screen both Y*/
	bool inScreenY(MObject* obj);		
	/* Check if object is out of the screen both X-Y*/
	bool outOfScreen(MObject* obj);	
	/* Check if object is out of the screen both X*/
	bool outOfScreenX(MObject* obj);		
	/* Check if object is out of the screen both X*/
	bool outOfScreenY(MObject* obj);	
	/* Reset the camera */
	void reset();
	/* Set Target */
	void setTarget(MObject* _target);
	
};