/* **************************************************************
// Creater: Alexander Faust
// Description: gives rollup summary functionality on lookup-relationships
// Testclass: No specific testclass. Currently tested via Kreditor_afterAllTest
// Apex Class Access: no limitations
// Last modified by: Alexander Faust
// Last modified date: 06.12.2012
// Latests changes: creation
// ************************************************************** */


public class RollUpSummaryUtility {
     
    //the following class will be used to house the field names
    //and desired operations
    public class fieldDefinition {
        public String operation {get;set;}
        public String childField {get;set;}
        public String parentField {get;set;}
         
        public fieldDefinition (String o, String c, String p) {
            operation = o;
            childField = c;
            parentField = p;
        }
    }
     
    public static void rollUpTrigger(list<fieldDefinition> fieldDefinitions,
    list<sObject> records, String childObject, String childParentLookupField, 
    String parentObject, String queryFilter) {
         
        //Limit the size of list by using Sets which do not contain duplicate
        //elements prevents hitting governor limits
        set<Id> parentIds = new set<Id>();
         
        for(sObject s : records) {
            parentIds.add((Id)s.get(childParentLookupField));
        }
         
        //populate query text strings to be used in child aggregrator and 
        //parent value assignment
        String fieldsToAggregate = '';
        String parentFields = '';
         
        for(fieldDefinition d : fieldDefinitions) {
            fieldsToAggregate += d.operation + '(' + d.childField + ') ' + 
            ', ';
            parentFields += d.parentField + ', ';
        }
         
        //Using dynamic SOQL with aggergate results to populate parentValueMap
        String aggregateQuery = 'Select ' + fieldsToAggregate + 
        childParentLookupField + ' from ' + childObject + ' where  ' + 
        childParentLookupField + ' IN :parentIds ' + queryFilter + ' ' +
        ' group by ' + childParentLookupField;
         
        //Map will contain one parent record Id per one aggregate object
        map<Id, AggregateResult> parentValueMap = 
        new map <Id, AggregateResult>();
         
        for(AggregateResult q : Database.query(aggregateQuery)){
            parentValueMap.put((Id)q.get(childParentLookupField), q);
        }
         
        //list of parent object records to update
        list<sObject> parentsToUpdate = new list<sObject>();
         
        String parentQuery = 'select ' + parentFields + ' Id ' +
         ' from ' + parentObject + ' where Id IN :parentIds';
         
        //for each affected parent object, retrieve aggregate results and 
        //for each field definition add aggregate value to parent field
        for(sObject s : Database.query(parentQuery)) {
             
            Integer row = 0; //row counter reset for every parent record
            for(fieldDefinition d : fieldDefinitions) {
                String field = 'expr' + row.format();
                AggregateResult r = parentValueMap.get(s.Id);
                //r will be null if no records exist 
                //(e.g. last record deleted)
                if(r != null) { 
                    Decimal value = ((Decimal)r.get(field) == null ) ? 0 : 
                        (Decimal)r.get(field);
                    s.put(d.parentField, value);
                } else {
                    s.put(d.parentField, 0);
                }
                row += 1; //plus 1 for every field definition after first
            }
            parentsToUpdate.add(s);
        }
         
        //if parent records exist, perform update of all parent records 
        //with a single DML statement
        if(parentsToUpdate.Size() > 0) {
        	//Database.Saveresult result = new Database.Saveresult();
        	/*List<Database.Saveresult> listResult = new List<Database.Saveresult>();
        	listResult = Database.update(parentsToUpdate);
        	
        	for(Database.SaveResult sr:listResult){
   				if(!sr.isSuccess())
      				records[0].addError = sr.getErrors()[0];
			}*/
        	
            update parentsToUpdate;
        }
         
    }
 
}

/*
*****************************How to use***************************************

RollUpSummaryUtility.rollUpTrigger(fieldDefinitions, records, childObject, 
childParentLookupField, parentObject, queryFilter);

fieldDefinitions (list<RollUpSummaryUtility.fieldDefinition>) – The list of field definitions. 
 The fieldDefinition class is comprised of three variables:

operation (String) – Can be either SUM, MAX, MIN, or COUNT. When using COUNT, the childField must ALWAYS be ‘ID’.
childField (String) – The api name for the child object’s field that contains the values you wish to summarize. Remember, when using the COUNT operation, the value for this variable must ALWAYS be ‘ID’.
parentField (String) – The api name for the parent object’s field that where the summarized value of the child object field will be stored.

records (list<sObject>) – The list of records being passed to the utility. When using with a trigger this can either be trigger.new or trigger.old. 
Tip: Use trigger.old when executing during a trigger.isDelete operation.

childObject (String) – The API name for the child object. This object must have either a look-up or master-detail relationship to a parent object.

childParentLookupField (String) – The API name for the child object field that performs a look-up to a parent object where the summary results will be stored.

parentObject (String) – The API name for the parent object related to the child object. The childParentLookupField variable must be related to the object supplied in this variable.

queryFilter (String) – An SOQL statement that will be used to filter the child object records. The string must always begin with ‘and’ if it’s being used. If no filter is needed simply supply an empty text value of ”, never supply a NULL value. 
*/