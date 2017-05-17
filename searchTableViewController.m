//
//  searchTableViewController.m
//  RaniaArbash'sProject
//
//  Created by Rania on 2016-12-15.
//  Copyright © 2016 Rania. All rights reserved.
//


#import "searchTableViewController.h"
#import "RaniaArbash_sProject-Swift.h"
#import "StockName+CoreDataClass.h"
#import "Symbol+CoreDataClass.h"

@interface searchTableViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource, YahooSearchDelegate>
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;

@property (nonatomic) NSArray* searchResult;
@property (nonatomic)YahooLookUpModel* myModel;

@end

@implementation searchTableViewController

-(void)SearchDidFinishWithResultWithResult:(NSArray *)result{
    self.searchResult = result;
    [self.searchTableView reloadData];
    


}
-(void) SearchDidFinishWithResult :(NSArray*) result{
    
    self.searchResult = result;
    
}

-(void)searchFinished{
    
    NSLog(@"finish here");
    
}

-(YahooLookUpModel*)myModel{

    if(_myModel == nil){
        _myModel = [[YahooLookUpModel alloc]init];
        _myModel.delegat = self;
    }
    return  _myModel;
}



- (void)viewDidLoad {
    [super viewDidLoad];
//
  //AppDelegate* appdelegat = (AppDelegate*)[UIApplication sharedApplication].delegate;
  //self.context = appdelegat.persistentContainer.viewContext;
    
    
//    
//     Uncomment the following line to preserve selection between presentations.
//     self.clearsSelectionOnViewWillAppear = NO;
//    
//     Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{   // called when text changes (including clear)
    [self.myModel lookUpForSymbolWithText:searchText];
    
}





-(BOOL)exist :(NSString*)symbolName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Symbol" inManagedObjectContext:self.context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setFetchLimit:1];
    [request setPredicate:[NSPredicate predicateWithFormat:@"symbolName == %@", symbolName]];
    
    NSError *error = nil;
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    
    if (count)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* symbol = cell.textLabel.text;
    NSString* stockname = cell.detailTextLabel.text;
    
    if (![self exist:symbol]){
    
        
    StockName* sn = [NSEntityDescription insertNewObjectForEntityForName:@"StockName" inManagedObjectContext:self.context];
    
    [sn setValue:stockname forKey:@"name"];
    
    Symbol* s = [NSEntityDescription insertNewObjectForEntityForName:@"Symbol" inManagedObjectContext:self.context];
    
    [s setValue:symbol forKey:@"symbolName"];
    
    
    
    NSError* error = [[NSError alloc]init];
    [self.context save:&error];
    NSLog(@"done");

    }
    
    [self dismissViewControllerAnimated:NO completion:nil];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [[self.searchResult objectAtIndex:indexPath.row]valueForKey:@"symbol"];
    cell.detailTextLabel.text =     cell.detailTextLabel.text = [[self.searchResult objectAtIndex:indexPath.row]valueForKey:@"name"];

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
