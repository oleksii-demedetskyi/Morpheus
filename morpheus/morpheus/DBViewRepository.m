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

@property (nonatomic, strong) NSMutableDictionary* typeCollection;
@property (nonatomic, strong) NSMutableDictionary* classesCollection;
@property (nonatomic, strong) NSMutableDictionary* identifierCollection;

@end

@implementation DBViewRepository
@synthesize typeCollection;
@synthesize classesCollection;
@synthesize identifierCollection;

+(id)sharedRepository
{
    static DBViewRepository* repository = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        repository = [[DBViewRepository alloc] init];
        repository.typeCollection = [NSMutableDictionary dictionary];
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

#pragma mark - Support methods

-(NSMutableSet *)setOfIdentifierViewsForIdentifier:(NSString *)identifier
{
    NSMutableSet* identifierViews = [self.identifierCollection objectForKey:identifier];
    if (identifierViews == nil)
    {
        identifierViews = [self weakSet];
        [self.identifierCollection setObject:identifierViews forKey:identifier];
    }
    return identifierViews;
}

-(NSMutableSet *)setOfClassViewsForClassName:(NSString *)className
{
    NSMutableSet* classViews = [self.classesCollection objectForKey:className];
    if (classViews == nil) 
    {
        classViews = [self weakSet];
        [self.classesCollection setObject:classViews forKey:className];
    }
    return classViews;
}

-(NSMutableSet *)setOfTypeViewsForClass:(Class) class
{
    NSString *viewClass = NSStringFromClass(class);
    NSMutableSet* typeViews = [self.typeCollection objectForKey:viewClass];
    if(typeViews == nil)
    {
        typeViews = [self weakSet];
        [self.typeCollection setObject:typeViews forKey:viewClass];
    }
    return typeViews;
}

#pragma mark - Swizzling :)

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
    [view.classes enumerateObjectsUsingBlock:^(id obj, BOOL *stop) 
     {
         NSMutableSet* classViews = [self setOfClassViewsForClassName:obj];
         [classViews addObject:view];
     }];
    
    if (view.identifier != nil)
    {
        NSMutableSet* identifierViews = [self setOfIdentifierViewsForIdentifier:view.identifier];
        [identifierViews addObject:view];
    }

    NSMutableSet* classViews = [self setOfTypeViewsForClass:[view class]];
    
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
    NSMutableSet* typeViews = [self setOfTypeViewsForClass:[view class]];
    [typeViews removeObject:view];
    
    [view.classes enumerateObjectsUsingBlock:^(id obj, BOOL *stop) 
    {
        NSMutableSet* classViews = [self setOfClassViewsForClassName:obj];
        [classViews removeObject:view];
    }];
    
    NSMutableSet* identifierViews = [self setOfIdentifierViewsForIdentifier:view.identifier];
    [identifierViews removeObject:view];
}

-(void)removeView:(UIView *)view fromClass:(NSString *)aClass
{
    NSMutableSet* classViews = [self setOfClassViewsForClassName:aClass];
    [classViews removeObject:view];
}

@end
