//
//  GetPicture.m
//  DingDing
//
//  Created by WenhuaLuo on 16/10/25.
//  Copyright © 2016年 Meity. All rights reserved.
//

#import "GetPicture.h"

#import "AJPhotoBrowserViewController.h"
#import "AJPhotoPickerViewController.h"

@interface GetPicture()<AJPhotoPickerProtocol,AJPhotoBrowserDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger selectMaxNum;
    
}

//［base64，UIImage］
@property (nonatomic, strong) NSMutableArray *pictureInfoMulArr;

@property (nonatomic, strong) NSMutableArray *pictureMulArr;

@property (nonatomic, strong) UIViewController *showController;

@property (nonatomic, copy) NSString *keyTag;

@end

@implementation GetPicture

+ (GetPicture *)sharedInstance
{
    static GetPicture *getPicture;
    
    static dispatch_once_t demoglobalclassonce;
    
    dispatch_once(&demoglobalclassonce, ^{
        
        getPicture = [[GetPicture alloc] init];
        
    });
    
    return getPicture;
}

- (void)initPhotePickerWithController:(UIViewController *)controller selectMaxNum:(NSInteger)maxNum containArr:(NSArray *)containArr keyTag:(NSString *)keyTag delegate:(id /**<GetPictureDelegate>*/)delegate
{
    if (maxNum > 1) {
        self.pictureInfoMulArr = [[NSMutableArray alloc]initWithArray:containArr];
    }
    else
        self.pictureInfoMulArr = [NSMutableArray array];
    
    self.pictureMulArr = [[NSMutableArray alloc]initWithArray:containArr];
    
    self.showController = controller;
    
    self.delegate = delegate;
    
    self.keyTag = keyTag;
    
    selectMaxNum = maxNum;
    
    NSInteger num = maxNum;
    
    if ([self.pictureMulArr count] > 0) {
        num = maxNum - [self.pictureMulArr count];
    }
    
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    
    picker.maximumNumberOfSelection = num;
    
    picker.multipleSelection = YES;
    
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    
    picker.showEmptyGroups = YES;
    
    picker.delegate=self;
    
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [controller presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - BoPhotoPickerProtocol,，，，，选择照片的代理
- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets
{
    
    if ([assets count] > 0) {
        
        for (int i = 0; i < [assets count]; i++) {
            
            ALAsset *asset = assets[i];
            
            UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            NSData *_data = UIImageJPEGRepresentation(tempImg, 1.0f);
            
            NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:0];
            
            //            imgStr = [NSString stringWithFormat:@"%@,%@",imgStr,_encodedImageStr];
            
            [self.pictureInfoMulArr addObject:@[_encodedImageStr, tempImg]];
            
            [self.pictureMulArr addObject:@[_encodedImageStr, tempImg]];//tempImg];
        }
        
        //        imgStr = [imgStr stringByReplacingOccurrencesOfString:@"(null)," withString:@""];
        if ([self.delegate respondsToSelector:@selector(getPictureResult:keyTag:)]) {
            [self.delegate getPictureResult:self.pictureInfoMulArr keyTag:self.keyTag];
        }
        
    }
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAsset:(ALAsset *)asset {
    NSLog(@"%s",__func__);
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didDeselectAsset:(ALAsset *)asset {
    NSLog(@"%s",__func__);
}

//超过最大选择项时
- (void)photoPickerDidMaximum:(AJPhotoPickerViewController *)picker {
    [CommonMethod altermethord:[NSString stringWithFormat:@"最多可选择%zd张照片", selectMaxNum] andmessagestr:@"" andconcelstr:@"确定"];
}

//低于最低选择项时
- (void)photoPickerDidMinimum:(AJPhotoPickerViewController *)picker {
    NSLog(@"%s",__func__);
}

- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker {
    
    [self checkCameraAvailability:^(BOOL auth) {
        
        if (!auth) {
            [GetPicture altermethord:@"抱歉" andmessagestr:@"您没有访问相机权限" andconcelstr:@"确定"];
            
            return;
        }
        
        [picker dismissViewControllerAnimated:NO completion:nil];
        
        UIImagePickerController *cameraUI = [UIImagePickerController new];
        
        cameraUI.allowsEditing = NO;
        
        cameraUI.delegate = self;
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
        
        [self.showController presentViewController: cameraUI animated: YES completion:nil];
    }];
}


#pragma mark - UIImagePickerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (!error) {
        NSLog(@"保存到相册成功");
    }else{
        NSLog(@"保存到相册出错%@", error);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    UIImage *originalImage;
    
    if (CFStringCompare((CFStringRef) mediaType,kUTTypeImage, 0)== kCFCompareEqualTo) {
        
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
    
    
    
    NSData *_data = UIImageJPEGRepresentation(originalImage, 1.0f);
    
    NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:0];
    
    [self.pictureInfoMulArr addObject:@[_encodedImageStr, originalImage]];
    
    [self.pictureMulArr addObject:@[_encodedImageStr, originalImage]];//originalImage];
    
    if ([self.delegate respondsToSelector:@selector(getPictureResult:keyTag:)]) {
        [self.delegate getPictureResult:self.pictureInfoMulArr keyTag:self.keyTag];
    }
    
    [self.showController dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)checkCameraAvailability:(void (^)(BOOL auth))block {
    
    BOOL status = NO;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            if(granted){
                if (block) {
                    block(granted);
                }
            } else {
                if (block) {
                    block(granted);
                }
            }
            
        }];
        
        return;
    }
    if (block) {
        
        block(status);
        
    }
    
}

+(void)altermethord:(NSString *)titlestr andmessagestr:(NSString *)messagestr andconcelstr:concelstr{
    
    UIAlertView* alert = [[UIAlertView alloc] init];
    alert.title = titlestr;
    alert.message =messagestr;
    [alert addButtonWithTitle:concelstr];
    [alert show];
    
}//提示信息方法//提示信息方法


@end
