//
//  PlayState.cpp
//  TejweledProtoype
//
//  Created by Arshad on 11/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "PlayState.h"
#import "MDisplay.h"
#import "MGx.h"
#import "MCamera.h"
#import "MG.h"
#import "Orbs.h"
#import "ParticleManager.h"

#define SPAWN_TIME 2.3f

PlayState::PlayState()
{
    c_groupOrbs = NULL;
}

PlayState::~PlayState()
{	
	c_groupOrbs->removeAllObjects();
	delete c_groupOrbs;
	c_groupOrbs = NULL;
    
    
	c_groupPlatform->removeAllObjects();
	delete c_groupPlatform;
	c_groupPlatform = NULL;
    
	c_groupMixOrbs->removeAllObjects();
	delete c_groupMixOrbs;
	c_groupMixOrbs = NULL;
    
    delete particleManager;
    particleManager = NULL;
    
}

void PlayState::create()
{
	c_groupOrbs = new MGroup();	
    
	c_groupPlatform = new MGroup();
    
    c_groupMixOrbs = new MGroup();
    
	gameLayer = (GameLayer*)MG::currentLayer;
    
    particleManager = new ParticleManager((CCNode*)gameLayer);
	
	initialize();
	MGx::setCollisionListener(this);
}


void PlayState::initialize()
{
    state = 1;
    
    _iteration = 5;
    
    int x = 1;
    
    // Create platform
    MObject* platform = new MObject();
    platform->width = 320;
    platform->height = 1;
    platform->x = 0;
    platform->y = 0;
    platform->immovable = true;
    addObject(platform);
    c_groupPlatform->addObject(platform);
    
    // Generate shuffling vectors.
    for ( int i=0 ; i < 6; i++ )
    {
        vecColPosition.push_back(x);
        x+=53;
    }  
    
    for ( int i=0 ; i < 3; i++ )
    {
        vecOrbsID.push_back(i);
    }
    
    for ( int i=3 ; i < 6; i++ )
    {
        vecOrbsMixID.push_back(i);
    }
    
    
    // Initialize Grid
    for ( int i=0; i < 9; i++)
    {
        for (int j=0; j < 6; j++) 
        {
            grid[i][j] = -1;
            ghostGrid[i][j] = false;
            orbsGrid[i][j] = NULL;
        }
    }
    
    // Create orbs pool
    for ( int i=0; i < 54; i++)
    {
        int posX = 0;
        uint orbID = 0;
        
        Orbs* display = new Orbs(orbID,(CCNode*)gameLayer);
        display->x = posX;
        display->y = 0;
        display->velocity.y = -50;
        display->elasticity = 0.0f;
        display->add();
        display->UUID = 11;
        addObject(display);
        c_groupOrbs->addObject(display); 
        
        display->kill();
    }
    
    // Create orbs pool
    for ( int i=0; i < 1; i++)
    {
        uint orbID = 0;
        
        Orbs* display = new Orbs(orbID,(CCNode*)gameLayer);
        display->x = 0;
        display->y = 0;
        display->velocity.y = 0;
        display->elasticity = 0.0f;
        display->add();
        display->UUID = 12;
        addObject(display);
        c_groupMixOrbs->addObject(display); 
        
        display->kill();
    } 
}

void PlayState::update()
{
    if ( state == 2 ) return;
    spawnTimer+=MG::dt;
    if ( spawnTimer >= SPAWN_TIME )
    {
        spawnTimer = 0;
        spawnOrbs();
    }
    
    // Update changed column
    int size = vecEffectedCol.size();
    for ( int e=0 ; e < size; e++)
    {
        for ( int k=0; k < 9; k++)
        {
            int temp = vecEffectedCol[e];
            grid[k][temp] = -1;
            Orbs* o = orbsGrid[k][temp];
            if ( o != NULL && o->isGrounded  )
            {
                o->isGrounded = false;
                o->immovable = false;
                o->velocity.y = -100;
                orbsGrid[k][temp] = NULL;
            }
        }
    }
    
    vecEffectedCol.clear();
    
    for ( int i=0 ; i < _iteration ; i++)
    {
        // collision and overlap
        MGx::overlap(c_groupMixOrbs, c_groupOrbs);
        
        MGx::collide(c_groupOrbs,c_groupOrbs);
        MGx::collide(c_groupPlatform, c_groupOrbs);
    }
    
    particleManager->update();
    
	MState::update();
    
    
}

void PlayState::spawnOrbs()
{
    std::random_shuffle( vecColPosition.begin(), vecColPosition.end() );
    std::random_shuffle( vecOrbsID.begin(), vecOrbsID.end() );
    std::random_shuffle( vecOrbsMixID.begin(), vecOrbsMixID.end() );    
    
    int posX = vecColPosition[0];
    
    float chance = (float)rand()/RAND_MAX * 10.0f;
    
    uint orbID;
    
    if ( chance > 8 )
        orbID = vecOrbsMixID[0];
    else
        orbID = vecOrbsID[0];
    
    Orbs* recycleOrb = (Orbs*)c_groupOrbs->getFirstAvailable();
    if ( recycleOrb )
    {
        recycleOrb->reset(posX, 500);
        recycleOrb->velocity.y = -40;
        recycleOrb->setColor(orbID);
        recycleOrb->add();
    }    
    else {
        printf("\n No Free Orbs");
    }
}


