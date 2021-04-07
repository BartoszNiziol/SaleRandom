/**
 * Created by BRITENET on 07.04.2021.
 */

public with sharing class MoviesResultsWrapper {
    @AuraEnabled
    public List<MP_MovieResultWrapper> movies { get; set; }
    @AuraEnabled
    public Integer page { get; set; }
    @AuraEnabled
    public Integer totalPages { get; set; }
    @AuraEnabled
    public Integer totalResults { get; set; }
}