//
//  MyScene.m
//  MC
//
//  Created by Robert Payne on 11/9/13.
//  Copyright (c) 2013 Robert Payne. All rights reserved.
//

#import "MyScene.h"
#import "Marble.h"
#import "MarbleStack.h"
#import "MarbleQueue.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.initPointForPosition;
        //Setting up the background, must be done before any other node is added to the scene
        self.backgroundColor = [SKColor colorWithRed:0.8 green:0.8 blue:0.85 alpha:1.0];
        SKSpriteNode *background = [[SKSpriteNode alloc]initWithImageNamed:@"mcBackground"];
        background.size = CGSizeMake(480 * .70, 320 * .70);
        background.position = CGPointMake(170, 255);
        [self addChild:background];

        //Initializing the instance booleans used to control the scene
        hasStarted = NO;
        isNotPaused = YES;
        foundCompleteCycle = NO;
        for(int i = 0; i < 150; i++){
            occupied[i] = NO;
        }

        //Initializing the structures that will represent the marble clock
        marbleRes = [[MarbleQueue alloc]init];
        minute = [[MarbleStack alloc]init];
        fiveMin = [[MarbleStack alloc]init];
        fifteenMin = [[MarbleStack alloc] init];
        hour = [[MarbleStack alloc]init];
        temp = [[Marble alloc]init];
        
        //Setting up the label for the numeric clock on the display
        time = [[SKLabelNode alloc]initWithFontNamed:@"Menlo"];
        time.text = @"0:00";
        [time setFontColor:[UIColor colorWithRed:.4 green:.05 blue:.05 alpha:.95]];
        time.position = CGPointMake(245, 265);
        time.fontSize = 12;
        
        //Setting up the label for the 12 hour cycle counter
        cycleCounter = [[SKLabelNode alloc]initWithFontNamed:@"Menlo"];
        //The following line does not work to access label.color
        //cycleCounter.color = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.9f];
        //This one will access color and set it to the UIColor
        [cycleCounter setFontColor:[UIColor colorWithRed:.2f green:.2f blue:.25f alpha:.9f]];
        cycleCounter.text = @"0";
        cycleCounter.position = CGPointMake(120, 265);
        cycleCounter.fontSize = 12;
        
        //Setting up the label that gives the user the instruction for starting the marble clock
        touchToStart = [[SKLabelNode alloc]initWithFontNamed:@"Menlo"];
        touchToStart.text = @"<Touch to start>";
        touchToStart.position = CGPointMake(160, 265);
        touchToStart.fontSize = 24;
        
        //Setting up the label for pausing the marble clock
        pauseButton = [[SKLabelNode alloc]initWithFontNamed:@"Menlo"];
        pauseButton.text = @"<Touch to (un)pause>";
        pauseButton.position = CGPointMake(270, 170);
        pauseButton.fontSize = 8;
        
        //Setting up the label that represents the down arrow for selecting the number of marbles
        down = [[SKLabelNode alloc]initWithFontNamed:@"Menlo"];
        down.text = @"v";
        down.position = CGPointMake(270, 170);
        down.fontSize = 24;
        
        //Setting up the label that represents the up arrow for selecting the number of marbles
        up = [[SKLabelNode alloc]initWithFontNamed:@"Menlo"];
        up.text = @"^";
        up.position = CGPointMake(270, 220);
        up.fontSize = 24;
        
        //Setting up the number of marbles label that is displayed before running the marble clock
        numOfMarblesLabel = [[SKLabelNode alloc]initWithFontNamed:@"Menlo"];
        numOfMarblesLabel.text = @"21";
        numOfMarblesLabel.position = CGPointMake(270, 195);
        numOfMarblesLabel.fontSize = 24;
        //Initial number of marbles
        numOfMarbles = 21;
        
        //Setting up the label for the complete cycle (when the marbles reach in order status)
        completeCycle = [[SKLabelNode alloc]initWithFontNamed:@"Menlo"];
        completeCycle.position = CGPointMake(270, 195);
        completeCycle.fontSize = 9;

        //Initializing the counts to 0
        clockMinutes = 0;
        clockHours = 0;
        cycles = 0;
        //delta is used if we want to display the clock in a slower manner
        //right now it is set up to run as fast as the hardware can run it
        delta = 0;
        
        //Adding the labels that are associated with the start screen
        [self addChild:touchToStart];
        [self addChild:numOfMarblesLabel];
        [self addChild:up];
        [self addChild:completeCycle];
        [self addChild:down];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        //If touch to start is pressed, we want to start up the marble clock
        //and move the labels associated with the start up screen away
        if([touchToStart containsPoint:location]){
            hasStarted = YES;
            [self setupMarbles];
            [self addChild:time];
            [self addChild:cycleCounter];
            touchToStart.position = CGPointMake(1000, 1000);
            up.position = CGPointMake(1000, 1000);
            down.position = CGPointMake(1000, 1000);
            numOfMarblesLabel.position = CGPointMake(1000, 1000);
            [self addChild:pauseButton];

        } else if([up containsPoint:location]){ //increase the number of marbles in the clock
            if(numOfMarbles < 70){
                numOfMarbles++;
                numOfMarblesLabel.text = [NSString stringWithFormat:@"%i", numOfMarbles];
            }
        } else if([down containsPoint:location]){ //decrease the number of marbles in the clock
            if(numOfMarbles > 21){
                numOfMarbles--;
                numOfMarblesLabel.text = [NSString stringWithFormat:@"%i", numOfMarbles];
            }
        } else if([pauseButton containsPoint:location]){ //pause/unpause the marble clock
            if(isNotPaused)
                isNotPaused = NO;
            else
                isNotPaused = YES;
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

 //   delta += .1;
 //   if(delta > .1){
 //       delta = 0;
    //call the function that runs the marble clock on each update
        [self checkAndUpdatePos];
 //   }
    
}
-(void)initPointForPosition{
    //setting up all of the points that the marbles can have
    //first point is the marble about to be dequeued from the resevior
    points[0] = CGPointMake(15, 295);
    //first point in minute
    int i;
    for(i = 1; i< 5; i++)
        points[i] = CGPointMake(15, 150  + ((i-1) * 24));

    //first point in five minutes
    points[5] = CGPointMake(63, 150);
    points[6] = CGPointMake(63, 174);
    //first point in fifteen minutes
    points[7] = CGPointMake(111, 150);
    points[8] = CGPointMake(111, 174);
    points[9] = CGPointMake(111, 198);
    //first point in hours
    for(i = 10; i < 21; i++){
        points[i] = CGPointMake(159 + (((i-10)%3)*24), 150 + (((i-10)/3) * 24));
    }

   //last point in the resevior (decrements down to point[21]
    for(i = 49; i< 150; i++){
        points[i] = CGPointMake(87 + ((i -49) * 24), 343);
    }

    points[49] = CGPointMake(87, 343);
    points[48] = CGPointMake(63, 343);
    points[47] = CGPointMake(39, 343);
    points[46] = CGPointMake(15, 343);
    points[45] = CGPointMake(15, 319);
    points[44] = CGPointMake(39, 319);
    points[43] = CGPointMake(63, 319);
    points[42] = CGPointMake(87, 319);
    points[41] = CGPointMake(111, 319);
    points[40] = CGPointMake(135, 319);
    points[39] = CGPointMake(159, 319);
    points[38] = CGPointMake(183, 319);
    points[37] = CGPointMake(207, 319);
    points[36] = CGPointMake(231, 319);
    points[35] = CGPointMake(255, 319);
    points[34] = CGPointMake(279, 319);
    points[33] = CGPointMake(303, 319); //start snake around
    points[32] = CGPointMake(303, 295);
    points[31] = CGPointMake(279, 295);
    points[30] = CGPointMake(255, 295);
    points[29] = CGPointMake(231, 295);
    points[28] = CGPointMake(207, 295);
    points[27] = CGPointMake(183, 295);
    points[26] = CGPointMake(159, 295);
    points[25] = CGPointMake(135, 295);
    points[24] = CGPointMake(111, 295);
    points[23] = CGPointMake(87, 295);
    points[22] = CGPointMake(63, 295);
    points[21] = CGPointMake(39, 295);  //2nd spot in the res
}

