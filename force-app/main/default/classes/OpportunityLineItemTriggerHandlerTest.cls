@isTest
public class OpportunityLineItemTriggerHandlerTest {

@testSetUp
static void setUpData(){

    Id pricebookId = Test.getStandardPricebookId();
    Pricebook2 standardPricebook = new Pricebook2(
        Id = pricebookId,
        IsActive = true
    );
    update standardPricebook;
    List<Product2> prodList = new List<Product2>();
    for (Integer i = 0; i < 3; i++) {
        Product2 prod = new Product2(Name = 'P'+ i, ProductCode = 'P' + i, IsActive = true);
        prodList.add(prod);
    }
    insert prodList;
    List<Stock_Count__c> scList = new List<Stock_Count__c>();
    for (Integer i = 0; i < 3; i++) {
        Stock_Count__c sc = new Stock_Count__c(Product__c = prodList[i].Id, StockCount__c = 10 + i);
        scList.add(sc);
    }
    insert scList;
    List<PricebookEntry> pBookEntryList = new List<PricebookEntry>();
    for (Integer i = 0; i < 3; i++) {
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = standardPricebook.Id, 
                                                Product2Id = prodList[i].Id, Unitprice = 10, isActive = true);
        pBookEntryList.add(pbe);
    }
    Account acc = new Account(Name = 'Test');
    insert acc;

    Opportunity opp = new Opportunity(Name = 'Opp1', CloseDate = Date.newInstance(2025, 1, 8), 
                    AccountId = acc.Id, Pricebook2Id = standardPricebook.Id, StageName = 'Prospecting' );
    insert opp;
    opp = new Opportunity(Name = 'Opp2', CloseDate = Date.newInstance(2024, 2, 3), 
        AccountId = acc.Id, Pricebook2Id = standardPricebook.Id, StageName = 'Prospecting');
    insert opp;
}

@isTest
    public static void PositiveTest(){ 
        List<Opportunity> oppList = [SELECT Id, Name FROM Opportunity ];
        List<Stock_Count__c> sc = [SELECT Id, Product__c, StockCount__c FROM Stock_Count__c];
        List<OpportunityLineItem> oppitList = new List<OpportunityLineItem>();
        PricebookEntry pbe = [SELECT IdFROM PricebookEntry WHERE Product2Id =: sc[0].Product__c];
        Decimal num = 0;
        for (Integer i = 1; i <= sc[0].StockCount__c; i++) {
            num +=1;
            OpportunityLineItem oppit = new OpportunityLineItem (
            OpportunityId = oppList[0].Id, Product2Id = sc[0].Product__c, Quantity = 1, TotalPrice=10);
            oppitList.add(oppit);
        }
        System.assertEquals((Decimal)sc[0].StockCount__c, num);
        Test.startTest();
        insert oppitList;
        Test.stopTest();
    }



}