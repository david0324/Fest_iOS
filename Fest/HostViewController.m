//
//  HostViewController.m
//  Fest
//
//  Created by Mac Mini i7 #1 on 06/10/14.
//  Copyright (c) 2014 Mac Mini i7 #1. All rights reserved.
//

#import "HostViewController.h"
#import "CellHost.h"

@interface HostViewController ()

@end

@implementation HostViewController
@synthesize view_header,lbl_header,btnAddHost,btnSelectAll,tableHost,arrayContacts,dic,isSearch,txtSearch,lblNoresult,viewBottom;

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
    
    [[AppDelegate getDelegate] changeStatusbarColor];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view bringSubviewToFront:self.view_header];
    
    //[self.view_header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_header"]]];
    
    lbl_header.font=[UIFont fontWithName:LatoRegular size:18.0];
    
    self.tableHost=[[UITableView alloc]initWithFrame:CGRectMake(0, 140, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-140)];
    self.tableHost.delegate=self;
    self.tableHost.dataSource=self;
    self.tableHost.backgroundColor=[UIColor whiteColor];
    self.tableHost.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableHost.separatorColor=[UIColor grayColor];
    self.tableHost.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableHost.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableHost.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    [self.view insertSubview:self.tableHost belowSubview:viewBottom];
    
    isSearch = NO;
    
    [txtSearch addTarget:self action:@selector(searchContact:) forControlEvents:UIControlEventEditingChanged];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgSearch = [[UIImageView alloc] initWithFrame:CGRectMake(4, 7, 16, 16)];
    imgSearch.image = [UIImage imageNamed:@"icon_search"];
    [leftView addSubview:imgSearch];
    
    self.txtSearch.leftView = leftView;
    self.txtSearch.leftViewMode = UITextFieldViewModeUnlessEditing;
    self.txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtSearch.placeholder attributes:@{NSForegroundColorAttributeName: COLOR_MAINTINTCOLOR}];
    
    //Label No Result
    self.lblNoresult=[[UILabel alloc]initWithFrame:CGRectMake(20, 114, ([UIScreen mainScreen].bounds.size.width-40), 30)];
    self.lblNoresult.text=@"No results found";
    self.lblNoresult.textAlignment=NSTextAlignmentCenter;
    self.lblNoresult.textColor=[UIColor blackColor];
    self.lblNoresult.font=[UIFont fontWithName:ProximaNovaSemibold size:17.0];
    self.lblNoresult.hidden=YES;
    self.lblNoresult.backgroundColor=[UIColor clearColor];
    [self.view insertSubview:self.lblNoresult aboveSubview:self.tableHost];
    
    self.dic = [NSMutableDictionary new];
    self.arrayContacts = [NSArray arrayWithArray:[GC arrContacts]];
    self.userModel = [[GC arrUserDetails] firstObject];
    [[GC arrHost] removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTableFrame_Host:) name:UIKeyboardDidShowNotification object:nil];
    
    // Sort Array Alphabetically
    NSSortDescriptor *sortDescrip = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *arrSorted = [NSArray new];
    arrSorted = [self.arrayContacts sortedArrayUsingDescriptors:@[sortDescrip]];
    self.arrayContacts = [NSArray arrayWithArray:arrSorted];
    [GC setArrContacts:[NSMutableArray arrayWithArray:self.arrayContacts]];
    
    [self.tableHost reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [txtSearch resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Contacts Delegate
-(void)refreshContactsList
{
    
}

#pragma mark - NSNotification For KeyPad
-(void)changeTableFrame_Host:(NSNotification *)notify
{
    CGRect keyboardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.3];
    
    self.tableHost.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, (self.view.frame.size.height-keyboardFrame.size.height-150));
    
    [UIView commitAnimations];
    
}

#pragma mark - Text Field Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtSearch = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    self.tableHost.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, (self.view.frame.size.height-150));
    
    return YES;
}

