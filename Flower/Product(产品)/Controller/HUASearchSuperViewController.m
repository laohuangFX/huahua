//
//  HUASearchSuperViewController.m
//  Flower
//
//  Created by applewoainiqwe on 16/2/3.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUASearchSuperViewController.h"
#import "EmojiBool.h"

@interface HUASearchSuperViewController ()

@property (nonatomic, strong) UITextField *searchBar;


@end

@implementation HUASearchSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)showSearchNav{
    
    self.navigationItem.leftBarButtonItems = @[];
    self.navigationItem.hidesBackButton =  YES;
    
    self.searchBar.width = hua_scale(300.0);
    self.searchBar.height = hua_scale(22.5);
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismissBlackView)]];
}

- (void)dismissBlackView{
    
    UIView *blackView = [self.view viewWithTag:1001];
    if (blackView == nil) {
        return;
    }
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    [UIView animateWithDuration:0.3 animations:^{
        blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [blackView removeFromSuperview];
    }];
}

#pragma mark - textFiled delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"beginEditing");
    UIView *blackView  = [[UIView alloc]initWithFrame:self.view.bounds];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    blackView.tag = 1001;
    blackView.alpha = 0;
    [self.view addSubview:blackView];
    UITapGestureRecognizer *blackTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissBlackView)];
    [blackView addGestureRecognizer:blackTap];
    [UIView animateWithDuration:0.3 animations:^{
        blackView.alpha = 1;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return ![EmojiBool stringContainsEmoji:string];
}




- (UITextField *)searchBar{
    if (!_searchBar) {
        _searchBar = [UITextField textFieldWithFrame:CGRectZero image:@"search" placeholder:self.searchplaceholder];
        _searchBar.layer.masksToBounds = YES;
        _searchBar.layer.cornerRadius = hua_scale(5);
        _searchBar.backgroundColor = HUAColor(0xeeeeee);
        _searchBar.width = hua_scale(185);
        _searchBar.height = hua_scale(22.5);
        _searchBar.delegate = self;
        _searchBar.returnKeyType = UIReturnKeySearch;
    }
    return _searchBar;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
