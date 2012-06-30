//
//  UIView+Repository.h
//  morpheus
//
//  Created by Moskvin Andrey on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBDeallocHandler;
@interface UIView (Repository)

@property(nonatomic, strong) NSString* identifier;
@property(nonatomic, readonly) NSMutableSet* classes;

- (void)addClass:(NSString *)className;
- (void)removeClass:(NSString *)className;
- (DBDeallocHandler*)onDealloc:(void(^)(UIView* view))deallocHandler;

@end
