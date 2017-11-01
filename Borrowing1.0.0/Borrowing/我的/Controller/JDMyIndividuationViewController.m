//
//  JDMyIndividuationViewController.m
//  Borrowing
//
//  Created by Sierra on 2017/8/28.
//  Copyright © 2017年 wenzhengban. All rights reserved.
//

#import "JDMyIndividuationViewController.h"
#import "JDIndividuationTableViewCell.h"

#import "XMGHTTPSessionManager.h"
#import "DDPCAView.h"
#import "JDIndividuation_M.h"

#import <AdSupport/AdSupport.h>

@interface JDMyIndividuationViewController ()<UITableViewDataSource,UITableViewDelegate>

/**tableView*/
@property (nonatomic, strong) UITableView *tableView;

/**cell默认数据*/
@property (nonatomic, strong) NSMutableArray<JDMyIndividuationModel *> *cellMulIndArr;


@property (nonatomic, strong) DDPCAView *pcaView;

@property (nonatomic, strong) XMGHTTPSessionManager *manager;

/**保存*/
@property (nonatomic, strong) UIButton *preservationBtn;

/**是否填写过个人信息*/
@property (nonatomic, assign)  BOOL isEdit;

@end

@implementation JDMyIndividuationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TableColor;
    
    self.navigationItem.title = @"借款意向";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self getCustomerUser];
    
    self.tableView.tableFooterView = [UIView new];
    
    
    self.pcaView = [[DDPCAView alloc] initWithDelegate:self showSection:2];
    
    [self preservationBtn];
}

#pragma mark - preservationClick -- 保存
- (void)preservationClick
{
    
    BOOL isUserName = self.cellMulIndArr[0].userName.length > 0;
    BOOL isCard = [XMToolClass validateIdentityCard:self.cellMulIndArr[1].card];
    BOOL isProvice = self.cellMulIndArr[2].provice.length > 0;
    BOOL isCity = self.cellMulIndArr[2].city.length > 0;
    BOOL isMarriage = self.cellMulIndArr[3].marriage.length > 0;
    BOOL isCulture = self.cellMulIndArr[4].culture.length > 0;
    BOOL isLoanMoney = self.cellMulIndArr[5].loanMoney.length > 0;
    BOOL isLoanTimeType = self.cellMulIndArr[6].loanTimeType.length > 0;
    BOOL isLoanTime = self.cellMulIndArr[6].loanTime.length > 0;
    
    
    if (!isUserName) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        return;
    }
    
    if (!isCard) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写正确的身份证号"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        return;
    }
    
    if (!isProvice || !isCity ) {
        
        [SVProgressHUD showErrorWithStatus:@"请选择地区"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        return;
    }
    
    
    if (!isMarriage) {
        
        [SVProgressHUD showErrorWithStatus:@"请选择婚姻状况"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        return;
    }
    
    if (!isCulture) {
        
        [SVProgressHUD showErrorWithStatus:@"请选择文化程度"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        return;
    }
    
    if (!isLoanMoney) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入金额"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        return;
    }else{
        
        if (self.cellMulIndArr[5].loanMoney.length > 8) {
            
            [SVProgressHUD showErrorWithStatus:@"您输入的金额过大,请重新输入"];
            [SVProgressHUD dismissWithDelay:0.5];
            
            JDMyIndividuationModel *model5 = self.cellMulIndArr[5];
            model5.loanMoney = @"";
            model5.fieldText = @"";
            [self.cellMulIndArr replaceObjectAtIndex:5 withObject:model5];
            
            [self.tableView reloadData];
            
            return;
        }
    }
    
    if (!isLoanTimeType) {
        
        [SVProgressHUD showErrorWithStatus:@"请选择借款期限"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        return;
    }
    
    if (!isLoanTime) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入借款时间"];
        [SVProgressHUD dismissWithDelay:0.5];
        
        return;
    }
    
    self.preservationBtn.enabled = NO;
    
    if (self.isEdit) {
        
        [self addCustomerUserWithURL:@"/loanshop/user/addCustomerUser"];
    }else{
        
        [self addCustomerUserWithURL:@"/loanshop/user/updateCustomerUser"];
    }
    
    
}

#pragma mark - 添加个性化数据
- (void)addCustomerUserWithURL:(NSString *)url
{
    
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    NSDictionary *parameters2 =
    @{
      @"userName":self.cellMulIndArr[0].userName,
      @"card":self.cellMulIndArr[1].card,
      @"provice":self.cellMulIndArr[2].provice,
      @"city":self.cellMulIndArr[2].city,
//      @"mobile":self.cellMulIndArr[7].mobile,
      @"mobile":[DBSave account].account,
      @"marriage":self.cellMulIndArr[3].marriage,
      @"culture":self.cellMulIndArr[4].culture,
      @"loanMoney":self.cellMulIndArr[5].loanMoney,
      @"loanTimeType":self.cellMulIndArr[6].loanTimeType,
      @"loanTime":self.cellMulIndArr[6].loanTime,
      @"equipment":@"2",
      @"deviceNumber":adId,
      @"userId":[DBSave account].ID,
      @"id":self.cellMulIndArr[0].ID,
      };
    
    NSString *url2 = [[NSString stringWithFormat:@"%@%@",LOGINURL,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager GET:url2 parameters:parameters2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        weakSelf.preservationBtn.enabled = YES;
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"errorCode"]];
            [SVProgressHUD dismissWithDelay:kDelayTime];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        weakSelf.preservationBtn.enabled = YES;
    }];
}




