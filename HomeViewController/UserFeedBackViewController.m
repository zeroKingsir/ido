//
//  UserFeedBackViewController.m
//  IDo
//
//  Created by G.Z on 16/3/29.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "UserFeedBackViewController.h"
#import "PlaceholderTextView.h"
#import "PhotoCollectionViewCell.h"
#import "OrderContentTableViewCell.h"
#import "SendOrderDetailViewController.h"

#import "HJCActionSheet.h"
#define kTextBorderColor  RGBCOLOR(227,224,216)
#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define  Image(png) [UIImage imageNamed:png]


static UserFeedBackViewController *UserDetails = nil;

@interface UserFeedBackViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UILabel * lbRight;
}

@property (nonatomic, strong) PlaceholderTextView * textView;

@property (nonatomic, strong) UIButton * sendButton;

@property (nonatomic, strong) UIView * aView;

@property (nonatomic, strong)UICollectionView *collectionV;
//上传图片的个数
@property (nonatomic, strong)NSMutableArray *photoArrayM;
//上传图片的button
@property (nonatomic, strong)UIButton *photoBtn;
//回收键盘
@property (nonatomic, strong)UITextField *textField;

//字数的限制
@property (nonatomic, strong)UILabel *wordCountLabel;

//存放上拉菜单标题的数据源 <拍照 VS 从相册选取>
@property (nonatomic, strong) NSMutableArray * listArray;

@end

@implementation UserFeedBackViewController

+ (UserFeedBackViewController *)SingelUser{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        UserDetails = [[self alloc]init];
        
    });
    return UserDetails;
}

#if 1
/** 懒加载 */
- (NSMutableArray *)listArray {
    
    if (!_listArray) {
        
        _listArray = [[NSMutableArray alloc] initWithObjects:@"拍照",@"从相册选择", nil];
    }
    return _listArray;
}


- (void)btnClicked{
    
    NSString *aler = [NSString stringWithFormat:@"亲 , 您还可上传%ld张图片",(unsigned long)(3 - _photoArrayM.count)];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:aler message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 弹框上的取消按钮
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // 点击按钮之后 要实现的方法
    }];
    
    for (int i = 0; i < self.listArray.count; i++) {
        // 普通按钮的创建
        UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:self.listArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 点击按钮要做的事情
            [self keyWordFromIndex:i];
            
        }];
        
        [alertController addAction:defaultAction];
    }
    
    // 添加取消按钮
    [alertController addAction:cancelAction];
    
    // 弹出弹框视图
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

//照片选择的点击事件
- (void)keyWordFromIndex:(NSInteger)index {
    
    if (index == 0) {//调用相机
        
        UIImagePickerController * ip=[[UIImagePickerController alloc]init];
        
        ip.delegate=self;
        
        BOOL isOpen=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        
        if (isOpen)
        {
            //设备是否支持相机  UIImagePickerControllerSourceTypeCamera 打开相机
            ip.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
        [self presentViewController:ip animated:YES completion:nil];
        
    }
    
    else if (index == 1){//调用相册
        
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        
        picker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        
        picker.allowsEditing=YES;
        
        picker.delegate=self;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#endif

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createLeftAndRightBtn];
    
    self.view.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0f];
    self.aView = [[UIView alloc]init];
    _aView.backgroundColor = [UIColor whiteColor];
    _aView.frame = CGRectMake(20, 84, self.view.frame.size.width - 40, 180);
    [self.view addSubview:_aView];

    
    self.wordCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x + 20,  self.textView.frame.size.height + 84 - 1, [UIScreen mainScreen].bounds.size.width - 40, 20)];
    _wordCountLabel.font = [UIFont systemFontOfSize:14.f];
    _wordCountLabel.textColor = [UIColor lightGrayColor];
    self.wordCountLabel.text = @"0/250";
    self.wordCountLabel.backgroundColor = [UIColor whiteColor];
    self.wordCountLabel.textAlignment = NSTextAlignmentRight;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x + 20,  self.textView.frame.size.height + 84 - 1 + 23, [UIScreen mainScreen].bounds.size.width - 40, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    [self.view addSubview:_wordCountLabel];
    [_aView addSubview:self.textView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加一个label(问题截图)
    [self addLabelText];
    
    //创建collectionView进行上传图片
    [self addCollectionViewPicture];
    
    //添加图片的button
    self.photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_photoBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_photoBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.aView addSubview:_photoBtn];
    [self createALabelOfRight];


}


