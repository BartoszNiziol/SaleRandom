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
            }
        });
        $A.enqueueAction(action);
    },
     hideComponent: function(component,event,helper){
            component.set('v.componentEnabled',false);
        }
    });