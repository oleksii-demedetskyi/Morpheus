//
//  DBAchievementListViewController.m
//  morpheus
//
//  Created by Moskvin Andrey on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBAchievementListViewController.h"
#import "DBAchievementCell.h"

@interface DBAchievementListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *achievementTable;
@property (nonatomic, strong) NSDictionary* achievements;
@property (nonatomic, strong) IBOutlet DBAchievementCell* achievementCell;

@end

@implementation DBAchievementListViewController
@synthesize achievementTable = _achievementTable;
@synthesize achievements = _achievements;
@synthesize achievementCell = _achievementCell;

-(NSDictionary *)achievements
{
    if (_achievements == nil)
    {
        self.achievements = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSArray arrayWithObjects:@"Finished school",nil], @"July 2007", 
                             [NSArray arrayWithObjects:@"Entered university", @"First subjects", @"Meet new friends", nil], @"September 2007",
                             [NSArray arrayWithObjects:@"First exams", @"Big vacations :)", nil], @"January 2008",
                             [NSArray arrayWithObjects:@"3rd place on volleyball competitions", nil], @"February 2008",
                             [NSArray arrayWithObjects:@"Finished 1st course", nil], @"June 2008",
                             [NSArray arrayWithObjects:@"Finished 2nd course", nil],@"June 2009",
                             [NSArray arrayWithObjects:@"Started working", nil], @"February 2011",
                             [NSArray arrayWithObjects:@"Bought car", nil], @"March 2012",
                             nil];
    }
    return _achievements;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton* addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 40);
    [addButton setTitle:@"Add" forState:UIControlStateNormal];
    [addButton addTarget:self 
                  action:@selector(addButtonTouched:)
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    [self.navigationItem setRightBarButtonItem:addItem animated:YES];

    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    titleLabel.text = @"Achievements List";
    self.navigationItem.titleView = titleLabel;
}

- (void)viewDidUnload
{
    [self setAchievementTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)addButtonTouched:(id)sender
{
    //Push detail - add new row
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"AchievementCell";
    
    DBAchievementCell* cell = (DBAchievementCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"DBAchievementCell" owner:self options:nil];
        cell = self.achievementCell; 
        self.achievementCell = nil;
    }

    NSString* key = [[self.achievements allKeys] objectAtIndex:indexPath.section];
    cell.textLabel.text = [[self.achievements objectForKey:key] objectAtIndex:indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* key = [[self.achievements allKeys] objectAtIndex:section];
    return [[self.achievements objectForKey:key] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.achievements allKeys] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.achievements allKeys] objectAtIndex:section];
}

@end
