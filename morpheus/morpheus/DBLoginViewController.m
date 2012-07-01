//
//  DBLoginViewController.m
//  morpheus
//
//  Created by Moskvin Andrey on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBLoginViewController.h"
#import "DBAchievementListViewController.h"
#import "ATMHud.h"

#import "UIView+Repository.h"

@interface DBLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *userNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet DBAchievementListViewController *achievementListController;
@property (strong, nonatomic) ATMHud* hud;

@end

@implementation DBLoginViewController
@synthesize logoView;
@synthesize userNamelabel;
@synthesize passwordLabel;
@synthesize userNameTextField;
@synthesize passwordTextField;
@synthesize loginButton;
@synthesize achievementListController;
@synthesize hud;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hud = [[ATMHud alloc] initWithDelegate:nil];
    [self.view addSubview:self.hud.view];
    
    self.logoView.identifier = @"logo";
    
    [self.userNamelabel addClass:@"input-text"];
    [self.passwordLabel addClass:@"input-text"];
    [self.userNameTextField addClass:@"input-text"];
    [self.passwordTextField addClass:@"input-text"];
    
    [self.userNamelabel addClass:@"input-label"];
    [self.passwordLabel addClass:@"input-label"];
    
    [self.passwordTextField addClass:@"input-field"];
    [self.userNameTextField addClass:@"input-field"];
    
    self.userNamelabel.identifier = @"username-label";
    self.passwordLabel.identifier = @"password-label";
    self.userNameTextField.identifier = @"username-field";
    self.passwordTextField.identifier = @"password-field";
    
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
    [self.hud setCaption:@"Logging in..."];
    [self.hud setActivity:YES];
    [self.hud show];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        [self.hud hide];
        [self.navigationController pushViewController:self.achievementListController animated:YES];
    });
}

@end
