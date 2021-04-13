/**
 * Created by BRITENET on 08.04.2021.
 */
 ({
 loadDescription: function (component,event,helper){

         let externalId = event.getParam("selectedId");
        let action;
        action = component.get("c.findPersonProfile");
        action.setParam('externalId',externalId);

        action.setCallback(this,function(response){
            let state  = response.getState();
            if(state  == "SUCCESS"){
                 component.set('v.profileWrapper', response.getReturnValue());
                 component.set('v.componentEnabled',true);

                let path = component.get("v.profileWrapper.profilePath");


                            if (path != null){
                             if(path.startsWith('http')){
                                 component.set('v.internalPath',true);
                             }
                             }
            }
        });
        $A.enqueueAction(action);
    },
     hideComponent: function(component,event,helper){
            component.set('v.componentEnabled',false);
        },

//        checkLink:function(component,event,helper){
//           let path component.get("v.profileWrapper.profile.profilePath");
//           if (path != null){
//            if(path.startsWith('http')){
//                component.set('v.internalPath',true);
//            }
//            }
//
//
//        }


    });