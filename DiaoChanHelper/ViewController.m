//
//  ViewController.m
//  DiaoChanHelper
//
//  Created by Robert on 07/01/2018.
//  Copyright © 2018 Sogou. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "NerdyUI.h"
#import "BlocksKit.h"
#import "BlocksKit+UIKit.h"


@interface ViewController ()
@property (nonatomic, strong) UILabel* displayLabel;
@property (nonatomic, strong) UILabel* titleLabel;
//@property (nonatomic, strong)

@property (nonatomic, strong) NSNumber* firstPower;
@property (nonatomic, strong) NSNumber* secondPower;
@property (nonatomic, strong) NSNumber* firstArmor;
@property (nonatomic, strong) NSNumber* secondArmor;

@property (nonatomic, assign) id currentInputing;


@property (nonatomic, strong) NSNumber* resultFirstPower;
@property (nonatomic, strong) NSNumber* resultSecondPower;
@property (nonatomic, strong) NSNumber* resultFirstArmor;
@property (nonatomic, strong) NSNumber* resultSecondArmor;
@property (nonatomic) NSInteger income;

@property (nonatomic) BOOL calced;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    [self clear];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)clear {
    self.calced = NO;
    self.firstPower = @(0);
    self.firstArmor = @(0);
    self.secondPower = @(0);
    self.secondArmor = @(0);
    self.currentInputing = (id)&_firstPower;
    NSLog(@"%p,%p,%@,%@", self.currentInputing, self.firstPower,self.currentInputing, self.firstPower);
    self.firstPower = @(2);
    NSLog(@"%p,%p,%@,%@", self.currentInputing, self.firstPower,self.currentInputing, self.firstPower);
    
    self.displayLabel.str(@"0");
    [self updateDisplay];
}

- (void)updateDisplay {
    if(!self.calced){
        self.titleLabel.text = [NSString stringWithFormat:@"%@(%@) vs %@(%@)",
                              self.firstPower, self.firstArmor, self.secondPower, self.secondArmor];
        self.displayLabel.text = [NSString stringWithFormat:@"%@", *self.currentInputing];
    }
    else{
        
        self.titleLabel.text = [NSString stringWithFormat:@"%@(%@) vs %@(%@) = %@(%@) vs %@(%@) ",
                              self.firstPower, self.firstArmor, self.secondPower, self.secondArmor,
                              self.resultFirstPower, self.resultSecondPower, self.resultFirstArmor, self.resultSecondArmor
                              ];
        self.displayLabel.text = [NSString stringWithFormat:@"%d", self.income];
    }
}

- (void)calc {
    
    self.resultFirstPower = self.firstPower;
    self.resultFirstArmor = self.firstArmor;
    self.resultSecondPower = self.secondPower;
    self.resultSecondArmor = self.secondArmor;
    self.income = 2;
   
    BOOL firstAttack = YES;
    while ([self.resultFirstPower integerValue] != 0 && [self.resultSecondPower integerValue] != 0) {
        NSNumber* attackPower = firstAttack ? self.firstPower : self.secondPower;
        NSNumber* attackedPower = firstAttack ? self.secondPower : self.firstPower;
        NSNumber* attackedArmor = firstAttack ? self.secondArmor : self.firstArmor;
        
        NSInteger attackPowerNum = [attackPower integerValue];
        NSInteger attackedArmorNum = [attackedArmor integerValue];
        NSInteger attackedPowerNum = [attackedPower integerValue];
        if(attackPowerNum <= attackedArmorNum){
            attackedArmor = @(attackedArmorNum - attackPowerNum);
        }
        else{
            attackedArmor = @(0);
            attackPowerNum -= attackedArmorNum;
            if(attackedPowerNum >= attackPowerNum){
                attackedPower = @(attackedPowerNum - attackPowerNum);
                self.income += attackPowerNum;
            }
            else{
                attackedPower = @(0);
                self.income += attackedPowerNum;
            }
        }
        
        firstAttack = !firstAttack;
    }
    
    self.calced = YES;
    [self updateDisplay];
    
    
}

