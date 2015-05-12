public with sharing class TriggerFactory
{
    private static final Map<SObjectType, String> SOBJECT_TYPE_TO_CLASS_NAME = new Map<SObjectType, String>
    {
        OpportunityLineItem.SObjectType => 'OpportunityLineItemHandler'
    };

    public static void createHandler(Schema.SObjectType so_type)
    {
        ITrigger handler = getHandler(so_type);
        if (handler == null)
        {
            throw new TriggerException('No Trigger Handler registered for Object Type: ' + so_type);
        }
        execute(handler);
    }

    private static void execute(ITrigger handler)
    {
        if (Trigger.isBefore)
        {
            handler.bulkBefore();
            if (Trigger.isDelete)
            {
                for (SObject so : Trigger.old)
                {
                    handler.beforeDelete(so);
                }
            }
            else if (Trigger.isInsert)
            {
                for (SObject so : Trigger.new)
                {
                    handler.beforeInsert(so);
                }
            }
            else if (Trigger.isUpdate)
            {
                for (SObject so : Trigger.old)
                {
                    handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
        }
        else
        {
            handler.bulkAfter();
            if (Trigger.isDelete)
            {
                for (SObject so : Trigger.old)
                {
                    handler.afterDelete(so);
                }
            }
            else if (Trigger.isInsert)
            {
                for (SObject so : Trigger.new)
                {
                    handler.afterInsert(so);
                }
            }
            else if (Trigger.isUpdate)
            {
                for (SObject so : Trigger.old)
                {
                    handler.afterUpdate(so, Trigger.newMap.get(so.Id));
                }
            }
            handler.postProcessing();
        }
    }

    @TestVisible private static ITrigger getHandler(Schema.SObjectType so_type)
    {
        if(SOBJECT_TYPE_TO_CLASS_NAME.containsKey(so_type))
        {
            Type t = Type.forName(SOBJECT_TYPE_TO_CLASS_NAME.get(so_type));
            ITrigger sobject_handler = (ITrigger)t.newInstance();
            return sobject_handler;
        }
        return null;
    }

    public class TriggerException extends Exception {}
}