#pragma mark - 请求个性化数据
- (void)getCustomerUser
{
    
    NSDictionary *parameters2 =
    @{
      @"userId":[DBSave account].ID,
      };
    
    NSString *url2 = [[NSString stringWithFormat:@"%@/loanshop/user/getCustomerUser/%@",LOGINURL,[DBSave account].ID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager GET:url2 parameters:parameters2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject valueForKey:@"successed"] boolValue]) {
            
            
            if ([[responseObject valueForKey:@"errorDesc"] isEqualToString:@"2"]) {//不为空
                
                weakSelf.isEdit = NO;
                
                JDIndividuation_M *dict = [JDIndividuation_M mj_objectWithKeyValues:[responseObject valueForKey:@"returnValue"]];
                
                [weakSelf loadDataWithData:dict];
                
            }else if ([[responseObject valueForKey:@"errorDesc"] isEqualToString:@"1"])//空
            {
                weakSelf.isEdit = YES;
                
                //第一行
                JDMyIndividuationModel *model = self.cellMulIndArr[0];
                model.ID = @"";
                [self.cellMulIndArr replaceObjectAtIndex:0 withObject:model];
            }
            
            
        }else{
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)loadDataWithData:(JDIndividuation_M *)dic
{
    //第一行
    JDMyIndividuationModel *model = self.cellMulIndArr[0];
    model.userName = dic.userName;
    model.fieldText = dic.userName;
    model.ID = dic.ID;
    [self.cellMulIndArr replaceObjectAtIndex:0 withObject:model];
    
    //第二行
    JDMyIndividuationModel *model1 = self.cellMulIndArr[1];
    model1.card = dic.card;
    model1.fieldText = dic.card;
    [self.cellMulIndArr replaceObjectAtIndex:1 withObject:model1];
    
    //第三行
    JDMyIndividuationModel *model2 = self.cellMulIndArr[2];
    model2.provice = dic.provice;
    model2.city = dic.city;
    model2.choiceText = [NSString stringWithFormat:@"%@%@",dic.provice,dic.city];
    [self.cellMulIndArr replaceObjectAtIndex:2 withObject:model2];
    
    //第四行
    JDMyIndividuationModel *model3 = self.cellMulIndArr[3];
    /**婚姻 1未婚 2已婚*/
    model3.marriage = dic.marriage;
    model3.choiceText = [dic.marriage isEqualToString:@"1"] ? @"未婚" : [dic.marriage isEqualToString:@"2"] ? @"已婚" : @"";
    [self.cellMulIndArr replaceObjectAtIndex:3 withObject:model3];
    
    //第5行
    JDMyIndividuationModel *model4 = self.cellMulIndArr[4];
    model4.culture = dic.culture;
    /**文化程度1高中以下2高中以及专科3大学4硕士以及以上*/
    model4.choiceText = dic.culture;
    switch ([dic.culture integerValue]) {
        case 1:
            
            model4.choiceText = @"高中以下";
            break;
        case 2:
            
            model4.choiceText = @"高中以及专科";
            break;
        case 3:
            
            model4.choiceText = @"大学";
            break;
        case 4:
            
            model4.choiceText = @"硕士以及以上";
            break;
            
        default:
            break;
    }
    
    [self.cellMulIndArr replaceObjectAtIndex:4 withObject:model4];
    
    
    //第6行
    JDMyIndividuationModel *model5 = self.cellMulIndArr[5];
    model5.loanMoney = dic.loanMoney;
    model5.fieldText = dic.loanMoney;
    [self.cellMulIndArr replaceObjectAtIndex:5 withObject:model5];
    
    
    //第7行
    JDMyIndividuationModel *model6 = self.cellMulIndArr[6];
    model6.loanTime = dic.loanTime;
    model6.fieldText = dic.loanTime;
    /**借款时间类型 1日  2月*/
    model6.loanTimeType = dic.loanTimeType;
    model6.choiceText = [dic.loanTimeType isEqualToString:@"1"] ? @"日" : [dic.loanTimeType isEqualToString:@"2"] ? @"月" : @"";
    
    [self.cellMulIndArr replaceObjectAtIndex:6 withObject:model6];
    
    //第8行
    JDMyIndividuationModel *model7 = self.cellMulIndArr[7];
    model7.mobile = dic.mobile;
    model7.fieldText = dic.mobile;
    [self.cellMulIndArr replaceObjectAtIndex:7 withObject:model7];
    
    [self.tableView reloadData];
}



