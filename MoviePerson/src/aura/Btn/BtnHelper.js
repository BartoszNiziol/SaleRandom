/**
 * Created by BRITENET on 07.04.2021.
 */
({
     request: function (component,event,helper){
             console.log('MAIN');
            let searchString = component.get('v.searchString');
            let currentPage = component.get('v.currentPage');
            console.log(searchString);
            let action  = component .get("c.findMovies");

            action.setParam('search',searchString);
            action.setParam('currentPage',currentPage);
               console.log(currentPage);
            action.setCallback(this,function(response){
                let state  = response.getState();
                console.log(state);
                if(state  == "SUCCESS"){
                     console.log(response.getReturnValue());
                     component.set('v.listedWrappedItems', response.getReturnValue());

                }
            });
            $A.enqueueAction(action);
        },
})