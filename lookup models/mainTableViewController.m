//
//  mainTableViewController.m
//  RaniaArbash'sProject
//
//  Created by Rania on 2016-12-15.
//  Copyright © 2016 Rania. All rights reserved.
//

#import "mainTableViewController.h"
#import "RaniaArbash_sProject-Swift.h"
#import "StockName+CoreDataClass.h"
#import "Symbol+CoreDataClass.h"
#import "searchTableViewController.h"
#import "AppDelegate.h"
#import "StockDetialsViewController.h"


@interface mainTableViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate>


@property (nonatomic)YahooLookUpModel* myModel;
@property (nonatomic) searchTableViewController* searchController;
@property NSManagedObjectContext* mainViewContext;
@property (strong, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic) NSMutableSet* symbolsSet;
@property (nonatomic) NSMutableSet* stocksSet;
@property (nonatomic) NSMutableArray* searchResults;
@property (strong , nonatomic) UISearchController* searchbarController;
@property (strong , nonatomic) NSMutableArray* cells;
@end

@implementation mainTableViewController

-(NSMutableSet*) symbolsSet{

    if(_symbolsSet == nil)
        _symbolsSet = [[NSMutableSet alloc]init];
    
    return _symbolsSet;
}

-(NSMutableSet*) stocksSet{
    if (_stocksSet == nil)
        _stocksSet = [[NSMutableSet alloc]init];
    
    return _stocksSet;

}


-(NSMutableArray*) cells{
    if (_cells == nil)
        _cells = [[NSMutableArray alloc]init];
    
    return _cells;
    
}
-(UISearchController*) searchbarController{
    if (_searchbarController == nil){
        _searchbarController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchbarController.searchResultsUpdater = self;
        _searchbarController.dimsBackgroundDuringPresentation = NO;
        _searchbarController.delegate = self;
        _searchbarController.searchBar.delegate = self;
    }
    return _searchbarController;

}

-(NSMutableArray*) searchResults{
    if (_searchResults == nil)
        _searchResults = [[NSMutableArray alloc]init];
    return _searchResults;
    
}

-(searchTableViewController*) searchController{
    if (_searchController == nil)
        _searchController = [[searchTableViewController alloc]init];
    
    return _searchController;

}

-(YahooLookUpModel*)myModel{
    
    if (_myModel == nil){
        _myModel = [[YahooLookUpModel alloc]init];
        
        
    }
    return _myModel;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
      
        
        UITableViewCell* deletedCell = [self.mainTable cellForRowAtIndexPath:indexPath];
        NSString* deletedSymbol = deletedCell.textLabel.text;
        NSString* deletedStock = deletedCell.detailTextLabel.text;
        
        for (Symbol* s in self.symbolsSet){
            if (s.symbolName == deletedSymbol){
                [self.mainViewContext deleteObject:s];
                [self.symbolsSet removeObject:s];
                NSLog(@"symbol %@", s.symbolName);

                break;
            }
                
        }
        
        
        for (StockName* sn in self.stocksSet){
            if (sn.name == deletedStock){
                [self.mainViewContext deleteObject:sn];
                [self.stocksSet removeObject:sn];
                NSLog(@"stock %@", sn.name);
                break;
            }
        }
        NSError* error = nil;

        if (![self.mainViewContext save:&error]){
                NSLog(@"couldn't delete ");
        }
        
        [self.mainTable reloadData];
    }
}



- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString* searchText = searchController.searchBar.text;
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"symbolName CONTAINS[c] %@" ,searchText];
    NSArray* symbolTableData = [[NSArray alloc]init];
    
    symbolTableData = [self.symbolsSet allObjects];
    
    self.searchResults = [[symbolTableData filteredArrayUsingPredicate:resultPredicate]mutableCopy];
    [self.mainTable reloadData];
    NSLog(@"in search ");

}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor blueColor]];
    
    AppDelegate* appdelegat = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.mainViewContext = appdelegat.persistentContainer.viewContext;
    self.mainTable.tableHeaderView = self.searchbarController.searchBar;
    self.definesPresentationContext= YES;
   }


-(void)viewDidAppear:(BOOL)animated{
    [self.mainTable reloadData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (self.searchbarController.active)
        return self.searchResults.count;
    else{
        
    NSFetchRequest* fetch1 = [NSFetchRequest fetchRequestWithEntityName:@"Symbol"];
        NSError* error = nil;
        NSUInteger count = [self.mainViewContext countForFetchRequest:fetch1 error:&error];
        if (!error)
            return count;
        else
            return 0;
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    
    if (self.searchbarController.active)
    {
        NSString* m = [[self.searchResults objectAtIndex:indexPath.row]symbolName];
        for (int i = 0; i < self.cells.count; i++) {
            
            NSString* ss = [[[self.cells objectAtIndex:i]textLabel]text];
            if (ss == m) {
                NSString* k = [[[self.cells objectAtIndex:i]detailTextLabel]text];
                cell.detailTextLabel.text = k;
                break;
            }
        }
 
        cell.textLabel.text = m;

        
    }
    else
    {
    
    NSFetchRequest* fetch1 = [NSFetchRequest fetchRequestWithEntityName:@"Symbol"];
    NSFetchRequest* fetch2 = [NSFetchRequest fetchRequestWithEntityName:@"StockName"];

    NSError* error = nil;
    NSArray* symbolsResults = [self.mainViewContext executeFetchRequest:fetch1 error:&error];
    if (!symbolsResults){
        NSLog(@"error");
    }
    else{
        Symbol* s = (Symbol*)symbolsResults[indexPath.row];
        [self.symbolsSet addObject:s];
        
        cell.textLabel.text = s.symbolName;
    }
    NSArray* stockResults = [self.mainViewContext executeFetchRequest:fetch2 error:&error];
    if (!stockResults){
        NSLog(@"error");
    }
    else{
        StockName* sn = (StockName*)stockResults[indexPath.row];
        [self.stocksSet addObject:sn];
        cell.detailTextLabel.text = sn.name;
        
    }
        [self.cells addObject:cell];

}
    
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (self.searchbarController.active){
        if ([segue.identifier isEqualToString:@"detailsSegue"]){
            NSIndexPath* ip =self.mainTable.indexPathForSelectedRow;
            NSString* selectedSymbol = [self.mainTable cellForRowAtIndexPath:ip].textLabel.text;
            StockDetialsViewController* svc = (StockDetialsViewController*)[segue destinationViewController];
            svc.selectedSymbolName = selectedSymbol;
        }

        
    
    }
    else{
    if ([segue.identifier isEqualToString:@"first"]){
        searchTableViewController* nextTable = (searchTableViewController*)[segue destinationViewController];
        nextTable.context = self.mainViewContext;
    }
    else if ([segue.identifier isEqualToString:@"detailsSegue"]){
        NSIndexPath* ip =self.mainTable.indexPathForSelectedRow;
        NSString* selectedSymbol = [self.mainTable cellForRowAtIndexPath:ip].textLabel.text;
        StockDetialsViewController* svc = (StockDetialsViewController*)[segue destinationViewController];
        svc.selectedSymbolName = selectedSymbol;
    }
    }
    
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
