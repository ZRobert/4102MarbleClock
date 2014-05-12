//
//  MarbleQueue.m
//  MarbleClock2
//
//  Created by Bobbi Johnson on 10/28/2013.
//  Edited by Robert Payne   on 10/31/2013
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MarbleQueue.h"

@implementation MarbleQueue

-(id)init
{
    if ( (self = [super init]) ) {
        array = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(id)dequeue 
{
    if ([array count] > 0) {
        id Marble = [self peek];
        [array removeObjectAtIndex:0];
        return Marble;
    }
    
    return nil;
}

-(void)enqueue:(id)Marble
{
    [array addObject:Marble];
}



-(id)peek 
{
    if ([array count] > 0)
        return [array objectAtIndex:0];
    
    return nil;
}

-(NSInteger)count 
{
    return [array count];
}


@end
