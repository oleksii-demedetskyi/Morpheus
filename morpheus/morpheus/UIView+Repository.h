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

- (DBDeallocHandler*)onDealloc:(void(^)(UIView* view))deallocHandler;

@end
