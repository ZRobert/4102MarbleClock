//
//  marble.m
//  MC
//
//  Created by Robert Payne on 11/9/13.
//  Copyright (c) 2013 Robert Payne. All rights reserved.
//

#import "Marble.h"

@implementation Marble
@synthesize sprite;
@synthesize numberLabel;
@synthesize statePosition;
@synthesize marbleNumber;


-(id)initWithPosition:(CGPoint)pos aStatePos:(int)statePos marbleNum:(int)marbleNumber{
    //Creating a marble that has an image and a label associated with it
    //The position is going to determine where the marble will be located on
    //the display. statePos gives us an integer value we can use to track
    //the marble and the marble number acts as a marble ID that is generated
    //in order of marble creation. This is useful for checking the order
    //of the marbles to find the complele cycle.
    sprite = [[SKSpriteNode alloc]initWithImageNamed:@"marble"];
    numberLabel = [SKLabelNode labelNodeWithFontNamed:@"Ariel"];
    numberLabel.fontSize = 12;
    numberLabel.fontColor = [UIColor orangeColor];
    numberLabel.text = [NSString stringWithFormat:@"%i",marbleNumber];
    numberLabel.position = CGPointMake(pos.x, pos.y - 5);
    statePosition = statePos;
    sprite.position = pos;
    self.marbleNumber = marbleNumber; //good example of how obj-c handles scoping local hides the instance variable
    
    return self;
}

-(void)updatePosition:(CGPoint)pos aStatePos:(int)statePos{
    statePosition = statePos;
    numberLabel.position = CGPointMake(pos.x, pos.y - 5);
    sprite.position = pos;
}
@end
