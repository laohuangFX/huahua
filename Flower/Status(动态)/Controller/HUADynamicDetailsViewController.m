//
//  HUADynamicDetailsViewController.m
//  Flower
//
//  Created by apple on 16/1/9.
//  Copyright © 2016年 readchen.com. All rights reserved.
//

#import "HUADynamicDetailsViewController.h"
#import "HUAWeiXinPhotoContainerView.h"
#import "HUAcommentsTableViewCell.h"
#import "HUDynamicATableViewCell.h"
#import "EMMallSectionView.h"
#import "HUALoginController.h"
#import "HUAmodel.h"


#define Scw [UIScreen mainScreen].bounds.size.width
#define Sch [UIScreen mainScreen].bounds.size.height

@interface HUADynamicDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,BCKeyBoardDelegate,UIGestureRecognizerDelegate>{
    //用来存放回复的用户名
    NSString *_nikeName;
    //评论的id
    NSString *_parent_id;
    //存放父级id
    NSString *_parent_user_id;
    //类型
    NSString *_type;
    
    UIView *_endView;
    
    //记录第几行
    NSIndexPath *_indexPath;
}

@property(nonatomic,strong)UITableView *tableView;


@property (nonatomic, strong)BCKeyBoard *keyBoard;

//评论label
@property (nonatomic, strong)UILabel *commentLabel;


@property (nonatomic, strong)NSMutableArray *pinlunArray;

//记录当前是第几行Cell；
@property (nonatomic, assign)NSInteger cellIndex;

//记录当前cell的button在第几行
@property (nonatomic, strong)UIButton *tagButton;

@property (nonatomic,retain)NSMutableDictionary *dongtaiDic;

@property (nonatomic,assign)NSString *page;
@end

@implementation HUADynamicDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"动态详情";
    self.view.backgroundColor = [UIColor whiteColor];
    //设置返回按钮图片的颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
 
    
    [self getData:NO];
    
    //自定义表视图
    [self initTbaleView];
    
    //自定义键盘
    [self initKeyBoard];
    
   
    
}
- (void)initTbaleView{
    
    //表视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, Scw, screenHeight-44-20-hua_scale(46)) style:UITableViewStylePlain];
    //self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

//自定义键盘
- (void)initKeyBoard{
    
    NSArray *array = @[@"chatBar_colorMore_photoSelected",@"chatBar_colorMore_audioCall",@"chatBar_colorMore_location",@"chatBar_colorMore_video.png",@"chatBar_colorMore_video.png",@"chatBar_colorMore_video.png"];
    self.keyBoard = [[BCKeyBoard alloc] initWithFrame:CGRectMake(0,self.view.bottom-64-hua_scale(46), [UIScreen mainScreen].bounds.size.width,hua_scale(46))];
    self.keyBoard.delegate = self;
    self.keyBoard.imageArray = array;
    self.keyBoard.placeholder = @"我来说几句";
    self.keyBoard.currentCtr = self;
    self.keyBoard.placeholderColor = [UIColor colorWithRed:133/255 green:133/255 blue:133/255 alpha:0.5];
    
    //self.keyBoard.backgroundColor = [UIColor redColor];
    
    __block typeof(self) mySelf = self;
    [self.keyBoard setTokenBlock:^(NSString *token) {
        
        //判断是否是游客评论，
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆" message:@"游客模式下不能评论,请先登陆!" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            window.rootViewController= [[HUALoginController alloc] init];
            [mySelf.navigationController pushViewController:[HUALoginController new] animated:YES];
            [alert removeFromParentViewController];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [alert removeFromParentViewController];
        }]];
        [mySelf presentViewController:alert animated:YES completion:nil];
    }];
    //表情发送后改变位置
    [self.keyBoard setChangeBlock:^{
        
        [UIView animateWithDuration:0.5 animations:^{
            mySelf.keyBoard.y = self.view.bottom-64-46;
            
        }];
    }];
    
    [self.view addSubview:self.keyBoard];
    
    //创建点击结束编辑视图
    _endView = [UIView new];
    _endView.backgroundColor = [UIColor clearColor];
    _endView.hidden = YES;
    [self.tableView addSubview:_endView];
    [self.keyBoard updateLayout];
    [_endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.keyBoard.mas_top);
        make.left.right.mas_equalTo(self.view);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView)];
    [_endView addGestureRecognizer:tap];
}

