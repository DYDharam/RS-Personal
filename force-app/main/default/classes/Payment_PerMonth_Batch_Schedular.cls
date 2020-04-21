global class Payment_PerMonth_Batch_Schedular implements Schedulable{
   global void execute(SchedulableContext SC) {
      Payment_PerMonth_Batch PPB = new Payment_PerMonth_Batch();
      Database.executebatch(PPB);
   }
}
/*
Payment_PerMonth_Batch_Schedular PPB = new Payment_PerMonth_Batch_Schedular();
//String date11 = '0 0 1 1 1/1 ? *';
String date11 = '0 0 1 1/1 * ? *';
system.schedule('In a month Calculate All Customer Details Bill', date11, PPB);
*/