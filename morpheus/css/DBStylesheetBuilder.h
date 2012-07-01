//
//  DBStylesheetBuilder.h
//  morpheus
//
//  Created by Andrey Moskvin on 30.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBStylesheet.h"

@interface DBStylesheetBuilder : NSObject

- (void)setSelector:(NSString*)selector;
- (void)addProperty:(NSString*)property withValue:(NSString*)value;
- (void)setType:(enum DBCSSSelectorType)selectorType;

- (DBStylesheet*) build;

@end
