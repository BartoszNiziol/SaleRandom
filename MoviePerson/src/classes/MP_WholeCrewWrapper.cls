/**
 * Created by BRITENET on 12.04.2021.
 */

public with sharing class MP_WholeCrewWrapper {
    @auraEnabled
    public List<MP_ProfileWrapper> crew { get; set; }
    @auraEnabled
    public List<MP_ProfileWrapper> casts { get; set; }

    public MP_WholeCrewWrapper  (List<MP_ProfileWrapper> crew, List<MP_ProfileWrapper> casts){
        this.crew = crew;
        this.casts = casts;
    }


}