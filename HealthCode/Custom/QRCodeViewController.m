//
//  QRCodeViewController.m
//  HealthCode
//
//  Created by New on 2020/7/14.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import "QRCodeViewController.h"
#import "UserInfo.h"
#import "SuccessView.h"
#import <RSAObjC.h>
#import <Masonry.h>
#import "RSA.h"

#define UPDATETIME 30
@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

static int num = UPDATETIME;

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    self.view.backgroundColor = UIColor.whiteColor;
    [self initPublicKey];
    NSString *info = [self generateIdentityWith:@"法外狂徒张三" Color:arc4random_uniform(3) UpdateTime:[NSDate date]];
    UIImage *img = [self generateQRCode:info size:CGSizeMake(50, 50) color:_userInfo.color];
    [self setTimerLabel];
    [self createUpdateQRCodeTimer];
    [self createUpdateLabelTimer];
    [self setUpColorBtn];
    [self initQRViewWithImg:img completion:^{
        if(self.qrcodeview){
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            self.visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
            self.visualView.frame = self.view.frame;
            [self.view addSubview:self.visualView];
            self.success = [[SuccessView alloc] initWithFrame:CGRectMake(0,0,70,70) withState:YES];
            self.success.center = self.view.center;
            [self.view addSubview:self.success];
            [self performSelector:@selector(removeMask) withObject:nil afterDelay:1];
        }
    }];

    // Do any additional setup after loading the view.
}

-(void)removeMask{
    [_success removeFromSuperview];
    [_visualView removeFromSuperview];
}
# pragma mark - init public key
-(void)initPublicKey{
    _public_key = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI2bvVLVYrb4B0raZgFP60VXY\ncvRmk9q56QiTmEm9HXlSPq1zyhyPQHGti5FokYJMzNcKm0bwL1q6ioJuD4EFI56D\na+70XdRz1CjQPQE3yXrXXVvOsmq9LsdxTFWsVBTehdCmrapKZVVx6PKl7myh0cfX\nQmyveT/eqyZK1gYjvQIDAQAB\n-----END PUBLIC KEY-----";
}

# pragma mark - generate Timer
//创建二维码定时器
-(void)createUpdateQRCodeTimer{
    _QRCodeTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATETIME target:self selector:@selector(updateQRcode) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_QRCodeTimer forMode:NSRunLoopCommonModes];
}
//创建label定时器
-(void)createUpdateLabelTimer{
    _LabelTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_LabelTimer forMode:NSRunLoopCommonModes];
}
-(void)setTimerLabel{
    _updateTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [self.view addSubview:_updateTime];
    [_updateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_top).with.offset(200);
    }];
    _updateTime.text = [NSString stringWithFormat:@"%@%@%@",@"距离二维码刷新还有",[@(UPDATETIME) stringValue],@"秒"];
    _updateTime.font = [UIFont systemFontOfSize:30];
}
# pragma mark - Timer SEL
//更新倒计时标签
- (void)updateLabel {
    
    num--;
    _updateTime.text = [NSString stringWithFormat:@"%@%@%@",@"距离二维码刷新还有",[@(num) stringValue],@"秒"];
    if(num == 0){
        num = UPDATETIME;
    }
    [self.view layoutIfNeeded];
}

//更新二维码
-(void)updateQRcode{
//    if(num < 29)
    _userInfo.updateTime = [NSDate dateWithTimeInterval:UPDATETIME sinceDate:_userInfo.updateTime];
    
    NSString *info = [_userInfo generateOriginalInfo];
    NSString *temp = [RSA encryptString:info publicKey:_public_key];
    UIImage *img = [self generateQRCode: temp size:CGSizeMake(100, 100) color:_userInfo.color];
    NSLog(@"when update qrcode the date is %@", _userInfo.updateTime);
    [self BeforeRotation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.qrcodeview.image = img;
//        [self AfterRotation];
    });
    
    [self.view setNeedsLayout];
    