-(void)checkAndUpdatePos{
    //if the marble clock is paused or hasn't started yet, we're not going to run it
    if(hasStarted && isNotPaused){
        //using the references stored in the NSMutableArray to iterate through each marble
        for(Marble *marble in marbles){
            //Checking to see what position the marble is and depending on it's position
            //we're going to update it accordingly
            //most marbles are going to move one position to animate even though they
            //are already in the correct position in their respective stack/queue
            //the more interesting events involve position 0, which is the position
            //that's leaving the reseveroir to one of the trays
            //when one or more of the trays are full and the dequeued marble comes out
            //we tip each tray in order until we reach the tray that has room.
            //If all the trays are full, this is the end of a cycle and we tip all of
            //the trays and queue the dequeue marble back into the resevoir after all
            //of the trays have been emptied. Only Mario bouncing off of goombas in
            //succession, getting 1-Ups is more satisfying...
            if(marble.statePosition >21){
                if(!occupied[marble.statePosition-1]){
                    occupied[marble.statePosition] = NO;
                    [marble updatePosition:points[marble.statePosition -1] aStatePos:marble.statePosition -1];
                    occupied[marble.statePosition] = YES;
                
            }
        }else if(marble.statePosition == 21){
            if(!occupied[0]){
                occupied[marble.statePosition] = NO;
                [marble updatePosition:points[0] aStatePos:0];
                occupied[0] = YES;
            }
        } else if(marble.statePosition == 0){
            clockMinutes++;
            if(clockMinutes %60 == 0){
                clockHours++;
                if(clockHours%12 == 0){
                    clockHours = 0;
                    cycles++;
                    cycleCounter.text = [NSString stringWithFormat:@"%i",cycles];

                    }
                    clockMinutes = 0;
                }
            
                if(clockMinutes < 10){
                    time.text = [NSString stringWithFormat:@"%i:0%i",clockHours,clockMinutes];
                } else{
                    time.text = [NSString stringWithFormat:@"%i:%i",clockHours,clockMinutes];
                }
            
                if(!occupied[4]){
                    [minute push:[marbleRes dequeue]];
                    occupied[0] = NO;
                    [marble updatePosition:points[4] aStatePos:4];
                    occupied[4] = YES;
                
                }else if(!occupied[6]){
                    [self emptyMinuteTray:marble];
                    [fiveMin push:[marbleRes dequeue]];
                    occupied[0] = NO;
                    [marble updatePosition:points[6] aStatePos:6];
                    occupied[6] = YES;
                
                }else if(!occupied[9]){
                    [self emptyMinuteTray:marble];
                    [self emptyFiveMinuteTray:marble];
                    [fifteenMin push:[marbleRes dequeue]];
                    occupied[0] = NO;
                    [marble updatePosition:points[9] aStatePos:9];
                    occupied[9] = YES;
                
                }else if(!occupied[20]) {
                    [self emptyMinuteTray:marble];
                    [self emptyFiveMinuteTray:marble];
                    [self emptyFifteenMinuteTray:marble];
                    [hour push:[marbleRes dequeue]];
                    occupied[0] = NO;
                    [marble updatePosition:points[20] aStatePos:20];
                    occupied[20] = YES;
                
                }else {
                    [self emptyMinuteTray:marble];
                    [self emptyFiveMinuteTray:marble];
                    [self emptyFifteenMinuteTray:marble];
                    [self emptyHourTray:marble];
                    [marbleRes dequeue];
                    [marbleRes enqueue:marble];
                    int nextOpen = [self findNextSpot];
                    occupied[0] = NO;
                    [marble updatePosition:points[nextOpen + 1] aStatePos:nextOpen + 1];
                    occupied[nextOpen + 1]= YES;
                    if(!foundCompleteCycle){
                        [self checkOrderOfMarbles];
                    }
                }
            } else if(marble.statePosition > 1 && marble.statePosition < 5){
                if(!occupied[marble.statePosition-1]){
                    occupied[marble.statePosition] = NO;
                    [marble updatePosition:points[marble.statePosition -1] aStatePos:marble.statePosition -1];
                    occupied[marble.statePosition] = YES;
                }
            } else if(marble.statePosition == 6){
                if(!occupied[marble.statePosition-1]){
                    occupied[marble.statePosition] = NO;
                    [marble updatePosition:points[marble.statePosition -1] aStatePos:marble.statePosition -1];
                    occupied[marble.statePosition] = YES;
                }
            }else if(marble.statePosition > 7 && marble.statePosition < 10){
                if(!occupied[marble.statePosition-1]){
                    occupied[marble.statePosition] = NO;
                    [marble updatePosition:points[marble.statePosition -1] aStatePos:marble.statePosition -1];
                    occupied[marble.statePosition] = YES;
                }
            }else if(marble.statePosition > 10 && marble.statePosition < 21){
       //     NSLog(@"99 marble state pos: %i", marble.statePosition);

                if(!occupied[marble.statePosition-1]){
                    occupied[marble.statePosition] = NO;
                    [marble updatePosition:points[marble.statePosition -1] aStatePos:marble.statePosition -1];
                    occupied[marble.statePosition] = YES;
                }
            }
        }
    }
}
-(void)emptyMinuteTray:(Marble*)marble{

    int nextOpen = [self findNextSpot];
    for(int i = 0; i < 4; i++){
    temp = [minute pop];
    [marbleRes enqueue: temp];
    [temp updatePosition:points[nextOpen+1 + i] aStatePos:nextOpen + 1+ i];
    occupied[nextOpen + 1+ i] = YES;
    occupied[1+ i] = NO;
    }
}
-(void)emptyFiveMinuteTray:(Marble*)marble{
    int nextOpen = [self findNextSpot];
    for(int i =0; i < 2; i++){
    temp = [fiveMin pop];
    [marbleRes enqueue: temp];
    [temp updatePosition:points[nextOpen+1+ i] aStatePos:nextOpen + 1+ i];
    occupied[nextOpen + 1+ i] = YES;
    occupied[5+ i] = NO;
    }
}
-(void)emptyFifteenMinuteTray:(Marble*)marble{
    int nextOpen = [self findNextSpot];
    for(int i = 0; i < 3; i++){
    temp = [fifteenMin pop];
    [marbleRes enqueue: temp];
    [temp updatePosition:points[nextOpen+1 + i] aStatePos:nextOpen + 1 + i];
    occupied[nextOpen + 1 + i] = YES;
    occupied[7 + i] = NO;
    }

}
-(void)emptyHourTray:(Marble*)marble{
    int nextOpen = [self findNextSpot];
    for(int i = 0; i < 11; i++){
        temp = [hour pop];
        [marbleRes enqueue: temp];
        [temp updatePosition:points[nextOpen+1+i] aStatePos:nextOpen + 1 + i];
        occupied[nextOpen + 1 + i] = YES;
        occupied[10 + i] = NO;
    }
}
-(int)findNextSpot{
    int nextOpen = 149;
    do{
        nextOpen--;
    }while(!occupied[nextOpen]);
    return nextOpen;
}

