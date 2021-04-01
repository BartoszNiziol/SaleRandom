/**
 * Created by BRITENET on 30.03.2021.
 */

public with sharing class ParkLocator {

    public static List <String> country (String country){
        ParkService.ParksImplPort parkservice =new ParkService.ParksImplPort();
        return parkservice.byCountry(country);
    }

}