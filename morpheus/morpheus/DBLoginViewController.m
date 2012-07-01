//
//  DBLoginViewController.m
//  morpheus
//
//  Created by Moskvin Andrey on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBLoginViewController.h"
#import "DBAchievementListViewController.h"

@interface DBLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *userNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet DBAchievementListViewController *achievementListController;

@end

@implementation DBLoginViewController
@synthesize logoView;
@synthesize userNamelabel;
@synthesize passwordLabel;
@synthesize userNameTextField;
@synthesize passwordTextField;
@synthesize loginButton;
@synthesize achievementListController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setLogoView:nil];
    [self setUserNamelabel:nil];
    [self setPasswordLabel:nil];
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [self setLoginButton:nil];
    [self setAchievementListController:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)loginButtonTouched:(id)sender 
{
    [self.navigationController pushViewController:self.achievementListController animated:YES];
}

@end
