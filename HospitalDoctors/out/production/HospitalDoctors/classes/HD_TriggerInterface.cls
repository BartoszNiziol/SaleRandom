/**
 * Created by BRITENET on 18.03.2021.
 */

public interface HD_TriggerInterface {
    void bulkBefore(List<sObject> newObjects, List<sObject> oldObjects);
    void bulkAfter(List<sObject> newObjects, List<sObject> oldObjects);
}