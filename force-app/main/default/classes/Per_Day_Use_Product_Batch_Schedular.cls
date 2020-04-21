global class Per_Day_Use_Product_Batch_Schedular implements Schedulable {
    global void execute(SchedulableContext SC) {
      Per_Day_Use_Product_Batch PDUPB = new Per_Day_Use_Product_Batch();
      Database.executebatch(PDUPB);
   }
}
/*
Per_Day_Use_Product_Batch_Schedular PDUPB = new Per_Day_Use_Product_Batch_Schedular();
String date11 = '0 0/5 * 1/1 * ? *';
system.schedule('Every Day 11:50 Min Batch Schedule', date11, PDUPB);
*/