- (void)createALabelOfRight{
    
    lbRight = [[UILabel alloc] initWithFrame:CGRectMake(self.textView.frame.origin.x + 20,  self.textView.frame.size.height + 84 - 1, [UIScreen mainScreen].bounds.size.width - 40, 20)];
    lbRight.backgroundColor = [UIColor whiteColor];
    lbRight.font = [UIFont systemFontOfSize:14.f];
    lbRight.textColor = [UIColor lightGrayColor];
    lbRight.textAlignment = NSTextAlignmentRight;
    lbRight.tag = 100;
    [self.view addSubview:lbRight];
    
}
- (void)createLeftAndRightBtn{

    UIButton* backButton= [[UIButton alloc] initWithFrame:CGRectMake(0,0,100,30)];
    [backButton setTitle:@"＜订单内容" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    backButton.tag = 1000;
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton* rightButton= [[UIButton alloc] initWithFrame:CGRectMake(0,0,100,30)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    rightButton.tag = 1001;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == 1000) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else{
        if (self.textView.text.length == 0) {
            
            [self showAlertWithMessage:@"您输入的信息为空，请重新输入"];
            
        }
        else if(self.textView.text.length < 15 ){
            
            [self showAlertWithMessage:@"文字输入至少为15字，请继续输入"];
        }
        else{
            
            [self.delegate editDoneWithText:self.textView.text imageArr:self.photoArrayM];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            NSLog(@"数据传输");
        }
    }
}



#if 1

- (NSMutableArray *)photoArrayM{
    
    if (!_photoArrayM) {
        
        _photoArrayM = [NSMutableArray arrayWithCapacity:0];
        
    }
    return _photoArrayM;
}


//图片上传
- (void)picureUpload:(UIButton *)sender{

    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    
    picker.allowsEditing=YES;
    
    picker.delegate=self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}



//上传图片的协议与代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image=nil;
    
    if ([info objectForKey: UIImagePickerControllerEditedImage]) {
        image=[info objectForKey: UIImagePickerControllerEditedImage];//只能选UIImagePickerControllerOriginalImage 的时候 才能照片跟相册同时选择
        [self.photoArrayM addObject:image];
        
    }else{
        image=[info objectForKey: UIImagePickerControllerOriginalImage];
        [self.photoArrayM addObject:image];
    }
    NSLog(@"\n数组中有%ld张图片",(unsigned long)self.photoArrayM.count);
    //选取完图片之后关闭视图
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//button的frame
-(void)viewWillAppear:(BOOL)animated{
    
    if (self.photoArrayM.count < 3) {    //涉及添加加号的有无
        [self.collectionV reloadData];
        _aView.frame = CGRectMake(20, 84, self.view.frame.size.width - 40, 180);
        self.photoBtn.frame = CGRectMake(10 * (self.photoArrayM.count + 1) + (self.aView.frame.size.width - 60) / 3 * self.photoArrayM.count+10, 154 - 5, (self.aView.frame.size.width - 60) / 3, (self.aView.frame.size.width - 60) / 3 );
        
    }else{
        [self.collectionV reloadData];
        self.photoBtn.frame = CGRectMake(0, 0, 0, 0);
    }
    
}

//填写订单任务的详细内容
- (void)addLabelText{

    UILabel * labelText = [[UILabel alloc] init];
    
    labelText.text = @"可以选填三张图片哦~";
    
    labelText.frame = CGRectMake(10, 125,[UIScreen mainScreen].bounds.size.width - 20, 20);
    
    labelText.font = [UIFont systemFontOfSize:14.f];
    
    labelText.textColor = _textView.placeholderColor;
    
    [_aView addSubview:labelText];
}


#pragma mark - 上传图片UIcollectionView

-(void)addCollectionViewPicture{
    
    //创建一种布局
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
    //设置每一个item的大小
    flowL.itemSize = CGSizeMake((self.aView.frame.size.width - 60) / 3 , (self.aView.frame.size.width - 60) / 3);
    flowL.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
    //列
    flowL.minimumInteritemSpacing = 10;
    //行
    flowL.minimumLineSpacing = 10;
    //创建集合视图
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 145, self.aView.frame.size.width, ([UIScreen mainScreen].bounds.size.width - 60) / 3 + 10) collectionViewLayout:flowL];
    _collectionV.backgroundColor = [UIColor whiteColor];
    // NSLog(@"-----%f",([UIScreen mainScreen].bounds.size.width - 60) / 3);
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    //添加集合视图
    [self.aView addSubview:_collectionV];
    
    //注册对应的cell
    [_collectionV registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}


