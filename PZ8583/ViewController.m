//
//  ViewController.m
//  PZ8583
//
//  Created by mark zheng on 15/7/17.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "ViewController.h"
#import "PZTransService.h"

#import "UIViewExt.h"

@interface ViewController ()

@property (nonatomic,strong) UITextView     *logView;

@property (nonatomic,strong) PZTransService *serviceCenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"POS模拟操作";
    [self customView];
    
    self.serviceCenter = [PZTransService instance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customView {
    self.logView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 100)];
    self.logView.scrollEnabled = YES;
    self.logView.editable = NO;
    [self.view addSubview:self.logView];
    
    UIToolbar   *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.height-100, self.view.width, 100)];
    UIBarButtonItem *fixedspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    fixedspace.width = 0.1f;
    
    UIBarButtonItem *toolbar = [[UIBarButtonItem alloc] initWithCustomView:[self customToolbarWithFrame:toolBar.frame]];
    
    NSArray *arrayItems = @[fixedspace,toolbar,fixedspace];
    [toolBar setItems:arrayItems animated:YES];
    
    [self.view addSubview:toolBar];
}

- (UIView *)customToolbarWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    CGFloat  buttonHeight = view.height/3.0;
    CGFloat  buttonWidth = view.width/3.0;
    
    UIButton    *SignToPosp = [UIButton buttonWithType:UIButtonTypeCustom];
    SignToPosp.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    SignToPosp.backgroundColor = [UIColor lightGrayColor];
    [SignToPosp setTitle:@"  签到"  forState:UIControlStateNormal] ;
    [SignToPosp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SignToPosp setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [SignToPosp addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:SignToPosp];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake( buttonWidth, 0, 1, buttonHeight)];
    line.backgroundColor = [UIColor colorWithWhite:197.0/255.0 alpha:0.75];
    [view addSubview:line];
    
    UIButton    *ConsumeToPosp = [UIButton buttonWithType:UIButtonTypeCustom];
    ConsumeToPosp.frame = CGRectMake(buttonWidth, 0, buttonWidth, buttonHeight);
    ConsumeToPosp.backgroundColor = [UIColor lightGrayColor];
    [ConsumeToPosp setTitle:@"  消费"  forState:UIControlStateNormal] ;
    [ConsumeToPosp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ConsumeToPosp setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [ConsumeToPosp addTarget:self action:@selector(consume:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:ConsumeToPosp];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake( buttonWidth*2, 0, 1, buttonHeight)];
    line1.backgroundColor = [UIColor colorWithWhite:197.0/255.0 alpha:0.75];
    [view addSubview:line1];
    
    UIButton    *BalanceToPosp = [UIButton buttonWithType:UIButtonTypeCustom];
    BalanceToPosp.frame = CGRectMake(buttonWidth*2, 0, buttonWidth, buttonHeight);
    BalanceToPosp.backgroundColor = [UIColor lightGrayColor];
    [BalanceToPosp setTitle:@"  余额查询"  forState:UIControlStateNormal] ;
    [BalanceToPosp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [BalanceToPosp setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [BalanceToPosp addTarget:self action:@selector(balance:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:BalanceToPosp];
    
    //--------------------------------------------------------------------------------
    
    UIButton    *DownPosKeyToPosp = [UIButton buttonWithType:UIButtonTypeCustom];
    DownPosKeyToPosp.frame = CGRectMake(0, buttonHeight, buttonWidth, buttonHeight);
    DownPosKeyToPosp.backgroundColor = [UIColor lightGrayColor];
    [DownPosKeyToPosp setTitle:@"  下载公钥"  forState:UIControlStateNormal] ;
    [DownPosKeyToPosp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [DownPosKeyToPosp setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [DownPosKeyToPosp addTarget:self action:@selector(getPosKey:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:DownPosKeyToPosp];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake( buttonWidth, buttonHeight, 1, buttonHeight)];
    line2.backgroundColor = [UIColor colorWithWhite:197.0/255.0 alpha:0.75];
    [view addSubview:line2];
    
    UIButton    *DownMaterKeyToPosp = [UIButton buttonWithType:UIButtonTypeCustom];
    DownMaterKeyToPosp.frame = CGRectMake(buttonWidth, buttonHeight, buttonWidth, buttonHeight);
    DownMaterKeyToPosp.backgroundColor = [UIColor lightGrayColor];
    [DownMaterKeyToPosp setTitle:@"  下载密钥"  forState:UIControlStateNormal] ;
    [DownMaterKeyToPosp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [DownMaterKeyToPosp setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [DownMaterKeyToPosp addTarget:self action:@selector(getMasterKey:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:DownMaterKeyToPosp];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake( buttonWidth*2, buttonHeight, 1, buttonHeight)];
    line3.backgroundColor = [UIColor colorWithWhite:197.0/255.0 alpha:0.75];
    [view addSubview:line3];
    
    UIButton    *OtherToPosp = [UIButton buttonWithType:UIButtonTypeCustom];
    OtherToPosp.frame = CGRectMake(buttonWidth*2, buttonHeight, buttonWidth, buttonHeight);
    OtherToPosp.backgroundColor = [UIColor lightGrayColor];
    [OtherToPosp setTitle:@"  消费冲正"  forState:UIControlStateNormal] ;
    [OtherToPosp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [OtherToPosp setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [OtherToPosp addTarget:self action:@selector(reverseTrans:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:OtherToPosp];
    
    UIButton    *getMacToPosp = [UIButton buttonWithType:UIButtonTypeCustom];
    getMacToPosp.frame = CGRectMake(0, buttonHeight*2, buttonWidth, buttonHeight);
    getMacToPosp.backgroundColor = [UIColor lightGrayColor];
    [getMacToPosp setTitle:@"  获取"  forState:UIControlStateNormal] ;
    [getMacToPosp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getMacToPosp setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [getMacToPosp addTarget:self action:@selector(getPosMac:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:getMacToPosp];
    
    UIButton    *UploadSignToPosp = [UIButton buttonWithType:UIButtonTypeCustom];
    UploadSignToPosp.frame = CGRectMake(buttonWidth, buttonHeight*2, buttonWidth, buttonHeight);
    UploadSignToPosp.backgroundColor = [UIColor lightGrayColor];
    [UploadSignToPosp setTitle:@"  上传"  forState:UIControlStateNormal] ;
    [UploadSignToPosp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [UploadSignToPosp setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [UploadSignToPosp addTarget:self action:@selector(uploadSignImage:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:UploadSignToPosp];
    
    UIButton    *testOther = [UIButton buttonWithType:UIButtonTypeCustom];
    testOther.frame = CGRectMake(buttonWidth*2, buttonHeight*2, buttonWidth, buttonHeight);
    testOther.backgroundColor = [UIColor lightGrayColor];
    [testOther setTitle:@"  测试"  forState:UIControlStateNormal] ;
    [testOther setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [testOther setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [testOther addTarget:self action:@selector(testOther:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:testOther];
    
    return view;
}

/*!
 *  签到
 *
 *  @param sender
 */
- (IBAction)signUp:(id)sender {
    [self.serviceCenter mposGetWorkKeyFromServerWithBlock:^(NSString *text){
        [self displayLog:text];
    }];
}

//消费
- (IBAction)consume:(id)sender {
    [self.serviceCenter mposPurchaseFromServerWithBlock:^(NSString *text){
        [self displayLog:text];
    }];
}

//消费冲正
- (void)reverseTrans:(id)sender {
    [self.serviceCenter mposReverseFromServerWithBlock:^(NSString *text){
        [self displayLog:text];
    }];
}

/*!
 *  余额查询
 *
 *  @param sender
 */
- (IBAction)balance:(id)sender {
    [self.serviceCenter mposBalanceFromServerWithBlock:^(NSString *text){
        [self displayLog:text];
    }];
}

/*!
 *  获取终端参数
 *
 *  @param sender
 */
-(IBAction)getTerminalPara :(id)sender{
    
}

- (void)getPosKey:(id)sender {
    //
}

- (void)getMasterKey:(id)sender {
    //
}

- (void)getPosMac:(id)sender {
    //
}

- (void)uploadSignImage:(id)sender {
    //
}

- (void)testOther:(id)sender {
    //
}

-(void)displayLog:(NSString*)log{
    NSLog(@"%@",log);
    NSString* oldLog = [[self logView] text];
    NSMutableString* nowLog = [[NSMutableString alloc] initWithString:oldLog];
    [nowLog appendString:@"\n"];
    [nowLog appendString:log];
    self.logView.text = nowLog;
    [self.logView scrollRangeToVisible:NSMakeRange(self.logView.text.length, 1)];
}

@end
