//
//  HelpViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 28/11/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "HelpViewController.h"
//#import "RESideMenu.h"


float hgtHeader = 70;


@interface HelpViewController ()

@end

@implementation HelpViewController
@synthesize view_header,lbl_header,btnMenu,btnPush,btnRadius,viewPush,viewRadius;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _arrTableView=[[NSMutableArray alloc]init];
    
    [[AppDelegate getDelegate] changeStatusbarColor];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view bringSubviewToFront:self.view_header];
    
    //[self.view_header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_header"]]];
    
    [self.lbl_header setFont:[UIFont fontWithName:LatoRegular size:18.0]];

    [self.btnMenu addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];

//    [_tableView setBackgroundColor:[UIColor lightGrayColor]];
    
    [self initialSetupDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MyMethods
-(void)initialSetupDidLoad{
    DISPLAY_METHOD_NAME;
    
    _selectedSection = -1;
    
    TEST_MODE;
    //    [self setupUIForRadiusAndPushNotification];
    TEST_MODE;
    [_tableView setSeparatorColor:[UIColor clearColor]];
    
    [self setupUIForTableView];
    
}
-(void)setupUIForTableView{
    [_arrTableView removeAllObjects];
    
    
    
}
-(void)setupUIForRadiusAndPushNotification{
    CGFloat x = [UIScreen mainScreen].bounds.size.width - 160;
    x = x/2;
    
    btnRadius = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRadius.frame = CGRectMake(x, 120, 160, 40);
    [btnRadius setTitle:@"Radius?" forState:UIControlStateNormal];
    [btnRadius setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRadius setBackgroundImage:[UIImage imageNamed:@"btn_greenRound"] forState:UIControlStateNormal];
    //[btnRadius setBackgroundColor:setColor(46, 188, 194)];
    [btnRadius.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnRadius.titleLabel setFont:[UIFont fontWithName:LatoBold size:17.0]];
    [btnRadius addTarget:self action:@selector(showRadiusInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRadius];
    
    frameRadius  = btnRadius.frame;
    
    x = [UIScreen mainScreen].bounds.size.width - 160;
    x = x/2;
    
    btnPush = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPush.frame = CGRectMake(x, 180, 160, 40);
    [btnPush setTitle:@"Push Notification?" forState:UIControlStateNormal];
    [btnPush setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnPush setBackgroundImage:[UIImage imageNamed:@"btn_greenRound"] forState:UIControlStateNormal];
    [btnPush.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnPush.titleLabel setFont:[UIFont fontWithName:LatoBold size:17.0]];
    [btnPush addTarget:self action:@selector(showPushInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPush];
    
    framePush = btnPush.frame;
    
    x = [UIScreen mainScreen].bounds.size.width - 280;
    x = x/2;
    
    viewRadius = [[UIView alloc] initWithFrame:CGRectMake(x, 160, 280, 140)];
    viewRadius.backgroundColor = [UIColor whiteColor];
    UILabel *lblRadius = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 140)];
    //lblRadius.center = CGPointMake(viewRadius.center.x, lblRadius.center.y);
    lblRadius.backgroundColor = [UIColor clearColor];
    lblRadius.textColor = [UIColor grayColor];
    lblRadius.font = [UIFont fontWithName:LatoLight size:13.0];
    lblRadius.textAlignment = NSTextAlignmentCenter;
    lblRadius.lineBreakMode = NSLineBreakByWordWrapping;
    lblRadius.numberOfLines = 0;
    lblRadius.text = [NSString stringWithFormat:@"a.Once someone enters your specified radius he or she will have access to the fest.\n\nb.You have the ability to decide how big or small that radius is.\n\nc.It can start from 50 yards and end up at 50 miles."];
    
    [self.viewRadius addSubview:lblRadius];
    [self.view addSubview:self.viewRadius];
    
    viewPush = [[UIView alloc] initWithFrame:CGRectMake(x, 220, 280, 80)];
    viewPush.backgroundColor = [UIColor whiteColor];
    UILabel *lblPush = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
    lblPush.backgroundColor = [UIColor clearColor];
    lblPush.textColor = [UIColor grayColor];
    lblPush.font = [UIFont fontWithName:LatoLight size:13.0];
    lblPush.textAlignment = NSTextAlignmentCenter;
    lblPush.numberOfLines = 0;
    lblPush.lineBreakMode = NSLineBreakByWordWrapping;
    lblPush.text = [NSString stringWithFormat:@"You have the ability to customize and send a push notification to anyone that is attending your fest. He/she will receive the push notification once he/she has entered the radius."];
    
    [self.viewPush addSubview:lblPush];
    [self.view addSubview:viewPush];
    
    viewRadius.alpha = 0;
    viewPush.alpha = 0;
    
}
-(void)sectionClicked:(UIButton*)btn{
    DISPLAY_METHOD_NAME;
    

    NSInteger prev=_selectedSection;
    
    NSInteger section=btn.tag-100;
    
    if (section==_selectedSection) {
        _selectedSection=-1;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
    }
    
    
    
    
    _selectedSection = section;
    if (_selectedSection==0) {
        
    }
    else if (_selectedSection==1){
        
    }
    else if (_selectedSection==2){
        
    }
    
    
    if (_selectedSection>=0) {
        
        NSMutableIndexSet *set=[[NSMutableIndexSet alloc]init];
        if (prev>=0) {
            [set addIndex:prev];
        }
        if (_selectedSection>=0) {
            [set addIndex:_selectedSection];
        }
        [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];

    }
}
-(float)getBackHeightForCellAtIndexPath:(NSIndexPath*)indx{
    
    float hgt=0;
    
    if (indx.section==0) {
        hgt=100;
    }
    else if (indx.section==1){
        hgt=60;
    }
    else if (indx.section==2){
        hgt=250;
    }
    
    return hgt;
}
#pragma mark - Show Radius Info


-(void)showRadiusInfo
{
    if(!btnRadius.selected)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            framePush.origin.y = 300;
            btnPush.frame = framePush;
            viewPush.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            viewRadius.alpha = 1.0;
        }];
        
        [btnRadius setSelected:YES];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            viewPush.alpha = 0;
            viewRadius.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 animations:^{
                
                framePush.origin.y = 180;
                btnPush.frame = framePush;

            }];
    }];
        
        [btnRadius setSelected:NO];
    }
    
    [btnPush setSelected:NO];
    
}