#pragma mark - Search Contact
-(void)searchContact:(UITextField *)txt
{
    if ([txt.text isEqualToString:@""])
    {
        isSearch = NO;
        self.lblNoresult.hidden = YES;
        
        self.arrayContacts = [NSArray arrayWithArray:[GC arrContacts]];
    }
    else {
        
        isSearch = YES;
        self.lblNoresult.hidden=YES;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.%@ beginswith[cd] %@ OR SELF.%@ beginswith[cd] %@", @"firstName", txt.text, @"lastName", txt.text];
        
        self.arrayContacts = [[GC arrContacts] filteredArrayUsingPredicate:predicate];
        
        NSMutableArray *tempArray=[NSMutableArray new];
        
        for(long int i=0;i<self.arrayContacts.count;i++)
        {
            Contact *searchedContact=[self.arrayContacts objectAtIndex:i];
            
            searchedContact.name = [[NSMutableAttributedString alloc]init];
            NSMutableAttributedString *strAttr=[[NSMutableAttributedString alloc]initWithString:searchedContact.fullName attributes:@{[UIFont fontWithName:ProximaNovaSemibold size:18.0] : NSFontAttributeName,setColor(23, 160, 177) : NSForegroundColorAttributeName}];
            
            NSString *strFullName = [searchedContact.fullName lowercaseString];
            txt.text=[txt.text lowercaseString];
            
            NSRange txtRange = [strFullName rangeOfString:txt.text];
            [strAttr addAttribute:NSForegroundColorAttributeName value:setColor(83, 217, 204) range:txtRange];
            searchedContact.name = strAttr;
            [tempArray addObject:searchedContact];
        }
        
        NSSortDescriptor *sortFirst = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:NO selector:@selector(caseInsensitiveCompare:)];
        NSSortDescriptor *sortLast = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        
        self.arrayContacts = [tempArray sortedArrayUsingDescriptors:@[sortFirst,sortLast]];
        tempArray=nil;
    }
    
    if(self.arrayContacts.count==0 && (txt.text.length>0 && ![txt.text isEqualToString:@""]))
    {
        isSearch = NO;
        self.lblNoresult.hidden=NO;
    }
    
    [self.tableHost reloadData];
}


#pragma mark - Table View Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayContacts.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellHost *cellHost = [tableView dequeueReusableCellWithIdentifier:CellHost_ID];
    
    if(cellHost == nil)
    {
        cellHost = (CellHost *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellHost_ID];
        cellHost.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    Contact *contact = [self.arrayContacts objectAtIndex:indexPath.row];
    
    UIView* viewbase = (UIView *)[cellHost viewWithTag:10];
    [viewbase removeFromSuperview];
    
    UIView *viewContent = [[UIView alloc] init];
    viewContent.frame = CGRectMake(0, 0, cellHost.bounds.size.width, cellHost.bounds.size.height);
    
    UIImageView *imgViewProfile = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    imgViewProfile.contentMode = UIViewContentModeScaleAspectFill;
    imgViewProfile.clipsToBounds = YES;
    imgViewProfile.layer.cornerRadius = 50/2;
    imgViewProfile.layer.masksToBounds = YES;
    imgViewProfile.layer.borderWidth = 0;
    imgViewProfile.image = contact.image;
    
    UIImageView *_ivProfBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    _ivProfBg.contentMode = UIViewContentModeScaleToFill;

    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(70, 17, (cellHost.bounds.size.width-10-40-10-15-30-20), 24)];
    lblName.font = [UIFont fontWithName:ProximaNovaSemibold size:17.0];
    lblName.textColor = [UIColor blackColor];
    lblName.textAlignment = NSTextAlignmentLeft;
    lblName.numberOfLines = 1;
    lblName.lineBreakMode = NSLineBreakByTruncatingTail;
    
    UIButton *btnselectContact = [UIButton buttonWithType:UIButtonTypeCustom];
    btnselectContact.frame = CGRectMake(0, 0, 320, 320);
    //[btnselectContact setImage:[UIImage imageNamed:@"icon_unselect"] forState:UIControlStateNormal];
    //[btnselectContact setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateSelected];
    [btnselectContact addTarget:self action:@selector(selectIndividualContact:) forControlEvents:UIControlEventTouchUpInside];
    btnselectContact.tag = indexPath.row;
    
    
    if(isSearch)
        lblName.attributedText = contact.name;
    else
        lblName.text = contact.fullName;
    
    NSString *contactName=contact.firstName;
    NSString *contactNumber=contact.phone;
    NSString *namePhoneStr=[NSString stringWithFormat:@"%@_%@",contactName,contactNumber];
    
    if([[dic objectForKey:namePhoneStr] integerValue] == 1)
    {
        [btnselectContact setSelected:YES];
        _ivProfBg.image = [UIImage imageNamed:@"icon_greenMask"];
    }
    else
    {
        [btnselectContact setSelected:NO];
        _ivProfBg.image = [UIImage imageNamed:@"icon_lcircleMask"];
    }
    
    [viewContent addSubview:imgViewProfile];
    [viewContent addSubview:_ivProfBg];
    [viewContent addSubview:lblName];
    [viewContent addSubview:btnselectContact];
    
    
    viewContent.tag = 10;
    [cellHost.contentView addSubview:viewContent];
    
    return cellHost;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - Select & Deselect Individually
