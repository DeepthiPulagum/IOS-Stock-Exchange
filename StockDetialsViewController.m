//
//  StockDetialsViewController.m
//  RaniaArbash'sProject
//
//  Created by Rania on 2016-12-21.
//  Copyright © 2016 Rania. All rights reserved.
//
#import "RaniaArbash_sProject-Swift.h"
#import "StockDetialsViewController.h"

@interface StockDetialsViewController ()<SymbolDetailsDelegate>

@property (weak, nonatomic) IBOutlet UILabel *symbolNameLable;
@property (weak, nonatomic) IBOutlet UILabel *askLable;
@property (weak, nonatomic) IBOutlet UILabel *changeLable;
@property (nonatomic) SymbolDetailsModel* myModel;


@end

@implementation StockDetialsViewController


-(SymbolDetailsModel*) myModel{

    if (_myModel == nil){
        _myModel = [[SymbolDetailsModel alloc]init];
        _myModel.delegat = self;
    }
    return _myModel;
    
}

- (IBAction)reload {
    
    [self.myModel lookUpForSymbolDetailsWithText:self.selectedSymbolName];

}


-(void) ModelDidFinishWithDetailsWithSymbole:(NSString *)symbole ask:(NSString *)ask change:(NSString *)change{

    self.symbolNameLable.text = symbole;
    self.askLable.text = ask;
    self.changeLable.text = change;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.title = @"Symbol Watch";
    [self.myModel lookUpForSymbolDetailsWithText:self.selectedSymbolName];
    
    
    // Do any additional setup after loading the view.
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