Orbs* PlayState::findOrbsAtPosition(MPoint point)
{
    vector<MObject*> vecOrbs = c_groupOrbs->getMembers();
    Orbs* orb = NULL;
    float offset = 20;
    
    for ( int i=0; i < vecOrbs.size(); i++)
    {
        if ( vecOrbs[i]->alive )
        {
            if ( point.x >= vecOrbs[i]->x - offset && point.x <= (vecOrbs[i]->x + vecOrbs[i]->width + offset) && point.y >= vecOrbs[i]->y - offset && point.y <= ( vecOrbs[i]->y + vecOrbs[i]->height + offset) )
            {
                orb = (Orbs*)vecOrbs[i];
                break;
            }
        }
    }
    
    return orb;
}

void PlayState::addToGrid(Orbs* orb)
{
    float _x = orb->x-1;
    float _y = orb->y-1;
    
    int col = _x/53;
    int row = _y/53;    
    
    if ( row == 8 )
    {
        state = 2;
        GameLayer* layer = (GameLayer*)MG::currentLayer;
        [layer gameOver];
        return;
    }
    if ( row >=0 && row < 9 && col >= 0 && col < 6 )
    {
        if ( grid[row][col] == -1 )
        {
            grid[row][col] = orb->colorID;
            printf("\n row %d , col %d",row,col);
        }
        else {
            printf("\n Not Empty %d , %d",row,col);
        }
        if ( orbsGrid[row][col] == NULL )
        {
            orbsGrid[row][col] = orb;
            //            printf("\n row %d , col %d",row,col);
        }
        else {
            //          printf("\n Not Empty");
        } 
    }
    else {
    //    printf("\nBug");
    }
    eliminateOrbs(grid[0][0]);
    
}

bool PlayState::isGridEmpty(MPoint pos)
{
    float _x = pos.x-1;
    float _y = pos.y-1;
    
    int col = _x/53;
    int row = _y/53;    
    
    if ( row >=0 && row < 9 && col >= 0 && col < 6 )
    {
        if ( grid[row][col] == -1 )
            return true;
        else
            return false;
    }
    return false;
}

void PlayState::cleanGhostGrid()
{
    for ( int i=0; i < 9; i++)
        for (int j=0; j < 6; j++) 
            ghostGrid[i][j] = false;
}

void PlayState::removeFromGrid()
{
    for ( int i=0; i < 9; i++)
        for (int j=0; j < 6; j++) 
        {
            if ( ghostGrid[i][j] == true )
            {
                vecEffectedCol.push_back(j);
                grid[i][j] = -1;
                Orbs* o = orbsGrid[i][j];
                o->setSolid(false);
                o->showCrack();
                orbsGrid[i][j] = NULL;
                ghostGrid[i][j] = false;
            }
        }
    
}


bool PlayState::eliminateOrbs(int color )
{
    static int r = 0,c = 0;
    rightCount = 0;
    
    cleanGhostGrid();
    checkRight(r, c, color);
    cleanGhostGrid();    
    checkTop(r, c, color);
    cleanGhostGrid();    
    checkDiagonalLeft(r, c, color);
    cleanGhostGrid();    
    checkDiagonalRight(r, c, color);    
    
    c++;
    if ( c > 5 )
    {
        c = 0;
        r++;
    }
    if ( r > 8 )
    {
        c = 0;
        r = 0;
        return false;
    }
    return eliminateOrbs(grid[r][c]);
}

bool PlayState::checkRight(int r, int c, int color )
{
    if ( c <0 || c > 5 || color == -1)
    {
        if ( rightCount >=3  )
        {
            rightCount = 0;
            removeFromGrid();
            return true;
        }
        rightCount = 0;
        return false;
    }
    
    if ( grid[r][c] == color)
    {
        rightCount++;
        ghostGrid[r][c] = true;
//        printf("\n Match %d , %d",r,c);
    }
    else
    {
        if ( rightCount >=3  )
        {
            rightCount = 0;
            removeFromGrid();
            return true;
        }
        cleanGhostGrid();
        rightCount = 0;
        return false;
    }
    
//    if ( rightCount >=3  )
//    {
//        rightCount = 0;
//        removeFromGrid();
//        return true;
//    }
    
    return checkRight(r, c+1, color);
    
}