-(void)selectIndividualContact:(UIButton *)sender
{
    
    [txtSearch resignFirstResponder];
    self.tableHost.frame = CGRectMake(0, 140, [UIScreen mainScreen].bounds.size.width, (self.view.frame.size.height-140));
    
    self.selectedContact = [self.arrayContacts objectAtIndex:sender.tag];
    
    NSString *contactName=self.selectedContact.firstName;
    NSString *contactNumber=self.selectedContact.phone;
    NSString *namePhoneStr=[NSString stringWithFormat:@"%@_%@",contactName,contactNumber];
    
    if(!sender.selected)
    {
        [sender setSelected:YES];
        
        [dic setObject:@"1" forKey:namePhoneStr];
        
        [[GC arrHost] addObject:self.selectedContact.phone];
        
        if([GC arrHost].count == self.arrayContacts.count)
        {
            [btnSelectAll setSelected:YES];
        }
    }
    else
    {
        [sender setSelected:NO];
        
        [dic removeObjectForKey:namePhoneStr];
        
        [[GC arrHost] removeObject:self.selectedContact.phone];
        
        [btnSelectAll setSelected:NO];
    }
    [self.tableHost reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Select All Contacts
- (IBAction)select_All_Contacts:(id)sender
{
    
    [txtSearch resignFirstResponder];
    self.tableHost.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, (self.view.frame.size.height-150));
    
    
    
    if(!btnSelectAll.selected)
    {
        [[GC arrHost] removeAllObjects];
        
        for (long int i=0; i<self.arrayContacts.count; i++)
        {
            Contact *contact = [self.arrayContacts objectAtIndex:i];
            NSString *contactName=contact.firstName;
            NSString *contactNumber=contact.phone;
            NSString *namePhoneStr=[NSString stringWithFormat:@"%@_%@",contactName,contactNumber];
            
            [dic setObject:@"1" forKey:namePhoneStr];
            self.selectedContact = [self.arrayContacts objectAtIndex:i];
            [[GC arrHost] addObject:self.selectedContact.phone];
        }
        
        [btnSelectAll setSelected:YES];
    }
    else
    {
        for (long int i=0; i<self.arrayContacts.count; i++)
        {
            Contact *contact = [self.arrayContacts objectAtIndex:i];
            NSString *contactName=contact.firstName;
            NSString *contactNumber=contact.phone;
            NSString *namePhoneStr=[NSString stringWithFormat:@"%@_%@",contactName,contactNumber];
            
            [dic setObject:@"0" forKey:namePhoneStr];
        }
        
        [[GC arrHost] removeAllObjects];
        
        [btnSelectAll setSelected:NO];
    }
    [self.tableHost reloadData];
}

#pragma mark - Add Host
- (IBAction)addHost:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Go Back
- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Clear Field & Reload Data
- (IBAction)clearField_Host:(id)sender
{
    isSearch = NO;
    self.lblNoresult.hidden = YES;
    txtSearch.text = @"";
    
    self.arrayContacts = [NSArray arrayWithArray:[GC arrContacts]];
    
    [txtSearch resignFirstResponder];
    self.tableHost.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, (self.view.frame.size.height-150));
    
    [tableHost reloadData];
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
@end
