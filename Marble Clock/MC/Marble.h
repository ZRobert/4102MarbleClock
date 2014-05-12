//
//  marble.h
//  MC
//
//  Created by Robert Payne on 11/9/13.
//  Copyright (c) 2013 Robert Payne. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Marble : NSObject{
    SKSpriteNode        *sprite;
    SKLabelNode         *numberLabel;
    int                 marbleNumber;
    int                 statePosition;
    
}
@property(nonatomic, retain)SKSpriteNode *sprite;
@property(nonatomic, retain)SKLabelNode *numberLabel;
@property(nonatomic, assign)int statePosition;
@property(nonatomic, assign)int marbleNumber;

-(id)initWithPosition:(CGPoint)pos aStatePos:(int)statePos marbleNum:(int)marbleNumber;
-(void)updatePosition:(CGPoint)pos aStatePos:(int)statePos;

@end