#pragma mark - 所在地区
- (void)pcaViewDidSelectResult:(NSDictionary *)resultDict
{
    //[provinceID, cityID, areaID, provinceName, cityName, areaName]
    
    NSString *provinceName = [resultDict valueForKey:@"provinceName"];
    NSString *cityName = [resultDict valueForKey:@"cityName"];
    NSString *areaName = [resultDict valueForKey:@"areaName"];
    
    //判断选择的哪种类型
    JDMyIndividuationModel *model = self.cellMulIndArr[2];
    if ([[resultDict valueForKey:@"cityName"] isEqualToString:@"县"]) {
        
        model.provice = provinceName;
        model.city = @"";
        model.area = areaName;
        model.choiceText = [NSString stringWithFormat:@"%@",provinceName];
    }else
    {
        model.provice = provinceName;
        model.city = cityName;
        model.area = areaName;
        model.choiceText = [NSString stringWithFormat:@"%@%@",provinceName,cityName];
    }
    
    [self.cellMulIndArr replaceObjectAtIndex:2 withObject:model];
    
    [self.tableView reloadData];
}

#pragma mark - 选择弹窗框

- (void)choiceSelectPlayWindow:(NSArray *)alertArr index:(NSInteger)index
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    __weak typeof(self) weakSelf = self;
    
    for (int i = 0 ; i <alertArr.count; i ++) {
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:alertArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //判断选择的哪种类型
            JDMyIndividuationModel *model = self.cellMulIndArr[index];
            model.choiceText = action.title;
            
            if (index == 3) {
                
                model.marriage = [action.title isEqualToString:@"已婚"] ? @"2" : @"1";
            }else if (index == 4){
                
                NSString *culture = @"";
                if ([action.title isEqualToString:@"高中及以下"]) {
                    culture = @"1";
                }else if ([action.title isEqualToString:@"高中及专科"]){
                    
                    culture = @"2";
                }else if ([action.title isEqualToString:@"大学"]){
                    
                    culture = @"3";
                }else{
                    
                    culture = @"4";
                }
                model.culture = culture;
                
            }else if (index == 6){
                
                model.loanTimeType = [action.title isEqualToString:@"月"] ? @"2" : @"1";
            }
            
            [weakSelf.cellMulIndArr replaceObjectAtIndex:index withObject:model];
            
            [weakSelf.tableView reloadData];
        }];
        
        [alertController addAction:deleteAction];
        
    }
    
    [alertController addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    
    if (indexPath.row == 2) {
        
        //所在地区
        [self.pcaView show];
    }else if (indexPath.row == 3){
        
        NSArray *arr = @[@"已婚",@"未婚"];
        
        [self choiceSelectPlayWindow:arr index:indexPath.row];
        
    }else if (indexPath.row == 4){
        
        NSArray *arr = @[@"高中及以下",@"高中及专科",@"大学",@"硕士及以上"];
        
        [self choiceSelectPlayWindow:arr index:indexPath.row];
    }else if (indexPath.row == 6){
        
        NSArray *arr = @[@"月",@"日",];
        
        [self choiceSelectPlayWindow:arr index:indexPath.row];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 5 ) {
        //填写
        static NSString *storeCityID = @"JDIndividuationTableViewCell";
        
        JDIndividuationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCityID];
        
        if (cell == nil) {
            cell = [[JDIndividuationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
        }
        else
        {
            [cell removeFromSuperview];
            
            cell = [[JDIndividuationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
        }
        
        cell.titleLbl.text = self.cellMulIndArr[indexPath.row].cellName;
        
        cell.textField.placeholder = self.cellMulIndArr[indexPath.row].placeholder;
        
        cell.textField.text = self.cellMulIndArr[indexPath.row].fieldText;
        
        cell.textField.keyboardType = self.cellMulIndArr[indexPath.row].keyboardType;
        
        cell.textField.tag = indexPath.row + 888;
        
        //这种方法可以随时监听textField的字符变化
        [cell.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 6)
    {
        //选择
        static NSString *storeCityID = @"JDIndividuationChoiceTableViewCell";
        
        JDIndividuationChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCityID];
        
        if (cell == nil) {
            cell = [[JDIndividuationChoiceTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
        }
        else
        {
            [cell removeFromSuperview];
            
            cell = [[JDIndividuationChoiceTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLbl.text = self.cellMulIndArr[indexPath.row].cellName;
        
        cell.choiceLbl.text = self.cellMulIndArr[indexPath.row].choiceText;
        
        if (![self.cellMulIndArr[indexPath.row].choiceText isEqualToString:@"请选择"]) {
            
            cell.choiceLbl.textColor = BlackNameColor;
        }
        
        if (indexPath.row == 6) {
            
            
            UITextField *textField = [[UITextField alloc] init];
            
            textField.placeholder = @"请输入借款时间";
            
            textField.text = self.cellMulIndArr[indexPath.row].loanTime;
            
            textField.textAlignment = NSTextAlignmentRight;
            
            textField.textColor = BlackNameColor;
            
            textField.keyboardType = UIKeyboardTypeNumberPad;
            
            textField.font = kFont(13);
            
            [cell addSubview:textField];
            
            textField.tag = indexPath.row + 888;
            
            //这种方法可以随时监听textField的字符变化
            [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
            
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.top.bottom.mas_equalTo(0);
                
                make.left.mas_equalTo(100);
                
                make.right.mas_equalTo(-80);
            }];
        }
        
        return cell;
        
    }else
    {
        
        static NSString *storeCityID = @"hahahah";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeCityID];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
        }
        else
        {
            [cell removeFromSuperview];
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:storeCityID];
        }
        
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kWindowW);
        
        UIView *view = [UIView viewWithBackgroundColor:RGBCOLOR(244, 244, 248) superView:cell];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(8);
            
            make.top.mas_equalTo(5);
            
            make.right.mas_equalTo(-8);
            
            make.bottom.mas_equalTo(-5);
        }];
        
        UILabel *phone = [UILabel labelWithText:@"联系电话" font:kFont(13) textColor:BlackGrayColor backGroundColor:ClearColor superView:view];
        
        [phone mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(4);
            make.centerY.mas_equalTo(0);
        }];
        
        UILabel *phoneNumber = [UILabel labelWithText:[DBSave account].account font:kFont(13) textColor:BlackGrayColor backGroundColor:ClearColor superView:view];
        
        [phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(90 - 8);
            
            make.centerY.mas_equalTo(0);
        }];
        
        return cell;
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - 修改数据源
-(void)textChange:(UITextField *)textField{
    
    NSInteger row = textField.tag - 888;

    JDMyIndividuationModel *model = self.cellMulIndArr[row];
    
    if (row == 0) {
        
        model.userName = textField.text;
        model.fieldText = textField.text;
        
    }else if (row == 1){
        
        model.card = textField.text;
        model.fieldText = textField.text;
    }else if (row == 5){
        
        model.loanMoney = textField.text;
        model.fieldText = textField.text;
    }else if (row == 6){
        
        model.loanTime = textField.text;
    }
    else if (row == 7){
        
        model.mobile = textField.text;
        model.fieldText = textField.text;
    }
    
    [self.cellMulIndArr replaceObjectAtIndex:row withObject:model];
    
}


#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        
        _tableView.backgroundColor = TableColor;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.layer.masksToBounds = YES;
        
        _tableView.layer.cornerRadius = 5;
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(kNavigationH + 5);
            make.bottom.mas_equalTo(-65);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
        }];
    }
    return _tableView;
}


