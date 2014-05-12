//
//  MarlbeStack.h
//  MarbleClock2
//  Created by Patrick Johnson on 11/9/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarbleStack : NSObject{
    
    NSMutableArray*         array; 
}

/* Adds a marble to the top of the stack */
-(void) push:(id)element ; 

/* Removes a marble from the top of the stack */
-(id) pop;

/* Retruns the number of items in stack */
-(NSInteger) count;

/* Displays top element on stack */
-(id)peek;
@end
