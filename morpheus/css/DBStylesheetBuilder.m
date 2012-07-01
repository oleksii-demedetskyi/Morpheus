//
//  DBStylesheetBuilder.m
//  morpheus
//
//  Created by Andrey Moskvin on 30.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBStylesheetBuilder.h"
#import "DBStylesheet.h"

#import "UIColor+SSToolkitAdditions.h"

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
        
        // UIView
        [aliases setObject:@"layer.borderColor" forKey:@"border-color"];
        [aliases setObject:@"layer.borderWidth" forKey:@"border-width"];
        [aliases setObject:@"backgroundColor" forKey:@"background-color"];
        [aliases setObject:@"layer.cornerRadius" forKey:@"border-radius"];
        [aliases setObject:@"alpha" forKey:@"opacity"];
        
        // UILabel
        [aliases setObject:@"textColor" forKey:@"color"];
//        [aliases setObject:@"font" forKey:@"font-size"];
//        [aliases setObject:@"font" forKey:@"font-name"];
        [aliases setObject:@"textAlignment" forKey:@"text-align"];
        [aliases setObject:@"lineBreakMode" forKey:@"line-break-mode"];
        [aliases setObject:@"numberOfLines" forKey:@"number-of-lines"];
        
        // UINavigationBar
        [aliases setObject:@"tintColor" forKey:@"tint-color"];
        
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
        [types setObject:@"NSInteger" forKey:@"layer.borderWidth"];
        [types setObject:@"UIColor" forKey:@"backgroundColor"];
        [types setObject:@"CGFloat" forKey:@"layer.cornerRadius"];
        [types setObject:@"CGFloat" forKey:@"alpha"];
        [types setObject:@"UITextAlignment" forKey:@"textAlignment"];
        [types setObject:@"UILineBreakMode" forKey:@"lineBreakMode"];
        [types setObject:@"NSInteger" forKey:@"number-of-lines"];
        [types setObject:@"UIImage" forKey:@"image"];
        
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
        [result setObject:NSStringFromSelector(@selector(parse_NSInteger:)) forKey:@"NSInteger"];
        [result setObject:NSStringFromSelector(@selector(parse_CGFloat:)) forKey:@"CGFloat"];
        [result setObject:NSStringFromSelector(@selector(parse_UITextAlignment:)) forKey:@"UITextAlignment"];
        [result setObject:NSStringFromSelector(@selector(parse_UILineBreakMode:)) forKey:@"UILineBreakMode"];
        [result setObject:NSStringFromSelector(@selector(parse_UIImage:)) forKey:@"UIImage"];
        
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
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@Color",value]);
    id colorClass = (id)[UIColor class];
    if ([colorClass respondsToSelector:selector])
    {
        return [colorClass performSelector:selector];
    }

    UIColor* color = [UIColor colorWithHex:value];
    NSAssert(color != nil, @"Cannot parse color");
    return color;
}

-(NSNumber*)parse_NSInteger:(NSString*)value
{
    return [NSNumber numberWithInt:[value integerValue]];
}

- (NSNumber *)parse_CGFloat:(NSString *)value
{
    return [NSNumber numberWithFloat:[value floatValue]];
}

-(NSValue *)parse_UITextAlignment:(NSString *)value
{
    if ([value isEqualToString:@"left"]) 
    {
        return [NSNumber numberWithInt:UITextAlignmentLeft];
    }
    else if ([value isEqualToString:@"right"]) 
    {
        return [NSNumber numberWithInt:UITextAlignmentRight];
    }
    else  if ([value isEqualToString:@"center"])
    {
        return [NSNumber numberWithInt:UITextAlignmentCenter];
    }

    NSAssert(NO,@"Wrong value: %@", value);
    return nil;
}

- (NSValue *)parse_UILineBreakMode:(NSString *)value
{
    if ([value isEqualToString:@"word-wrap"])
    {
        return [NSNumber numberWithInt:UILineBreakModeWordWrap];
    }
    else if ([value isEqualToString:@"character-wrap"])
    {
        return [NSNumber numberWithInt:UILineBreakModeCharacterWrap];        
    }
    else if ([value isEqualToString:@"clip"])
    {
        return [NSNumber numberWithInt:UILineBreakModeClip];
    }
    else if ([value isEqualToString:@"head-truncation"])
    {
        return [NSNumber numberWithInt:UILineBreakModeHeadTruncation];        
    }
    else if ([value isEqualToString:@"tail-truncation"])
    {
        return [NSNumber numberWithInt:UILineBreakModeTailTruncation];   
    }
    else if ([value isEqualToString:@"middle-truncation"])
    {
        return [NSNumber numberWithInt:UILineBreakModeMiddleTruncation];
    }    
    
    NSAssert(NO,@"Wrong value: %@", value);
    return nil;
}

- (UIImage *)parse_UIImage:(NSString *)value
{
    return [UIImage imageNamed:value];
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
        NSAssert(selector != NULL,@"Unknown selector");
        value = [self performSelector:selector withObject:value];
    }
    
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
