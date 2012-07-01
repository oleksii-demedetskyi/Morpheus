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

- (NSDictionary*)propertyAliases
{
    static NSDictionary* result;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary* aliases = [NSMutableDictionary dictionary];
        
        [aliases setObject:@"layer.borderColor" forKey:@"border-color"];
        [aliases setObject:@"layer.borderWidth" forKey:@"border-width"];
        [aliases setObject:@"backgroundColor" forKey:@"background-color"];
        [aliases setObject:@"layer.cornerRadius" forKey:@"border-radius"];
        [aliases setObject:@"alpha" forKey:@"opacity"];
        
        result = [aliases copy];
    });
    
    return result;
}

- (NSDictionary*)valueTypes
{
    static NSDictionary* result;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary* types = [NSMutableDictionary dictionary];
        
        [types setObject:@"CGColor" forKey:@"layer.borderColor"];
        [types setObject:@"NSNumber" forKey:@"layer.borderWidth"];
        [types setObject:@"UIColor" forKey:@"backgroundColor"];
        [types setObject:@"NSNumber" forKey:@"layer.cornerRadius"];
        [types setObject:@"NSNumber" forKey:@"alpha"];
        
        result = [types copy];
    });
    
    return result;
}

- (NSDictionary*)methods
{
    static NSDictionary* methods;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary* result = [NSMutableDictionary dictionary];
        
        [result setObject:NSStringFromSelector(@selector(parse_CGColor:)) forKey:@"CGColor"];
        [result setObject:NSStringFromSelector(@selector(parse_UIColor:)) forKey:@"UIColor"];
        [result setObject:NSStringFromSelector(@selector(parse_NSNumber:)) forKey:@"NSNumber"];
        
        methods = [result copy];
    });
    
    return methods;
}

- (UIColor*)parse_CGColor:(NSString*)value
{
    return [self parse_UIColor:value];
}

- (UIColor*)parse_UIColor:(NSString*)value
{
    
}

-(NSNumber*)parse_NSNumber:(NSString*)value
{
    
}

- (void)setSelector:(NSString *)selector
{
    self.sheetSelector = selector;
}

- (void)addProperty:(NSString *)property withValue:(NSString *)value
{
    NSString* alias = [self.propertyAliases objectForKey:property];
    if (alias != nil) 
    {
        property = alias;
    }
    
    NSString* type = [self.valueTypes objectForKey:property];
    if (type != nil)
    {
        NSString* methodName = [self.methods objectForKey:type];
        SEL selector = NSSelectorFromString(methodName);
        value = [self performSelector:selector withObject:value];
    }
    
    // TODO: parse values
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
