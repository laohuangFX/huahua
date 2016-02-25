//
//  BCKeyBoard.m
//  BCDemo
//
//  Created by baochao on 15/7/27.
//  Copyright (c) 2015年 baochao. All rights reserved.
//

#import "BCKeyBoard.h"


#import "DXFaceView.h"
#import "BCMoreView.h"


#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)


@interface BCKeyBoard () <UITextViewDelegate,DXFaceDelegate,BCMoreViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong)UIImageView *backgroundImageView;
@property (nonatomic,strong)UIButton *faceBtn;
@property (nonatomic,strong)UIButton *moreBtn;

@property (nonatomic,strong)UIView *faceView;
@property (nonatomic,strong)UIView *moreView;
@property (nonatomic,assign)CGFloat lastHeight;
@property (nonatomic,strong)UIView *activeView;
@end

@implementation BCKeyBoard
- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kBCTextViewHeight)) {
        frame.size.height = kVerticalPadding * 2 + kBCTextViewHeight;
       
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kBCTextViewHeight)) {
        frame.size.height = kVerticalPadding * 2 + kBCTextViewHeight;
    }
    [super setFrame:frame];
}
- (void)createUI
{
    _lastHeight = 30;
    //注册键盘改变是调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView.userInteractionEnabled = YES;
    self.backgroundImageView.backgroundColor = HUAColor(0xf8f8f8);
    //self.backgroundImageView.image = [[UIImage imageNamed:@"messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
    
    //文本
    self.textView = [[BCTextView alloc] initWithFrame:CGRectMake(hua_scale(6),kHorizontalPadding, hua_scale(278), hua_scale(30))];
    self.textView.placeholderColor = self.placeholderColor;
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.scrollEnabled = NO;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    self.textView.layer.borderWidth = 0.65f;
    self.textView.layer.cornerRadius = 6.0f;
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:hua_scale(11)];

    
    //表情按钮
    self.faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.faceBtn.frame = CGRectMake(self.textView.right+hua_scale(3),_backgroundImageView.height/2.0-hua_scale(25.0/2.0), hua_scale(25), hua_scale(25));
    [self.faceBtn addTarget:self action:@selector(willShowFaceView:) forControlEvents:UIControlEventTouchUpInside];
    [self.faceBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
    [self.faceBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [self addSubview:self.faceBtn];
//    [self.faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.right.mas_equalTo(self.backgroundImageView.mas_right).mas_equalTo(hua_scale(6));
//        make.left.mas_equalTo(self.textView.mas_left).mas_equalTo(hua_scale(8));
//        make.centerY.mas_equalTo(self.textView);
//        make.height.mas_equalTo(hua_scale(28));
//    }];
    
    
    
    //更多按钮
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreBtn.hidden = YES;
    self.moreBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame)+kHorizontalPadding,kHorizontalPadding,30,30);
    [self.moreBtn addTarget:self action:@selector(willShowactiveView:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
    [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.textView];
    [self.backgroundImageView addSubview:self.faceBtn];
    [self.backgroundImageView addSubview:self.moreBtn];
    
    if (!self.faceView) {
        self.faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, (kHorizontalPadding * 2 + 30), self.frame.size.width, 200)];
        [(DXFaceView *)self.faceView setDelegate:self];
        self.faceView.backgroundColor = [UIColor whiteColor];
        self.faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
    }
    
    if (!self.moreView) {
        self.moreView = [[BCMoreView alloc] initWithFrame:CGRectMake(0, (kHorizontalPadding * 2 + 30), self.frame.size.width, 200)];
        self.moreView.backgroundColor = [UIColor whiteColor];
        [(BCMoreView *)self.moreView setDelegate:self];
        self.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
}
- (void)changeFrame:(CGFloat)height{
    
    if (height == _lastHeight)
    {
        return;
    }
    else{
        CGFloat changeHeight = height - _lastHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
      
        rect = self.backgroundImageView.frame;
        rect.size.height += changeHeight;
        self.backgroundImageView.frame = rect;
        
        
        [self.textView setContentOffset:CGPointMake(0.0f, (self.textView.contentSize.height - self.textView.frame.size.height) / 2) animated:YES];
        
        CGRect frame = self.textView.frame;
        frame.size.height = height;
        self.textView.frame = frame;
        
        _lastHeight = height;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(returnHeight:)]) {
            [self.delegate returnHeight:height];
        }
    }

}
- (void)setPlaceholder:(NSString *)placeholder
{
    self.textView.label.text = placeholder;
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.textView.placeholderColor = placeholderColor;
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    //键盘弹出后的位置
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    
    //CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    
    void(^animations)() = ^{
   
        self.bottom = endFrame.origin.y-64;
        NSLog(@"%f",self.bottom);
//        CGRect frame = self.frame;
//        frame.origin.y =endFrame.origin.y-(endFrame.size.height/2)+20;
//        NSLog(@"yyyyy%f",endFrame.origin.y);
//        self.frame = frame;
    };
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
    
    [self layoutIfNeeded];
}
#pragma mark 表情View
- (void)willShowFaceView:(UIButton *)btn
{
    

    
    btn.selected = !btn.selected;
    if(btn.selected == YES){
        [self willShowBottomView:self.faceView];
        [self.textView resignFirstResponder];
        if (self.textView.text.length!=0) {
            self.placeholder =@"";
        }
    }else{
        [self willShowBottomView:nil];
        [self.textView becomeFirstResponder];
    }
}

