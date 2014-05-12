//
//  MyScene.h
//  MC
//

//  Copyright (c) 2013 Robert Payne. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class MarbleQueue;
@class MarbleStack;
@class Marble;

@interface MyScene : SKScene{
    NSMutableArray      *marbles;
    CGPoint             points[150];         //max marbles: 100 - 21 = 79, but set to 35
    MarbleQueue         *marbleRes;
    MarbleStack         *minute;
    MarbleStack         *fiveMin;
    MarbleStack         *fifteenMin;
    MarbleStack         *hour;
    Marble              *temp;
    SKLabelNode         *time;
    SKLabelNode         *cycleCounter;
    SKLabelNode         *up;
    SKLabelNode         *down;
    SKLabelNode         *numOfMarblesLabel;
    SKLabelNode         *touchToStart;
    SKLabelNode         *completeCycle;
    SKLabelNode         *pauseButton;
    double              delta;
    int                 clockMinutes;
    int                 clockHours;
    int                 numOfMarbles;
    int                 cycles;
    BOOL                hasStarted;
    BOOL                isNotPaused;
    BOOL                foundCompleteCycle;
    BOOL                occupied[150];

    
}
-(int)findNextSpot;
-(void)initPointForPosition;
-(void)checkAndUpdatePos;
-(void)emptyMinuteTray:(Marble*)marble;
-(void)emptyFiveMinuteTray:(Marble*)marble;
-(void)emptyFifteenMinuteTray:(Marble*)marble;
-(void)emptyHourTray:(Marble*)marble;
@end
