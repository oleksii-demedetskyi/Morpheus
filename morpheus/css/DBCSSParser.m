//
//  DBCSSParser.m
//  morpheus
//
//  Created by Andrey Moskvin on 30.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBCSSParser.h"
#import "ParseKit.h"
#import "DBStylesheetBuilder.h"
#import "DBStylesheet.h"

@interface DBCSSParser ()

@property (nonatomic, strong) PKParser* parser;

@property (nonatomic, strong) NSMutableArray* result;


@end

@implementation DBCSSParser

@synthesize parser = _parser;
@synthesize result = _result;

- (id)init
{
    self = [super init];
    if (self) {
        
        NSString* grammarPath = [[NSBundle mainBundle] pathForResource:@"css" ofType:@"grammar"];
        NSString* grammar = [NSString stringWithContentsOfFile:grammarPath 
                                                      encoding:NSUTF8StringEncoding 
                                                         error:nil];
        self.parser = [[PKParserFactory factory] parserFromGrammar:grammar assembler:self];
        
    }
    return self;
}

- (NSArray*)parseStylesheet:(NSString*)stylesheet
{
    self.result = [NSMutableArray array];
        
    [self.parser parse:stylesheet];
    
    NSArray* result = [self.result copy];
    self.result = nil;
    return result;
}

- (DBStylesheetBuilder*)builderFromAssembly:(PKAssembly*)assembly
{
    DBStylesheetBuilder* builder = assembly.target;
    if (builder == nil)
    {
        NSAssert(![assembly isStackEmpty], @"Missed elements: %@",[assembly stack]);
        builder = [DBStylesheetBuilder new];
        assembly.target = builder;
    }
    
    return builder;
}

- (void)parser:(PKParser*)parser didMatchStylesheet:(PKAssembly*)assembly
{
    [assembly pop]; // }
    [assembly pop]; // {
    
    DBStylesheetBuilder* builder = [self builderFromAssembly:assembly];
    assembly.target = nil;
    DBStylesheet* stylesheet = [builder build];
    [self.result addObject:stylesheet];
}

- (void)parser:(PKParser*)parser didMatchSelector:(PKAssembly*)assembly
{
    DBStylesheetBuilder* builder = [self builderFromAssembly:assembly];
    NSString* selector = [[assembly pop] stringValue];
    if (![assembly isStackEmpty])
    {
        NSString* modifier = [[assembly pop] stringValue];
        if ([modifier isEqualToString:@"#"])
        {
            [builder setType:DBCSSSelectorType_Id];
        }
        else if ([modifier isEqualToString:@"."])
        {
            [builder setType:DBCSSSelectorType_Class];
        }
    }
    else 
    {
        [builder setType:DBCSSSelectorType_Type];
    }
    
    [builder setSelector:selector];
}

- (void)parser:(PKParser*)parser didMatchRule:(PKAssembly*)assembly
{
    DBStylesheetBuilder* builder = [self builderFromAssembly:assembly];
    NSAssert([[[assembly pop] stringValue] isEqual:@";"],@"Invalid");
    NSString* value = [[assembly pop] stringValue];
    NSAssert([[[assembly pop] stringValue] isEqual:@":"],@"Invalid");
    NSString* property = [[assembly pop] stringValue];
    
    [builder addProperty:property withValue:value]; 
}

- (void)parser:(PKParser*)parser didMatchProperty:(PKAssembly*)assembly
{
    if ([[assembly stack] count] > 2)
    {
        NSString* suffix = [[assembly pop] stringValue];
        NSString* delimiter = [[assembly pop] stringValue];
        NSString* upperPart = [[assembly pop] stringValue];
        
        NSString* path = [NSString stringWithFormat:@"%@%@%@",upperPart,delimiter,suffix];
        [assembly push:[PKToken tokenWithTokenType:PKTokenTypeAny stringValue:path floatValue:0]];
    }
}

@end
