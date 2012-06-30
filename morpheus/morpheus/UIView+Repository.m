//
//  UIView+Repository.m
//  morpheus
//
//  Created by Moskvin Andrey on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+Repository.h"
#import "DBDeallocHandler.h"
#import "DBViewRepository.h"
#import <objc/runtime.h>

@implementation UIView (Repository)

-(NSMutableSet *)deallocHandlers
{
    NSMutableSet* handlers = objc_getAssociatedObject(self, @"com.morpheus.deallochandlers");
    if (handlers == nil)
    {
        handlers = [NSMutableSet set];
        objc_setAssociatedObject(self, @"com.morpheus.deallochandlers", handlers, OBJC_ASSOCIATION_RETAIN);
    }
    return handlers;
}

-(void)addDeallocHandler:(DBDeallocHandler *)handler
{
    [self.deallocHandlers addObject:handler];
}

-(DBDeallocHandler *)onDealloc:(void (^)(UIView *))deallocHandler
{
    DBDeallocHandler* h = [DBDeallocHandler handlerWithDeallocBlock:deallocHandler forView:self];
    [self addDeallocHandler:h];
    return h;
}

-(void)myDidMoveToSuperView
{
    [self myDidMoveToSuperView];
    [[DBViewRepository sharedRepository] addView:self];
}

@end
