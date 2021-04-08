/**
 * Created by BRITENET on 08.04.2021.
 */
 ({
 loadDescription: function (component,event,helper){
         console.log('MAIN');
//        let externalId = component.get('v.externalId');
            let externalId = '70851';
        let action;
        action = component.get("c.findPersonProfile");
        action.setParam('externalId','70851');

        action.setCallback(this,function(response){
            let state  = response.getState();
            console.log(state);
            if(state  == "SUCCESS"){
                 console.log(response.getReturnValue());
                 component.set('v.profileWrapper', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
    });