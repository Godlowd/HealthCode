//
//  GuardViewController.m
//  HealthCode
//
//  Created by New on 2020/7/16.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import "GuardViewController.h"
#import "ResultViewController.h"
#import <RSAObjC.h>
#import "RSA.h"
#define RSA_PrivateKey @"-----BEGIN PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMMjZu9UtVitvgHS\ntpmAU/rRVdhy9GaT2rnpCJOYSb0deVI+rXPKHI9Aca2LkWiRgkzM1wqbRvAvWrqK\ngm4PgQUjnoNr7vRd1HPUKNA9ATfJetddW86yar0ux3FMVaxUFN6F0KatqkplVXHo\n8qXubKHRx9dCbK95P96rJkrWBiO9AgMBAAECgYBO1UKEdYg9pxMX0XSLVtiWf3Na\n2jX6Ksk2Sfp5BhDkIcAdhcy09nXLOZGzNqsrv30QYcCOPGTQK5FPwx0mMYVBRAdo\nOLYp7NzxW/File//169O3ZFpkZ7MF0I2oQcNGTpMCUpaY6xMmxqN22INgi8SHp3w\nVU+2bRMLDXEc/MOmAQJBAP+Sv6JdkrY+7WGuQN5O5PjsB15lOGcr4vcfz4vAQ/uy\nEGYZh6IO2Eu0lW6sw2x6uRg0c6hMiFEJcO89qlH/B10CQQDDdtGrzXWVG457vA27\nkpduDpM6BQWTX6wYV9zRlcYYMFHwAQkE0BTvIYde2il6DKGyzokgI6zQyhgtRJ1x\nL6fhAkB9NvvW4/uWeLw7CHHVuVersZBmqjb5LWJU62v3L2rfbT1lmIqAVr+YT9CK\n2fAhPPtkpYYo5d4/vd1sCY1iAQ4tAkEAm2yPrJzjMn2G/ry57rzRzKGqUChOFrGs\nlm7HF6CQtAs4HC+2jC0peDyg97th37rLmPLB9txnPl50ewpkZuwOAQJBAM/eJnFw\nF5QAcL4CYDbfBKocx82VX/pFXng50T7FODiWbbL4UnxICE0UBFInNNiWJxNEb6jL\n5xd0pcy9O2DOeso=\n-----END PRIVATE KEY-----";
@interface GuardViewController ()

@end

@implementation GuardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setNavigationItem];
    _private_key = RSA_PrivateKey;
    _info = UserInfo.new;

    
    // Do any additional setup after loading the view.
}
-(void)setNavigationItem{
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title = @"二维码";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                 initWithTitle:@"相册"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(openPhoto)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

//调用相册
- (void)openPhoto {
    //1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    //2.创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    //选中之后大图编辑模式
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}

//相册获取的照片进行处理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 1.取出选中的图片
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
//    UIImageView *imgview = [[UIImageView alloc] initWithImage:pickImage];
//    [self.view addSubview:imgview];
//    imgview.center = self.view.center;
    //转成Data格式
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    CIImage *ciImage = [CIImage imageWithData:imageData];
//    //放大二维码
//    ciImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(0.5, 0.5)];
    //2.从选中的图片中读取二维码数据
    //2.1创建一个探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    
    // 2.2利用探测器探测数据
    NSArray *feature = [detector featuresInImage:ciImage];
    NSLog(@"the feature is %@",feature);
    if (feature.count == 0) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"扫描结果" message:@"没有扫描到有效二维码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [controller addAction:confirm];
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self presentViewController:controller animated:YES completion:nil];
        return ;
    }
    // 2.3取出探测到的数据
    for (CIQRCodeFeature *result in feature) {
        NSString  *urlStr = result.messageString;
        NSLog(@"the string is %@",urlStr);
        NSString * regex = @"^([0-9]|[a-zA-Z]){6,17}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        __strong result = [pred evaluateWithObject:urlStr];
        NSString *decrypted = [RSA decryptString:urlStr privateKey:_private_key];
        NSLog(@"decrypted: %@", decrypted);
        _detail = decrypted;
    }
    NSArray *array = [_detail componentsSeparatedByString:@"/"];

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:array[1]];

    _info.name = array[0];
    _info.updateTime =date;
    _info.IdentityId = array[2];
    NSString *color = array[3];
    _info.color = color;
    [picker dismissViewControllerAnimated:YES completion:nil];
    ResultViewController *rvc = ResultViewController.new;
    rvc.info = _info;
    
    [self.navigationController pushViewController:rvc animated:YES];
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
