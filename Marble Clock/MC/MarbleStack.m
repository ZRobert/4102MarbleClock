//
//  MarlbeStack.m
//  MarbleClock2
//
//
//  MarbleStack.m
//  MarbleClock
//
//  Created by Bobbi Johnson on 11/9/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MarbleStack.h"

@implementation MarbleStack

-(id)init
{
    if ( (self = [super init]) ) {
        array = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)push:(id)Marble
{
    [array addObject: Marble];
}


-(id)pop
{
    
    id Marble = [self peek];
    [array removeLastObject];
    return Marble;
    
}

-(NSInteger)count
{
    
    return [array count];
    
}


-(id)peek
{
    return[array lastObject];
    
}

@end