bool PlayState::checkTop(int r, int c, int color )
{
    if ( r <0 || r > 8 || color == -1)
    {
        if ( rightCount >=3  )
        {
            rightCount = 0;
            removeFromGrid();
            return true;
        }
        rightCount = 0;
        return false;
    }
    
    if ( grid[r][c] == color)
    {
        rightCount++;
        ghostGrid[r][c] = true;
        //        printf("\n Match %d , %d",r,c);
    }
    else
    {
        if ( rightCount >=3  )
        {
            rightCount = 0;
            removeFromGrid();
            return true;
        }        
        cleanGhostGrid();
        rightCount = 0;
        return false;
    }
    
//    if ( rightCount >=3  )
//    {
//        rightCount = 0;
//        removeFromGrid();
//        return true;
//    }
    
    return checkTop(r+1, c, color);
    
}


bool PlayState::checkDiagonalRight(int r, int c, int color )
{
    if ( c <0 || c > 5 || r <0 || r > 8 || color == -1)
    {
        if ( rightCount >=3  )
        {
            rightCount = 0;
            removeFromGrid();
            return true;
        }        
        rightCount = 0;
        return false;
    }
    
    if ( grid[r][c] == color)
    {
        rightCount++;
        ghostGrid[r][c] = true;
        //        printf("\n Match %d , %d",r,c);
    }
    else
    {
        if ( rightCount >=3  )
        {
            rightCount = 0;
            removeFromGrid();
            return true;
        }        
        cleanGhostGrid();
        rightCount = 0;
        return false;
    }
    
//    if ( rightCount >=3  )
//    {
//        rightCount = 0;
//        removeFromGrid();
//        return true;
//    }
    
    return checkDiagonalRight(r+1, c+1, color);
}

bool PlayState::checkDiagonalLeft(int r, int c, int color )
{
    if ( c <0 || c > 5 || r <0 || r > 8 || color == -1)
    {
        if ( rightCount >=3  )
        {
            rightCount = 0;
            removeFromGrid();
            return true;
        }        
        rightCount = 0;
        return false;
    }
    
    if ( grid[r][c] == color)
    {
        rightCount++;
        ghostGrid[r][c] = true;
        //        printf("\n Match %d , %d",r,c);
    }
    else
    {
        if ( rightCount >=3  )
        {
            rightCount = 0;
            removeFromGrid();
            return true;
        }        
        cleanGhostGrid();
        rightCount = 0;
        return false;
    }
    
//    if ( rightCount >=3  )
//    {
//        rightCount = 0;
//        removeFromGrid();
//        return true;
//    }
    
    return checkDiagonalLeft(r+1, c-1, color); 
}

void PlayState::onCollision(MObject* obj1, MObject* obj2)
{
    //	printf("\n Collision");
	obj1->onHit(obj2);
	if ( obj1->isTouching(MObject::LEFT))
		obj1->onHitLeft(obj2);
	if ( obj1->isTouching(MObject::RIGHT) )
		obj1->onHitRight(obj2);
	if ( obj1->isTouching(MObject::UP) )
		obj1->onHitTop(obj2);
	if ( obj1->isTouching(MObject::DOWN) )
		obj1->onHitBottom(obj2);
	
	obj2->onHit(obj1);
	if ( obj2->isTouching(MObject::LEFT) )
		obj2->onHitLeft(obj1);
	if ( obj2->isTouching(MObject::RIGHT) )
		obj2->onHitRight(obj1);
	if ( obj2->isTouching(MObject::UP) )
		obj2->onHitTop(obj1);
	if ( obj2->isTouching(MObject::DOWN) )
		obj2->onHitBottom(obj1);	
	
}

void PlayState::onOverlap(MObject* obj1, MObject* obj2)
{
	//printf("\n Overlap");	
	obj1->onOverlap(obj2);
	obj2->onOverlap(obj1);
}

void PlayState::onTouch(MPoint point)
{
//   particleManager->explode(0, MPoint(250,100));
//    printf("\n Pos %f , %f",point.x,point.y);
    selectedOrb = findOrbsAtPosition(point);
    if ( selectedOrb )
    {
//        printf("\n Color %u",selectedOrb->colorID);
    }
}

void PlayState::onSwipe(MSwipeDirection direction)
{
    float distance = 53;
    switch (direction) {
        case SWIPE_RIGHT:
            distance = 53;
            break;
        case SWIPE_LEFT:
            distance = -53;
            break;
        case SWIPE_DOWN:
        {
           if ( selectedOrb && !selectedOrb->isGrounded)
           {
               selectedOrb->velocity.y = -300;
               return;
           }
        }
        default:
            break;
    }

    if ( selectedOrb && !selectedOrb->isGrounded)
    {
        MPoint prePos(selectedOrb->x+distance,selectedOrb->y);
        if ( isGridEmpty(prePos) )
        {
            selectedOrb->x += distance;
            selectedOrb->last.x = selectedOrb->x;
            selectedOrb->last.y = selectedOrb->y;            
            selectedOrb = NULL;
        }
    }
}

