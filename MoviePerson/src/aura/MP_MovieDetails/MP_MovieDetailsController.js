/**
 * Created by BRITENET on 09.04.2021.
 */
 ({
 loadDescription: function (component,event,helper){

         let externalId = event.getParam("selectedId");
        let action;
        action = component.get("c.findMovieDetails");
        action.setParam('externalId',externalId);

        action.setCallback(this,function(response){
            let state  = response.getState();
            console.log(state);
            if(state  == "SUCCESS"){
                 console.log(response.getReturnValue());
                 component.set('v.movieDetailsWrapper', response.getReturnValue());
                 component.set('v.componentEnabled',true);
            }
        });
        $A.enqueueAction(action);
    },
     hideComponent: function(component,event,helper){
            component.set('v.componentEnabled',false);
        }
    });