- (UIButton *)preservationBtn
{
    if (!_preservationBtn) {
        
        
        _preservationBtn = [UIButton buttonWithTitle:@"保  存" font:kFont(16) titleColor:WhiteColor backGroundColor:RGBCOLOR(22, 155, 213) buttonTag:0 target:self action:@selector(preservationClick) showView:self.view];
        
        _preservationBtn.layer.cornerRadius = 5;
        _preservationBtn.layer.masksToBounds = YES;
        [_preservationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(-10);
            make.left.mas_equalTo(6);
            make.right.mas_equalTo(-6);
            make.height.mas_equalTo(45);
        }];
    }
    return _preservationBtn;
}


- (NSMutableArray<JDMyIndividuationModel *>  *)cellMulIndArr
{
    if (!_cellMulIndArr) {
        
        NSArray *arr = @[
                         @[@"姓名",@"请输入姓名",],
                         @[@"身份证号",@"请输入身份证号"],
                         @[@"地区",@"请选择"],
                         @[@"婚姻状况",@"请选择"],
                         @[@"文化程度",@"请选择"],
                         @[@"意向借款额",@"请输入金额",],
                         @[@"借款期限",@"请选择",],
                         @[@"联系电话",@"请输入联系电话",],
                         ];
        
        _cellMulIndArr = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < arr.count; i ++) {
            
            if (i == 0 || i == 1 || i == 5 || i == 7)  {
                
                JDMyIndividuationModel *model = [[JDMyIndividuationModel alloc] init];
                
                model.cellName = arr[i][0];
                model.placeholder = arr[i][1];
                
                if (i == 0 || i == 1) {
                    model.keyboardType = UIKeyboardTypeDefault;
                }else{
                    
                    model.keyboardType = UIKeyboardTypeNumberPad;
                }
                
                [_cellMulIndArr addObject:model];
            }else
            {
                
                JDMyIndividuationModel *model = [[JDMyIndividuationModel alloc] init];
                
                model.cellName = arr[i][0];
                model.choiceText = arr[i][1];
                
                [_cellMulIndArr addObject:model];
            }
        }
        
    }
    return _cellMulIndArr;
}

- (XMGHTTPSessionManager *)manager
{
    if (!_manager) {
        
        _manager = [XMGHTTPSessionManager manager];
    }
    return _manager;
}
@end