- (PlaceholderTextView *)textView{

    if (!_textView) {
        
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 100)];
        
        _textView.backgroundColor = [UIColor whiteColor];
        
        _textView.delegate = self;
        
        _textView.font = [UIFont systemFontOfSize:14.f];
        
        _textView.textColor = [UIColor blackColor];
        
        _textView.textAlignment = NSTextAlignmentLeft;
        
        _textView.editable = YES;
        
        _textView.layer.cornerRadius = 4.0f;
        
        _textView.layer.borderColor = kTextBorderColor.CGColor;
        
        _textView.layer.borderWidth = 0.5;
        
        _textView.placeholderColor = RGBCOLOR(0x89, 0x89, 0x89);
        
        _textView.placeholder = @"请详细输入任务要求...";
    }
    return _textView;
}

//把回车键当做退出键的相应键 textView退出键的操作
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}


- (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (_photoArrayM.count == 0) {
        
        return 0;
    }
    
    else{
        return _photoArrayM.count;
        
    }
}

//返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.photoV.image = self.photoArrayM[indexPath.item];
    
    //添加tag值找到对应图标
    cell.photoV.tag = 100+indexPath.item;
    cell.photoV.userInteractionEnabled = YES;
    [self addTapWithView:cell.photoV];
    
    return cell;
}

#pragma mark -- 给视图添加手势
- (void)addTapWithView:(UIImageView *)imageView{
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [imageView addGestureRecognizer:longPressGr];

}


-(void)longPressToDo:(UILongPressGestureRecognizer *)longPreess

{
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示:" message:@"您确定要删除吗?" preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        if (longPreess.state == UIGestureRecognizerStatePossible) {
            
            NSLog(@"\n%ld被长按了 ",(longPreess.view.tag-100));
            
            if (self.photoArrayM.count != 0) {
                
                [self.photoArrayM removeObjectAtIndex:(longPreess.view.tag-100)];
                
            }
            [self.collectionV reloadData];
            
            self.photoBtn.frame = CGRectMake(10 * (self.photoArrayM.count + 1) + (self.aView.frame.size.width - 60) / 3 * self.photoArrayM.count+10, 154 - 5, (self.aView.frame.size.width - 60) / 3, (self.aView.frame.size.width - 60) / 3 );
        }
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}

#pragma mark - textField的字数限制
//在这儿计算输入的字数
- (void)textViewDidChange:(UITextView *)textView{
    
    NSInteger wordCount = textView.text.length;
    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/250",(long)wordCount];
    
    if (wordCount < 15 && wordCount > 0) {
        
        lbRight.text = [NSString stringWithFormat:@"还需%d个字,即可发表", (int)(15 - wordCount)];
        lbRight.alpha = 1;
        
    }else{
        
        lbRight.alpha = 0;
    }
    [self wordLimit:textView];
}

#pragma mark - 超过250字不能输入
-(BOOL)wordLimit:(UITextView *)text{
    
    if (text.text.length < 250) {
        
        NSLog(@"%d",text.text.length);
        
        self.textView.editable = YES;
    }
    else{
        self.textView.editable = NO;
        
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [_textView resignFirstResponder];
    
    [_textField resignFirstResponder];
 
}

#pragma mark -- 提示框
- (void)showAlertWithMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}


#endif






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
























































@end
