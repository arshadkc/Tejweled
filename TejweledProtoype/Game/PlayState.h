//
//  PlayState.h
//  TejweledProtoype
//
//  Created by Arshad on 11/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef TejweledProtoype_PlayState_h
#define TejweledProtoype_PlayState_h

#import "MState.h"
#import "MCollisionListener.h"
#import "vector.h"

using namespace std;

@class GameLayer;

class MDisplay;
class Orbs;
class ParticleManager;

class PlayState : public MState, public MCollisionListener
{
	MGroup* c_groupOrbs;
    MGroup* c_groupPlatform;
	
	// Level Details
	int levelWidth;
	int levelHeight;
	int	  levelID;
	NSString* levelName;
	NSArray* parameters;
	NSString* parameterList;
	GameLayer* gameLayer;
	
    vector<int> vecColPosition;
    vector<int> vecOrbsID;
    vector<int> vecOrbsMixID;
    float spawnTimer;

    
    int grid[9][6];
    bool ghostGrid[9][6];
    Orbs* orbsGrid[9][6];
    
    vector<int> vecEffectedCol;
    
    int rightCount;
    
    int state;
    
    int _iteration;
	
public:
    
    ParticleManager* particleManager;
    
    MGroup* c_groupMixOrbs;
    
    Orbs* selectedOrb;
    
	/* Constructor */
	PlayState();
	
	/* Destructor */
	virtual ~PlayState();	
	
	/* Initializer */
	void create();
	
	/* Update */
	virtual void update();		
	
	/*Collision Listener*/
	virtual void onCollision(MObject* obj1, MObject* obj2);	
	virtual void onOverlap(MObject* obj1, MObject* obj2);		
	
	/* initialize */
	void initialize();
	
	/* Handle touch */
	void onTouch(MPoint point);
	
	void onSwipe(MSwipeDirection direction);
	
	
    /* game related */
     
    void spawnOrbs();
    
    Orbs* findOrbsAtPosition(MPoint point);
    
	void addToGrid(Orbs* orb);
    
    bool isGridEmpty(MPoint pos);
    
    void cleanGhostGrid();
    
    void removeFromGrid();
    
    bool eliminateOrbs(int color );
    
    bool checkRight(int r, int c, int color );
    
    bool checkTop(int r, int c, int color );   
    
    bool checkDiagonalRight(int r, int c, int color );   
    
    bool checkDiagonalLeft(int r, int c, int color );   
	
};

#endif
