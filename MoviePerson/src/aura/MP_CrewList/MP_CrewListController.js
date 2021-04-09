/**
 * Created by BRITENET on 09.04.2021.
 */
 ({
 loadCrew: function (component,event,helper){
        alert("crew");
        let externalId = event.getParam("selectedId");
        let action;
        action = component.get("c.findCrew");
        action.setParam('externalId',externalId);

        action.setCallback(this,function(response){
            let state  = response.getState();
            console.log(state);
            if(state  == "SUCCESS"){
                 console.log(response.getReturnValue());
                 component.set('v.crewWrapper', response.getReturnValue());
                  component.set('v.componentEnabled',true);
            }
        });
        $A.enqueueAction(action);
    },
    hideComponent: function(component,event,helper){
        component.set('v.componentEnabled',false);
    }

    });