//
//  MarbleQueue.h
//  MarbleClock2
//
//  Created by Bobbi Johnson on 10/28/13.
//  Edited by Robert Payne 10/31/13

//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarbleQueue : NSObject{
    /*The NSMutableArray class declares the programmatic interface to objects that manage a modifiable array of objects.
     This class adds insertion and deletion operations to the basic array-handling behavior inherited from NSArray.*/
    NSMutableArray *array;
}

-(id)dequeue;

//Adds the next element to the end of queue
-(void)enqueue:(id)element;

// Returns the number of elements in the queue
-(NSInteger)count;

// Shows the first element in the queue
-(id)peek;
@end