//获取数据
- (void)getData:(BOOL)type{
    
    //    //获取当前用户名
    HUAUserDetailInfo *detailInfo = [HUAUserDefaults getUserDetailInfo];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = [HUA_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"essay/essay_detail?essay_id=%@&user_id=%@",self.essay_id,detailInfo.user_id]];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
 
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
          
            self.statusModel.praise = dic[@"info"][@"praise_count"];
            self.statusModel.is_praise = dic[@"info"][@"have_praised"];
            self.pinlunArray = [HUADataTool DynamicDetails:dic];


            for (HUAmodel *model in self.pinlunArray) {

                for (NSDictionary *dic in model.commentArray) {

                    [self.dongtaiDic setValue:dic[@"nickname"] forKey:dic[@"user_id"]];

                }
                [self.dongtaiDic setValue:model.name forKey:model.user_id];

                model.nameDic = self.dongtaiDic;
            }
            if (type==NO) {
                [self.tableView reloadData];
            }else{

                if (_indexPath ==nil ||_indexPath.row == 0 ) {

                    [self.tableView reloadData];

                }else{

                    [self.tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:0];
                }

                //清空
                _indexPath = nil;
            }

        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUALog(@"%@",error);
    }];
      
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //return 3;
    
    return self.pinlunArray.count+2;
    //return self.modell.commentArray.count+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //回复cell
    if (indexPath.row == 0) {
        
        static NSString *identifier = @"CELL";
        
        HUDynamicATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            
            cell = [[HUDynamicATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
           __weak typeof(self) weakSelf = self;


        //点赞
        [cell setLoveBlock:^{
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            //判断是否是游客模式
            if (token==nil) {
                //判断是否是游客评论，
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆" message:@"游客模式下不能点赞,请先登陆!" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [weakSelf.navigationController pushViewController:[HUALoginController new] animated:YES];
                    [alert removeFromParentViewController];
                    
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [alert removeFromParentViewController];
                }]];
                
                [self presentViewController:alert animated:YES completion:nil];
                return ;
            }
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            //申明返回的结果是json类型
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            //申明请求的数据是json类型
            manager.requestSerializer=[AFJSONRequestSerializer serializer];
            //如果报接受类型不一致请替换一致text/html或别的
            //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
            //传入的参数
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
            NSDictionary *parameters = @{@"target":@"essay",@"id":self.statusModel.essay_id};
            //你的接口地址
            
            NSString *url= [HUA_URL stringByAppendingPathComponent:@"user/praise"];
            //发送请求
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                [self getData:NO];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            
        }];
        
        cell.model = self.statusModel;
        cell.boolType = YES;
        //评论
        [cell setPinlunBlock:^{
            _endView.hidden = NO;
            self.keyBoard.placeholder =@"我来说几句";
            [self.keyBoard.textView becomeFirstResponder];
            self.cellIndex = indexPath.row;
        }];
        //点击图片退出编辑
        [cell.picContainerView setEndEdit:^{
            
            [self.view endEditing:YES];
        }];
        
        return cell;
        
    }else if (indexPath.row == 1){
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:[HUAWeiXinPhotoContainerView initCommentsView]];
        
        return cell;
        
    }else{
        
        static NSString *identifierCell = @"commentsCell";
        
        HUAcommentsTableViewCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (commentsCell == nil) {
            commentsCell = [[HUAcommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
        }
        
        //commentsCell.modelDic = self.dongtaiDic;
        
        commentsCell.indexPath = indexPath;
        
        commentsCell.moreButton.tag = 666+indexPath.row;
        
        self.tagButton = commentsCell.moreButton;
        
        commentsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        
        commentsCell.modell = self.pinlunArray[indexPath.row-2];
        
        __weak typeof(self) weakSelf = self;
        //不能回复自己的提醒
        if (!commentsCell.commentLabelBlock) {
            [commentsCell setUser_idSameBlock:^{
                
                [HUAMBProgress MBProgressFromView:weakSelf.view wrongLabelText:@"不能评论自己的回复"];
            }];
        }
        
        //点击显示全部按钮的回调block
        if (!commentsCell.moreButtonClickedBlock) {
            [commentsCell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
                HUAmodel *model = weakSelf.pinlunArray[indexPath.row-2];
                model.isOpening = !model.isOpening;
                NSLog(@"%i",model.isOpening);
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        }
        
        
        //点击lable的回掉block
        if (!commentsCell.commentLabelBlock) {
            [commentsCell setCommentLabelBlock:^(NSString *nickName,NSString *parent_id,NSString *type,NSString *parent_user_id,UILabel *commentLable,NSIndexPath *indexPath) {
                _indexPath = indexPath;
                _endView.hidden = NO;
                self.keyBoard.placeholder = [NSString stringWithFormat:@"回复:%@",nickName];
                
                [self.keyBoard.textView becomeFirstResponder];
                
                _nikeName = nickName;
                //要回复的父级user_id
                _parent_user_id = parent_user_id;
                //要回复的第几条评论
                _parent_id = parent_id;
                _type = @"3";
                
                self.cellIndex = indexPath.row;
            }];
        }
        
        
        return commentsCell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

//tableView点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;

    if (indexPath.row==0) {
        self.keyBoard.placeholder =@"我来说几句";
        [self.keyBoard.textView becomeFirstResponder];
        self.cellIndex = indexPath.row;
        
    }else if (indexPath.row ==1){
        return;
    }else{
        self.keyBoard.placeholder =@"我来说几句";
        [self.keyBoard.textView becomeFirstResponder];
        self.cellIndex = indexPath.row;
        
        HUAmodel *model = self.pinlunArray[indexPath.row-2];
        NSLog(@"%@",model);
        
        _parent_user_id = model.user_id;
        _parent_id = model.comment_id;
        _type = @"2";
    }
    
    _endView.hidden = NO;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return [self.tableView cellHeightForIndexPath:indexPath model:self.statusModel keyPath:@"model" cellClass:[HUDynamicATableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
        
    }else if (indexPath.row == 1){
        
        return hua_scale(12);
        
    }else{
        return [self.tableView cellHeightForIndexPath:indexPath model:self.pinlunArray[indexPath.row-2] keyPath:@"modell" cellClass:[HUAcommentsTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    }
}


//记录上一次cell的行
int cellRow = 000;
- (void)didSendText:(NSString *)text
{
    //获取当前用户名
    HUAUserDetailInfo *detailInfo = [HUAUserDefaults getUserDetailInfo];
    
    //清除上一次的cell的高
    [self.tableView.cellAutoHeightManager clearHeightCache];
    
    
    if (text.length == 0) {
        //清空内容
        _nikeName = nil;
        _parent_user_id = nil;
        _parent_id = nil;
        _type = nil;
        self.cellIndex = 0;
        [self.view endEditing:YES];
        return;
    }else{
        if (self.cellIndex == 0) {
            _type = @"1";
            _parent_id = @"0";
            _parent_user_id = @"0";
        }
        
        //判断内容是否全部是空格
        if ([self isEmpty:text]==YES) {
            //清空内容
            _nikeName = nil;
            _parent_user_id = nil;
            _parent_id = nil;
            _type = nil;
            self.cellIndex = 0;
            
            [self.view endEditing:YES];
            self.keyBoard.textView.label.hidden = NO;
            [HUAMBProgress MBProgressFromView:self.view wrongLabelText:@"内容不允许全部为空格"];
            return;
            
        }
    
        NSString *token = [HUAUserDefaults getToken];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //        //申明请求的数据是json类型
        //        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        //        //如果报接受类型不一致请替换一致text/html或别的
        //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *parameters = @{@"user_id":detailInfo.user_id,@"essay_id":self.essay_id,@"shop_id":@"23",@"parent_id":_parent_id,@"content":text,@"type":_type,@"parent_user_id":_parent_user_id};
        //你的接口地址
        
        NSString *url=[HUA_URL stringByAppendingPathComponent:@"essay/essay_comment_create"];
        //发送请求
        NSLog(@"%@",parameters);
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
               NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSLog(@"JSON: %@", dic);
            
            if (_indexPath.row == 0) {
                
                [self.pinlunArray addObject:[HUAmodel jsonData:dic]];
                NSMutableArray *array = [NSMutableArray array];
                HUAmodel *model = self.pinlunArray.lastObject;
                model.commentArray = array;
    
                [self.tableView reloadData];
                
            }else {
            
                HUAmodel *model = self.pinlunArray[_indexPath.row-2];
                [model.commentArray addObject:dic[@"info"]];
                [self.tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:0];
            }
            
            [HUAMBProgress MBProgressFromWindowWithLabelText:@"发表成功!"];
             _indexPath = nil;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

        
        //清空内容
        _nikeName = nil;
        _parent_user_id = nil;
        _parent_id = nil;
        _type = nil;
        self.cellIndex = 0;
       
    }
    
    //记录上一次行
    cellRow = self.cellIndex;
    [self.view endEditing:YES];
    NSLog(@"%@",text);
}
- (void)returnHeight:(CGFloat)height
{
    NSLog(@"%f",height);
}
- (void)returnImage:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageView.image = image;
    [self.view addSubview:imageView];
}

////评论的数组的懒加载
- (NSMutableArray *)pinlunArray{
    if (!_pinlunArray) {
        _pinlunArray=[NSMutableArray array];
    }
    return _pinlunArray ;
}

- (NSMutableDictionary *)dongtaiDic{
    if (!_dongtaiDic ) {
        _dongtaiDic = [NSMutableDictionary dictionary];
        
    }
    return _dongtaiDic;
}
//点击手势，失去第一响应
- (void)cancelView{
    
    [self.view endEditing:YES];
    _endView.hidden = YES;
}

//判断内容是否全部为空格  yes 全部为空格  no 不是
- (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}


@end
