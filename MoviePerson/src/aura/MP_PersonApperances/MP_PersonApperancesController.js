/**
 * Created by BRITENET on 08.04.2021.
 */
 ({
 loadApperances: function (component,event,helper){
        let externalId = event.getParam("selectedId");
        let action;
        action = component.get("c.findPersonAppearances");
        action.setParam('externalId',externalId);
        action.setCallback(this,function(response){
            let state  = response.getState();
            if(state  == "SUCCESS"){
                 component.set('v.appearancesWrapper', response.getReturnValue());
                  component.set('v.componentEnabled',true);
            }
        });
        $A.enqueueAction(action);
    },
    hideComponent: function(component,event,helper){
        component.set('v.componentEnabled',false);
    },
    sendSelected: function (component,event,helper){

              let  createEvent = $A.get("e.c:MP_SelectMovieEvent");
                let selectedRowId = event.getParam('selectedId');
                createEvent.setParam('selectedId',selectedRowId);
                createEvent.fire();

                  component.set('v.componentEnabled',false);

        }

    });