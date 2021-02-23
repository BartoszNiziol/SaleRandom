/**
 * Created by BRITENET on 17.02.2021.
 */

public without sharing class HD_PlygroundController {

    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
    public Id parentId{get;set;}

    public HD_PlygroundController(ApexPages.StandardController standardController){
            parentId = standardController.getId();

    }

    public void  upload(){
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = parentId;
        attachment.Name ='ProfileImage';
        insert attachment;
        attachment = new Attachment();
    }
    public Id getImageId(){
        Id result = null;
        List<Attachment> images = [SELECT Id FROM Attachment WHERE Name = 'ProfileImage' AND ParentId= :parentId ORDER BY CreatedDate];
        if(images.size()>0)
        {
            result=images[0].Id;
        }
        return result;
    }

}


