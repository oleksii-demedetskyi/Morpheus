//
//  DBStylesheetBuilder.m
//  morpheus
//
//  Created by Andrey Moskvin on 30.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBStylesheetBuilder.h"
#import "DBStylesheet.h"

@interface DBStylesheetBuilder ()<NSCopying>

@property (nonatomic, strong) NSString* sheetSelector;
@property (nonatomic, assign) enum DBCSSSelectorType type;
@property (nonatomic, strong) NSMutableDictionary* properties;

@end

@implementation DBStylesheetBuilder

@synthesize properties = _properties;
@synthesize sheetSelector = _sheetSelector;
@synthesize type = _type;

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.properties = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setSelector:(NSString *)selector
{
    self.sheetSelector = selector;
}

- (void)addProperty:(NSString *)property withValue:(NSString *)value
{
    [self.properties setObject:value forKey:property];
}

- (DBStylesheet*) build;
{
    NSParameterAssert(self.type != DBCSSSelectorType_Unknown);
    NSParameterAssert(self.sheetSelector != nil);
    
    return [DBStylesheet sheetForSelector:self.sheetSelector 
                            selectorTypes:self.type 
                               properties:self.properties];
}
@end