#pragma mark - Show Push Info
-(void)showPushInfo
{
    if(!btnPush.selected)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            framePush.origin.y = 180;
            btnPush.frame = framePush;
            viewRadius.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            viewPush.alpha = 1.0;
        }];
        
        [btnPush setSelected:YES];

    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            framePush.origin.y = 180;
            btnPush.frame = framePush;
            viewRadius.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            viewPush.alpha = 0.0;
        }];
        
        [btnPush setSelected:NO];
    }
    
    [btnRadius setSelected:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goto_Menu:(id)sender {
}
#pragma mark - TableView Delegates 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section   // custom view for header. will be adjusted to default or specified header height
{
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), CGRectGetHeight(tableView.frame))];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 160, 40);
    
    btn.center=CGPointMake(CGRectGetWidth(tableView.frame)/2.0, hgtHeader/2.0);
    
    NSString *title=@"Find a Fest";
    if (section==0) {
        title=@"Find a Fest";
    }
    else if (section==1){
        title=@"My Fest";
    }
    else if (section==2){
        title=@"Create a Fest";
    }
    
    btn.tag=100+section;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_greenRound"] forState:UIControlStateNormal];
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btn.titleLabel setFont:[UIFont fontWithName:LatoBold size:17.0]];
    [btn addTarget:self action:@selector(sectionClicked:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    
    return v;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section==_selectedSection) {
//        return 1;
//    }

    /*
     •	We do not want any buttons on the Help page, we just want titles and the text below.
     */
    
    return 1;
    
//    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     // very less time ****
     */
    return [self getBackHeightForCellAtIndexPath:indexPath] + 60;
    /*
     // very less time ****
     */
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *ident=@"help cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
        UILabel *lbl=[[UILabel alloc]init];
        lbl.tag=1;
        lbl.font = [UIFont fontWithName:LatoLight size:13.0];
        [lbl setNumberOfLines:0];

        
        [cell.contentView addSubview:lbl];
        
        
        /*
         // very less time ****
         */
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 10, 160, 40);
        //btn.center=CGPointMake(CGRectGetWidth(tableView.frame)/2.0, hgtHeader/2.0);
        btn.tag=2;
//        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[btn setBackgroundImage:[UIImage imageNamed:@"btn_greenRound"] forState:UIControlStateNormal];
        [btn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [btn.titleLabel setFont:[UIFont fontWithName:LatoBold size:17.0]];
//        [btn addTarget:self action:@selector(sectionClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [cell.contentView addSubview:btn];
        /*
         // very less time ****
         */
        
    }
    
    UILabel *lbl=(UILabel*)[cell viewWithTag:1];

    /*
     // very less time ****
     */
    UIButton *btn=(UIButton*)[cell viewWithTag:2];
    NSString *title=@"Find a Fest";
    if (indexPath.section==0) {
        title=@"Find a Fest";
    }
    else if (indexPath.section==1){
        title=@"My Fest";
    }
    else if (indexPath.section==2){
        title=@"Create a Fest";
    }
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:title];
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    [btn setAttributedTitle: titleString forState:UIControlStateNormal];
    
    //[btn setTitle:title forState:UIControlStateNormal];
    /*
     // very less time ****
     */
    
    
    
    float wid=280;
    [lbl setFrame:CGRectMake(CGRectGetWidth(tableView.frame)-wid/2.0, 60, wid, [self getBackHeightForCellAtIndexPath:indexPath])];
    
    if (indexPath.section==0) {
        lbl.text=@"This page displays all of the events that are located within 50 miles of your current location. The sliding bar located at the top of the page allows you to increase or decrease the searching radius, enabling you to find any event within your selected search distance.";
    }
    else if (indexPath.section==1) {
        lbl.text=@"The My Fest page contains all of the Fests that you attended or created, allowing you to relive any past event!";
    }
    else if (indexPath.section==2) {
        lbl.text=@"Radius: \nThe radius aspect found on the Create a Fest page is the area in which other Fest users will be able to post pictures and videos of the event, if a user is not in the selected radius he or she will not be able to post any content, only view it! These pictures and videos will then be broadcasted to other Fest users who are located within 50 miles of the Fest. \n\nPush Notification to Display: \nThis aspect of Fest enables users to create a custom push notification that will be sent to any Fest user at the exact time he or she enters the selected radius. If a custom push notification is not created, a general push notification will display as “Welcome to ‘name of Fest!’”";
    }
//    [lbl sizeToFit];
    
    /*
     // very less time ****
     */
    [lbl setCenter:CGPointMake(CGRectGetWidth(tableView.frame)/2.0, 60 + [self getBackHeightForCellAtIndexPath:indexPath]/2.0)];
    /*
     // very less time ****
     */
    
    
    
//    [lbl setBackgroundColor:RANDOM_COLOR];
    [cell setUserInteractionEnabled:NO];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
