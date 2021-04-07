/**
 * Created by BRITENET on 07.04.2021.
 */

public with sharing class MP_WholeResultWrapper {
    @AuraEnabled
    public List<MP_SingleResultWrapper> wrappedSingles { get; set; }
    @AuraEnabled
    public Integer page { get; set; }
    @AuraEnabled
    public Integer totalPages { get; set; }
    @AuraEnabled
    public Integer totalResults { get; set; }

}