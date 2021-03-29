/**
 * Created by BRITENET on 29.03.2021.
 */

public with sharing class HD_BatchLogWrapper {

    public HD_BatchLogWrapper(String recordId, String objectType, String status, String endpoint, Decimal statusCode, Datetime logCreationDate) {
        this.recordId = recordId;
        this.objectType = objectType;
        this.status = status;
        this.endpoint = endpoint;
        this.statusCode = statusCode;
        this.logCreationDate = logCreationDate;
    }

    public String recordId { get; set; }
    public String objectType { get; set; }
    public String status { get; set; }
    public Decimal statusCode { get; set; }
    public String endpoint { get; set; }
    public Datetime logCreationDate { get; Set; }


}