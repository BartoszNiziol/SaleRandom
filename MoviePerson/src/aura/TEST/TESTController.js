/**
 * Created by BRITENET on 07.04.2021.
 */
({
    request: function (component,event,helper){
        console.log('Started');
        let action  = component .get("c.findMovies");
        action.setCallback(this,function(response){
            let state  = response.getState();
            if(state  == "SUCCESS"){
            }


        });

        $A.enqueueAction(action);


    }
})


