/**
 * Created by BRITENET on 08.04.2021.
 */
 ({
 loadApperances: function (component,event,helper){
      console.log('Appearances');
         console.log('MAIN');
        let externalId = event.getParam("selectedId");
        let action;
        action = component.get("c.findPersonAppearances");
        action.setParam('externalId',externalId);

        action.setCallback(this,function(response){
            let state  = response.getState();
            console.log(state);
            if(state  == "SUCCESS"){
                console.log('Appearances');
                 console.log(response.getReturnValue());
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
                let selectedRowId = event.target.id;
                createEvent.setParam('selectedId',selectedRowId);
                createEvent.fire();
                  component.set('v.componentEnabled',false);

        }

    });