#pragma mark 表更多View
- (void)willShowactiveView:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if(btn.selected == YES){
        [self willShowBottomView:self.moreView];
        [self.textView resignFirstResponder];
        [(BCMoreView *)self.moreView setImageArray:self.imageArray];
    }else{
        [self willShowBottomView:nil];
        [self.textView becomeFirstResponder];
    }
}

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.backgroundImageView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    self.frame = toFrame;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnHeight:)]) {
        [self.delegate returnHeight:toHeight];
    }
}
- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    return ceilf([textView sizeThatFits:textView.frame.size].height);
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self willShowBottomView:nil];
    self.faceBtn.selected = NO;
    self.moreBtn.selected = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:textView.text];
            self.textView.text = @"";
            [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
        }
        return NO;
    }
    return YES;
}
- (void)willShowBottomView:(UIView *)bottomView
{
    if (![self.activeView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self willShowBottomHeight:bottomHeight];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.backgroundImageView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }
        if (self.activeView) {
            [self.activeView removeFromSuperview];
        }
        self.activeView = bottomView;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{

    
    self.textView.label.hidden = YES;
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
}
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSString *chatText = self.textView.text;
    
    if (!isDelete && str.length > 0) {
        self.textView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
    }
    else {
        if (chatText.length >= 2)
        {
            NSString *subStr = [chatText substringFromIndex:chatText.length-2];
            if ([(DXFaceView *)self.faceView stringIsFace:subStr]) {
                self.textView.text = [chatText substringToIndex:chatText.length-2];
                [self textViewDidChange:self.textView];
                return;
            }
        }
        if (chatText.length > 0) {
            self.textView.text = [chatText substringToIndex:chatText.length-1];
        }
    }
    [self textViewDidChange:self.textView];
}
- (void)sendFace
{
    NSString *chatText = self.textView.text;
    if (chatText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:chatText];
            self.textView.text = @"";
            [self changeFrame:ceilf([self.textView sizeThatFits:self.textView.frame.size].height)];
        }
    }
}
- (void)didselectImageView:(NSInteger)index
{
    switch (index) {
        case 0:
            [self createActionSheet];
            break;
        default:
            break;
    }
}
- (void)createActionSheet
{
    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"选取照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从摄像头选取", @"从图片库选择",nil];
    [action showInView:self];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self openCamera];
            break;
        case 1:
            [self openLibary];
            break;
        default:
            break;
    }
}
- (void)openCamera{
    //打开系统相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.currentCtr presentViewController:picker animated:YES completion:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if([self.delegate respondsToSelector:@selector(returnImage:)]){
        [self.delegate returnImage:image];
    }
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self.currentCtr dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.currentCtr dismissViewControllerAnimated:YES completion:nil];
}
- (void)openLibary{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.currentCtr presentViewController:picker animated:YES completion:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}


//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    
    
    if (self.textView.text.length==0) {
        self.textView.label.hidden = NO;
        self.textView.label.text = @"我来说几句";
    }
}

//获取焦点前调用
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if (textView.text.length < 1) {
        textView.text = @"间距";
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = hua_scale(10);// 字体的行间距
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:hua_scale(11)],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    if ([textView.text isEqualToString:@"间距"]) {           //之所以加这个判断是因为再次编辑的时候还会进入这个代理方法，如果不加，会把你之前输入的内容清空。你也可以取消看看效果。
       self.textView.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];//主要是把“间距”两个字给去了。
    }
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token==nil) {
        self.tokenBlock(token);
        return NO;
    }else{
    return YES;
    }
    
}



- (void)releaseView{
    
    self.changeBlock();
    self.faceBtn.selected = NO;
    self.textView.label.hidden = NO;
    self.placeholder=@"我来说几句";
}
@end
