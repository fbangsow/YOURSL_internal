public interface ITrigger
{
    void bulkBefore();
    void bulkAfter();
    void beforeInsert(SObject so);
    void beforeUpdate(SObject old_so, SObject so);
    void beforeDelete(SObject so);
    void afterInsert(SObject so);
    void afterUpdate(SObject old_so, SObject so);
    void afterDelete(SObject so);
    void postProcessing();
}