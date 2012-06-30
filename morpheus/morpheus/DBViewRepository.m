//
//  DBViewRepository.m
//  morpheus
//
//  Created by Moskvin Andrey on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBViewRepository.h"
#import "DBDeallocHandler.h"
#import "UIView+Repository.h"
#import <objc/runtime.h> 
#import <objc/message.h>

@interface DBViewRepository ()

@property (nonatomic, strong) NSMutableDictionary* viewCollection;

@end

@implementation DBViewRepository
@synthesize viewCollection;

+(id)sharedRepository
{
    static DBViewRepository* repository = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        repository = [[DBViewRepository alloc] init];
        repository.viewCollection = [NSMutableDictionary dictionary];
    });
    return repository;
}

+(void)load
{
    Swizzle([UIView class], @selector(didMoveToSuperview), @selector(myDidMoveToSuperView));
}

-(NSMutableSet*)weakSet
{
    CFSetCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual, CFHash};
    return (__bridge NSMutableSet*)(CFSetCreateMutable(0, 0, &callbacks));
}


-(NSMutableSet *)setOfViewsForClass:(Class) class
{
    NSString *viewClass = NSStringFromClass(class);
    NSMutableSet* classViews = [self.viewCollection objectForKey:viewClass];
    if(classViews == nil)
    {
        classViews = [self weakSet];
        [self.viewCollection setObject:classViews forKey:viewClass];
    }
    return classViews;
}

void Swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

#pragma mark - Add / Remove methods

-(void)addView:(UIView *)view
{
    NSMutableSet* classViews = [self setOfViewsForClass:[view class]];
    
    if (![classViews containsObject:view]) 
    {
        [classViews addObject:view];
        
        [view onDealloc:^(UIView *view) {
            [[DBViewRepository sharedRepository] removeView:view];
        }];
    }    
}

-(void)removeView:(UIView *)view
{
    NSMutableSet* classViews = [self setOfViewsForClass:[view class]];
    [classViews removeObject:view];
}

@end
