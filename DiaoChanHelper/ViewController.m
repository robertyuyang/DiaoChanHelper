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

@property (nonatomic) int firstPower;
@property (nonatomic) int secondPower;
@property (nonatomic) int firstArmor;
@property (nonatomic) int secondArmor;

@property (nonatomic) int* currentInputing;


@property (nonatomic)  int resultFirstPower;
@property (nonatomic) int resultSecondPower;
@property (nonatomic) int resultFirstArmor;
@property (nonatomic) int resultSecondArmor;
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
    self.firstPower = 0;
    self.firstArmor = 0;
    self.secondPower = 0;
    self.secondArmor = 0;
    self.currentInputing = &_firstPower;
    //NSLog(@"%p,%p,%@,%@", self.currentInputing, self.firstPower,self.currentInputing, self.firstPower);
    //self.firstPower = 2;
    //NSLog(@"%p,%p,%@,%@", self.currentInputing, self.firstPower,self.currentInputing, self.firstPower);
    
    self.displayLabel.str(@"0");
    [self updateDisplay];
}

- (void)updateDisplay {
    if(!self.calced){
        self.titleLabel.text = [NSString stringWithFormat:@"%d(%d) vs %d(%d)",
                              self.firstPower, self.firstArmor, self.secondPower, self.secondArmor];
        self.displayLabel.text = [NSString stringWithFormat:@"%d", *self.currentInputing];
    }
    else{
        
        self.titleLabel.text = [NSString stringWithFormat:@"%d(%d) vs %d(%d) = %d(%d) vs %d(%d) ",
                              self.firstPower, self.firstArmor, self.secondPower, self.secondArmor,
                              self.resultFirstPower, self.resultFirstArmor, self.resultSecondPower, self.resultSecondArmor
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
    while (self.resultFirstPower != 0 && self.resultSecondPower != 0) {
        int attackPower = firstAttack ? self.resultFirstPower : self.resultSecondPower;
        int* attackedPower = firstAttack ? &_resultSecondPower : &_resultFirstPower;
        int* attackedArmor = firstAttack ? &_resultSecondArmor : &_resultFirstArmor;
        
        int attackPowerNum = attackPower;
        int attackedArmorNum = *attackedArmor;
        int attackedPowerNum = *attackedPower;
        
        if(attackPowerNum <= attackedArmorNum){
            *attackedArmor = attackedArmorNum - attackPowerNum;
        }
        else{
            *attackedArmor = 0;
            attackPowerNum -= attackedArmorNum;
            if(attackedPowerNum >= attackPowerNum){
                *attackedPower = attackedPowerNum - attackPowerNum;
                self.income += attackPowerNum;
            }
            else{
                *attackedPower = 0;
                self.income += attackedPowerNum;
            }
        }
        
        firstAttack = !firstAttack;
        NSLog(@"%d(%d) vs %d(%d) - %d", self.resultFirstPower, self.resultFirstArmor, self.resultSecondPower, self.resultSecondArmor, self.income);
    }
    
    self.calced = YES;
    [self updateDisplay];
    
    
}

- (void)setUpViews {
    
    CGFloat topPartHeight = 250;
    UIView* bgView = View.bgColor(@"black").addTo(self.view);
    self.displayLabel = Label.fnt(50).str("0").bgColor(@"black").color(@"white").rightAlignment.addTo(bgView);
    self.titleLabel = Label.fnt(25).str("please input").bgColor(@"black").color(@"white").addTo(bgView);
 
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
            if(wSelf.calced){
                wSelf.calced = NO;
                [wSelf clear];
            }
            
            UIButton* senderButton = (UIButton*)sender;
            int num = senderButton.tag;
            if(wSelf.currentInputing){
                *wSelf.currentInputing = *wSelf.currentInputing * 10 + num;
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
        if(self.currentInputing == &_firstPower){
            self.currentInputing = &_firstArmor;
        }
        if(self.currentInputing == &_secondPower){
            self.currentInputing = &_secondArmor;
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
        wSelf.currentInputing = &_secondPower;
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
