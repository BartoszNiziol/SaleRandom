/**
 * Created by BRITENET on 08.04.2021.
 */

public with sharing class MP_MovieDescriptionWrapper {

    public MP_MovieDescriptionWrapper(Boolean isAdult, String posterPath, String externalId, String title, String releaseDate, String productionCountries, String genres, Decimal rating) {
        this.isAdult = isAdult;
        this.posterPath = posterPath;
        this.externalId = externalId;
        this.title = title;
        this.releaseDate = releaseDate;
        this.productionCountries = productionCountries;
        this.genres = genres;
        this.rating = rating;
        if(releaseDate != null&& releaseDate != '') {
            this.year = releaseDate.split('-').get(0);
        }
    }

    @auraenabled
    public Boolean isAdult { get; set; }
    @auraenabled
    public String posterPath { get; set; }
    @auraenabled
    public String externalId { get; set; }
    @auraenabled
    public String title { get; set; }
    @auraenabled
    public String releaseDate { get; set; }
    @auraenabled
    public String productionCountries { get; set; }
    @auraenabled
    public String genres { get; set; }
    @auraenabled
    public Decimal rating { get; set; }
    @auraenabled
    public String year { get; set; }


}