-(BOOL)checkOrderOfMarbles{
    int current = 1;
    NSMutableArray *tempMarbleSack = [[NSMutableArray alloc]init];
    for(int i = 0; i < numOfMarbles; i++){
        [tempMarbleSack addObject:[marbleRes dequeue]];
        [marbleRes enqueue:[tempMarbleSack objectAtIndex:i]];
    }
    for(Marble *marble in tempMarbleSack){
        if(marble.marbleNumber == current){
            current++;
        }
        else{
            return NO;
        }
    }
    
    completeCycle.text = [NSString stringWithFormat:@"complete cycle: %i", cycles];
    [completeCycle setFontColor:[UIColor colorWithRed:.9f green:.2f blue:.25f alpha:1]];
    foundCompleteCycle = YES;
    return YES;
}

-(void)setupMarbles{
    //Sets up the marble structures before the clock actually starts up. Is called after
    //"Touch to Start" has been touched.
    //Notice the use of double referencing. The updates of each individual marble required
    //the kind of control that NSMutableArray provides, yet controlling the movement between
    //data stuctures is better handled by the stack/queues. The overhead associated with this
    //is very little cost and keeps the algorithm at O(n) time on each update.
    Marble *marble = [[Marble alloc] initWithPosition:points[0] aStatePos:0 marbleNum:1];
    occupied[marble.statePosition] = YES;
    
    marbles = [[NSMutableArray alloc] init];
    [marbles addObject:marble];
    [marbleRes enqueue:marble];
    
    for(int i = 0; i < numOfMarbles -1; i++){
        marble = [[Marble alloc] initWithPosition:points[i+21] aStatePos:(i +21) marbleNum:(i + 2)];
        occupied[marble.statePosition] = YES;
        [marbles addObject:marble];
        [marbleRes enqueue:marble ];
    }
    for(Marble *marb in marbles){
        [self addChild:marb.sprite];
        [self addChild:marb.numberLabel];
    }
}

@end