//    [self AfterRotation];
}
# pragma mark - init Indentity
-(NSString *)generateIdentityWith:(NSString *)name Color:(int)color UpdateTime:(NSDate *)date {
    _userInfo = UserInfo.new;
    _userInfo.name = name;
    _userInfo.IdentityId = [self getRandomString];
    
    _userInfo.color = [_userInfo setcolor:color];
    NSLog(@"the color is %@",_userInfo.color);

    _userInfo.updateTime = date;
    NSLog(@"the update time is %@",_userInfo.updateTime);
    NSString *info = [_userInfo generateOriginalInfo];
    NSString *encrypted = [RSA encryptString:info publicKey:_public_key];
    NSLog(@"加密后:%@", encrypted);

    return encrypted;
}
- (NSString *)getRandomString {
    
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    for (int i = 0; i < kNumber; i++) {
        
        NSUInteger index = arc4random() % sourceStr.length;
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
# pragma mark - init QRCode and its imageview
//初始化imgview
-(void)initQRViewWithImg:(UIImage *) img completion:(void(^)(void))callback{
    _qrcodeview = [[UIImageView alloc] initWithImage:img];
    _qrcodeview.layer.shadowOffset = CGSizeMake(0, 0.5);
    _qrcodeview.layer.shadowRadius = 1;
    _qrcodeview.layer.borderColor = [UIColor.blackColor CGColor];
    _qrcodeview.layer.borderWidth = 0;
    _qrcodeview.backgroundColor = UIColor.redColor;
    [self.view addSubview:_qrcodeview];
//    _qrcodeview.center = self.view.center;
    [_qrcodeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    callback();
}
/*
 code : 需要封装成二维码的信息
 size : 要生成的二维码的大小
 color : 要生成的二维码的颜色
 */
-(UIImage *)generateQRCode:(NSString *)code size:(CGSize)size color:(NSString *)color {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    NSString *urlString = code;
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *image = [filter outputImage];
    //放大二维码
    image = [image imageByApplyingTransform:CGAffineTransformMakeScale(4, 4)];
    // 5.创建颜色过滤器
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    // 6.设置默认值
    [colorFilter setDefaults];
        /*
         inputImage,     需要设定颜色的图片
         inputColor0,    前景色 - 二维码的颜色
         inputColor1     背景色 - 二维码背景的颜色
         */
    NSLog(@"%@",colorFilter.inputKeys);
        // 7.给颜色过滤器添加信息
        // 设定图片
    [colorFilter setValue:image forKey:@"inputImage"];
    // 设定背景色为白色
    [colorFilter setValue:[CIColor colorWithRed:1 green:1 blue:1] forKey:@"inputColor1"];
    // 设定前景色
    /*
     0: 红码
     1: 黄码
     2: 绿码，默认为绿码
     */
    if ([color isEqualToString:@"red"]) {
        [colorFilter setValue:[CIColor colorWithRed:1 green:0 blue:0 ] forKey:@"inputColor0"];
    }
    else if([color isEqualToString:@"green"]){
        [colorFilter setValue:[CIColor colorWithRed:0 green:1 blue:0 ] forKey:@"inputColor0"];
    }
    else{
        [colorFilter setValue:[CIColor colorWithRed:0.8 green:0.7 blue:0 ] forKey:@"inputColor0"];
    }
    // 获取图片
    image = colorFilter.outputImage;
    UIImage *img = [UIImage imageWithCIImage:image];
    return img;
}

# pragma mark - generate Specific Color QRCode
-(void)setUpColorBtn{
    _greenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _greenBtn.frame = CGRectMake(0, 0, 30, 10);
    [_greenBtn setTitle:@"绿色二维码" forState:UIControlStateNormal];
    [self.view addSubview:_greenBtn];
    [_greenBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [_greenBtn addTarget:self action:@selector(generateGreenCode) forControlEvents:UIControlEventTouchUpInside];
    
    
    _redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _redBtn.frame = CGRectMake(0, 0, 30, 10);
    [_redBtn setTitle:@"红色二维码" forState:UIControlStateNormal];
    [self.view addSubview:_redBtn];
    [_redBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [_redBtn addTarget:self action:@selector(generateRedCode) forControlEvents:UIControlEventTouchUpInside];
    
    _yellowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _yellowBtn.frame = CGRectMake(0, 0, 30, 10);
    [_yellowBtn setTitle:@"黄色二维码" forState:UIControlStateNormal];
    [self.view addSubview:_yellowBtn];
    [_yellowBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [_yellowBtn addTarget:self action:@selector(generateYellowCode) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *btn = @[_greenBtn, _redBtn, _yellowBtn];
    [btn mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).with.offset(-250);
    }];
}

-(void)generateRedCode{
    _userInfo.updateTime = [NSDate date];
    _userInfo.color = @"red";
    [_QRCodeTimer setFireDate:[NSDate distantPast]];
    num = UPDATETIME;
}

-(void)generateGreenCode{
    _userInfo.updateTime = [NSDate date];
    _userInfo.color = @"green";
    [_QRCodeTimer setFireDate:[NSDate distantPast]];
    num = UPDATETIME;
}

-(void)generateYellowCode{
    _userInfo.updateTime = [NSDate date];
    _userInfo.color = @"yellow";
    [_QRCodeTimer setFireDate:[NSDate distantPast]];
    num = UPDATETIME;
}

# pragma mark - imaveView Flipp Animation
-(void)changeImage{
    if (_qrcodeview.tag == 101) {
        _userInfo.updateTime = [NSDate dateWithTimeInterval:UPDATETIME sinceDate:_userInfo.updateTime];
        NSString *info = [_userInfo generateOriginalInfo];
        NSString *temp = [RSA encryptString:info publicKey:_public_key];
        _qrcodeview.image = [self generateQRCode: temp size:CGSizeMake(100, 100) color:_userInfo.color];
        _qrcodeview.tag = 102;
    } else {
    _qrcodeview.tag = 101;
    }
}
-(void)BeforeRotation{
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    // 旋转角度， 其中的value表示图像旋转的最终位置
    keyAnimation.values = [NSArray arrayWithObjects:

    [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],

    [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/2), 0,1,0)],
    [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],

    nil];

    keyAnimation.cumulative = NO;

    keyAnimation.duration = 1;

    keyAnimation.repeatCount = 1;

    keyAnimation.removedOnCompletion = NO;

    keyAnimation.delegate = self;

    [_qrcodeview.layer addAnimation:keyAnimation forKey:@"transform"];
//    [self performSelector:@selector(updateQRcode) withObject:nil afterDelay:1 * 10];
//    [self performSelector:@selector(changeImage) withObject:nil afterDelay:0];
}
@end
