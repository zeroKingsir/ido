//
//  GuidanceViewController.m
//  
//
//  Created by G.Z on 16/1/19.
//  Copyright (c) 2016年 G.Z. All rights reserved.
//

#import "GuidanceViewController.h"
#import "Storage.h"
#define SCREEN_W  [UIScreen mainScreen].bounds.size.width
#define SCREEN_H  [UIScreen mainScreen].bounds.size.height

@interface GuidanceViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;
//显示引导图片

@property (nonatomic,strong)NSMutableArray *imagesArr;
//存储引导图片名

@property (nonatomic,copy)MyBlock block;
//用于显示结束 回调


@end

@implementation GuidanceViewController

#pragma mark - 自定义构造方法
- (instancetype)initWithImagesArr:(NSArray *)imagesArr andBlock:(MyBlock)block{

    if (self = [super init]) {
        
        //接收从外部传递的图片以及block
        _imagesArr = [NSMutableArray arrayWithArray:imagesArr];
        
        _block = block;
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createScrollView];
    
}

#pragma mark -- create scrollView
- (void)createScrollView{
//1.创建
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    
//2.添加图片
    for (int i = 0; i < _imagesArr.count; i++) {
        
        NSString *imageName = _imagesArr[i];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        
        imageView.frame = CGRectMake(SCREEN_W *i, 0, SCREEN_W, SCREEN_H);
        
        [_scrollView addSubview:imageView];
        
    }
    
//3.其他设置
    _scrollView.contentSize = CGSizeMake(SCREEN_W *_imagesArr.count, SCREEN_H);
    //可显示的范围
    
    _scrollView.bounces = NO;
    //关闭弹簧
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    //隐藏横屏的滑动条
    
    _scrollView.pagingEnabled = YES;
    //开启翻页模式
    
    _scrollView.delegate = self;
    //设置代理
    
    [self.view addSubview:_scrollView];
 
//4.添加进入的应用的button
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W * _imagesArr.count - 100 - 20, SCREEN_H - 50 - 20, 100, 40)];
    
//    [btn setTitle:@"进入应用"forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    btn.layer.cornerRadius = 8.0;
    
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [btn setTitle:@"点击进入应用" forState:UIControlStateNormal];//
    
    btn.backgroundColor = [UIColor whiteColor];
   
//    [btn setBackgroundImage:[UIImage imageNamed:@"enter.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(enterApp:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:btn];
    
    
    
    
}

#pragma mark -- button点击事件
- (void)enterApp:(UIButton *)btn{
    
    //引导页的本地标记设置为yes window根控制器切换
    
    //修改本地标记为yes 下一次不再显示引导页
    [Storage setGuidanceValue:YES];
    
    //回调 程序回到AppDetegate中指向
    self.block();
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
