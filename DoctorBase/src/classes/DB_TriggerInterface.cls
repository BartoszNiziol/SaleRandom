/**
 * Created by BRITENET on 21.03.2021.
 */

public interface DB_TriggerInterface {

    void bulkBefore(List<sObject> newObjects, List<sObject> oldObjects,Schema.sObjectType soType);
    void bulkAfter(List<sObject> newObjects, List<sObject> oldObjects,Schema.sObjectType soType);

}