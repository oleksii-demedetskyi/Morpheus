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

#pragma mark - Classes

-(NSMutableSet *)classes
{
    NSMutableSet* classNames = objc_getAssociatedObject(self, @"com.morpheus.classes");
    if (classNames == nil)
    {
        classNames = [NSMutableSet set];
        objc_setAssociatedObject(self, @"com.morpheus.classes", classNames, OBJC_ASSOCIATION_RETAIN);
    }
    return classNames;
}

-(void)addClass:(NSString *)className
{
    [self.classes addObject:className];
    [[DBViewRepository sharedRepository] addView:self];
    objc_setAssociatedObject(self, @"com.morpheus.classes", self.classes, OBJC_ASSOCIATION_RETAIN);
}

-(void)removeClass:(NSString *)className
{
    [self.classes removeObject:className];
    [[DBViewRepository sharedRepository] removeView:self fromClass:className];
    objc_setAssociatedObject(self, @"com.morpheus.classes", self.classes, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Identifier

-(void)setIdentifier:(NSString *)identifier
{
    [[DBViewRepository sharedRepository] addView:self];
    objc_setAssociatedObject(self, @"com.morpheus.identifier", identifier, OBJC_ASSOCIATION_RETAIN);
}

-(NSString *)identifier
{
    return objc_getAssociatedObject(self, @"com.morpheus.identifier");
}

#pragma mark - Dealloc Stuff

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
