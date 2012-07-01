//
//  DBStylesheet.m
//  morpheus
//
//  Created by Andrey Moskvin on 30.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBStylesheet.h"

@implementation DBStylesheet

@synthesize selector = _selector;
@synthesize properties = _properties;
@synthesize selectorType = _selectorType;

- (id)initForSelector:(NSString*)selector 
         selectorTypes:(enum DBCSSSelectorType)type
            properties:(NSDictionary*)properties;
{
    self = [self init];
    if (self)
    {
        _selector = selector;
        _properties = properties;
    }
    
    return self;
}

+ (id)sheetForSelector:(NSString*)selector 
         selectorTypes:(enum DBCSSSelectorType)type
            properties:(NSDictionary*)properties;
{
    return [[self alloc] initForSelector:selector selectorTypes:type properties:properties];
}

@end
