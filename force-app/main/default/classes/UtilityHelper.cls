public class UtilityHelper {
    
    /** Method name : getDescribeSObjectResultFromId
     * Arguments : Id recordId
     * Return type : Schema.DescribeSObjectResult
     * Description : Returns the describe information about the passed record id
    **/
    public static Schema.DescribeSObjectResult getDescribeSObjectResultFromId(Id recordId){
        Schema.SObjectType token = recordId.getSObjectType();
        return token.getDescribe();
    }
    
}