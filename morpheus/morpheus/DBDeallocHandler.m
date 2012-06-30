//
//  DBDeallocHandler.m
//  morpheus
//
//  Created by Moskvin Andrey on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBDeallocHandler.h"
@interface DBDeallocHandler ()

@property (nonatomic, copy) DeallocBlock deallocBlock; 
@property (nonatomic, unsafe_unretained) UIView* view;

@end

@implementation DBDeallocHandler
@synthesize deallocBlock = _deallocBlock;
@synthesize view;

+(id)handlerWithDeallocBlock:(DeallocBlock)deallocBlock forView:(UIView *)view
{
    DBDeallocHandler* h = [DBDeallocHandler new];
    h.deallocBlock = deallocBlock;
    h.view = view;
    return h;
}

-(void)dealloc
{
    self.deallocBlock(self.view);
}

@end
