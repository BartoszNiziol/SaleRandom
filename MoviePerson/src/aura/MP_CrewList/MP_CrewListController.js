/**
 * Created by BRITENET on 09.04.2021.
 */
 ({
 loadCrew: function (component,event,helper){
        let externalId = event.getParam("selectedId");
        let action;
        action = component.get("c.findCast");
        action.setParam('externalId',externalId);
        action.setCallback(this,function(response){
            let state  = response.getState();
            if(state  == "SUCCESS"){
                 console.log(response.getReturnValue());
                 component.set('v.crewWrapper', response.getReturnValue());
                  component.set('v.componentEnabled',true);
            }
        });
        $A.enqueueAction(action);
    },
    loadCast: function (component,event,helper){
            let externalId = event.getParam("selectedId");
            let action;
            action = component.get("c.findCrew");
            action.setParam('externalId',externalId);
            action.setCallback(this,function(response){
                let state  = response.getState();
                console.log(state);
                if(state  == "SUCCESS"){
                     console.log(response.getReturnValue());
                     component.set('v.wholeWrapper', response.getReturnValue());
                 console.log(component.get('v.wholeWrapper.cast'));
                      component.set('v.componentEnabled',true);
                }
            });
            $A.enqueueAction(action);
        },


    hideComponent: function(component,event,helper){
        component.set('v.componentEnabled',false);
    },
    sendSelected: function (component,event,helper){
              let  createEvent = $A.get("e.c:MP_SelectPersonEvent");
                let selectedRowId =  event.getParam('selectedId');
                createEvent.setParam('selectedId',selectedRowId);
                createEvent.fire();
                  component.set('v.componentEnabled',false);



        }

    });