- (void)setUpViews {
    
    CGFloat topPartHeight = 250;
    UIView* bgView = View.bgColor(@"black").addTo(self.view);
    self.displayLabel = Label.fnt(50).str("0").bgColor(@"black").color(@"white").rightAlignment.addTo(bgView);
    self.titleLabel = Label.fnt(35).str("please input").bgColor(@"black").color(@"white").addTo(bgView);
 
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(topPartHeight));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(@30);
        make.height.equalTo(@(100));
    }];
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.displayLabel.superview);
    }];
    
    
    __weak typeof(self) wSelf = self;
    
    
    CGFloat buttonWidth = self.view.bounds.size.width / 4, buttonHeight = (self.view.bounds.size.height - topPartHeight) / 4;
    int rowIndex = 0;
    int ColumnIndex= 0;
    
    NSArray* numArray = @[@(7),@(8),@(9),@(4),@(5),@(6),@(1),@(2),@(3),@(0)];
    for(int i = 0; i <= 9; i++){
       
        rowIndex = i / 3;
        ColumnIndex = i % 3;
        
        NSLog(@"%d, %d", rowIndex, ColumnIndex);
        
        UIButton* button = Button.addTo(self.view);
        button.tag = [[numArray objectAtIndex:i] integerValue];
        NSString* text = [NSString stringWithFormat:@"%d", button.tag];
        button.str(text).fnt(25).color(@"black").border(1, @"black");
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(buttonWidth));
            make.height.equalTo(@(buttonHeight));
            make.left.mas_equalTo(ColumnIndex * buttonWidth);
            make.top.mas_equalTo(topPartHeight + rowIndex * buttonHeight);
        }];
        
        [button bk_addEventHandler:^(id sender) {
            UIButton* senderButton = (UIButton*)sender;
            NSInteger num = senderButton.tag;
            if(wSelf.currentInputing){
                *wSelf.currentInputing = @([*wSelf.currentInputing integerValue] * 10 + num);
            }
            if(wSelf.calced){
                wSelf.calced = NO;
                [wSelf clear];
            }
            [wSelf updateDisplay];
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
   
    UIButton* clearButton = Button.fnt(25).color(@"white").bgColor(@"orange").addTo(self.view).str(@"C").border(1, @"black");
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth * 2));
        make.height.equalTo(@(buttonHeight));
        make.left.mas_equalTo(buttonWidth);
        make.top.mas_equalTo(topPartHeight + 3 * buttonHeight);
    }];
    [clearButton bk_addEventHandler:^(id sender) {
        [wSelf clear];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* armorButton = Button.fnt(25).color(@"white").bgColor(@"orange").addTo(self.view).str(@"armor").border(1, @"black");
    [armorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
        make.left.mas_equalTo(buttonWidth * 3);
        make.top.mas_equalTo(topPartHeight);
    }];
    [armorButton bk_addEventHandler:^(id sender) {
        if(*self.currentInputing == self.firstPower){
            *self.currentInputing = self.firstArmor;
        }
        if(*self.currentInputing == self.secondPower){
            *self.currentInputing = self.secondArmor;
        }
        [wSelf updateDisplay];
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* vsButton = Button.fnt(25).color(@"white").bgColor(@"orange").addTo(self.view).str(@"vs").border(1, @"black");
    [vsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
        make.left.mas_equalTo(buttonWidth * 3);
        make.top.mas_equalTo(topPartHeight + buttonHeight);
    }];
    [vsButton bk_addEventHandler:^(id sender) {
        *wSelf.currentInputing = wSelf.secondPower;
        [wSelf updateDisplay];
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* calcButton = Button.fnt(25).color(@"white").bgColor(@"orange").addTo(self.view).str(@"=").border(1, @"black");
    [calcButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight * 2));
        make.left.mas_equalTo(buttonWidth * 3);
        make.top.mas_equalTo(topPartHeight + buttonHeight * 2);
    }];
    [calcButton bk_addEventHandler:^(id sender) {
        [wSelf calc];
    } forControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
