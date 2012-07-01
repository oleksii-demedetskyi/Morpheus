//
//  DBStyleApplicator.m
//  morpheus
//
//  Created by Andrey Moskvin on 01.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBStyleApplicator.h"
#import "DBStylesheet.h"

@implementation DBStyleApplicator

- (void)applyStyle:(DBStylesheet*)style toView:(UIView*)view;
{
    for (NSString* key in style.properties) 
    {
        id value = [style.properties objectForKey:key];
        [view setValue:value forKeyPath:key];
    }
}

@end
