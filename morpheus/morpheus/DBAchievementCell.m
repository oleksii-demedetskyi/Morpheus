//
//  DBAchievementCell.m
//  morpheus
//
//  Created by Moskvin Andrey on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBAchievementCell.h"

@interface DBAchievementCell ()

@property (weak, nonatomic) IBOutlet UIView *typeView;

@end

@implementation DBAchievementCell
@synthesize typeView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
