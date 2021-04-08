/**
 * Created by BRITENET on 08.04.2021.
 */
 ({
 loadApperances: function (component,event,helper){
      console.log('Appearances');
         console.log('MAIN');
//        let externalId = component.get('v.externalId');
            let externalId = '70851';
        let action;
        action = component.get("c.findPersonAppearances");
        action.setParam('externalId','70851');

        action.setCallback(this,function(response){
            let state  = response.getState();
            console.log(state);
            if(state  == "SUCCESS"){
                console.log('Appearances');
                 console.log(response.getReturnValue());
                 component.set('v.appearancesWrapper', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
    });