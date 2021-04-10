/**
 * Created by BRITENET on 08.04.2021.
 */
({
    request: function (component,event,helper){
        let searchString = component.get('v.searchString');
        let currentPage = component.get('v.currentPage');
        let selectedOption = component.get('v.selectedOption');
            let action;
        if(selectedOption == 1){
            action = component.get("c.findPeoples")
        }else{
           action = component.get("c.findMovies");
        }

        action.setParam('search',searchString);
        action.setParam('currentPage',currentPage);
        action.setCallback(this,function(response){
            let state  = response.getState();
            if(state  == "SUCCESS"){
                 component.set('v.listedWrappedItems', response.getReturnValue());
                 component.set('v.componentEnabled',true);
            }
        });
        $A.enqueueAction(action);
    },

    requestZero: function (component,event,helper){
       let searchString = event.getParam("searchString");
       let selectedOption = event.getParam("selectedOption");

       component.set('v.selectedOption',selectedOption);
       component.set('v.searchString',searchString); 
      component.set('v.currentPage',1);

      $A.enqueueAction(component.get('c.request'));

    },

    requestPlusOne: function (component,event,helper){
        let currentPage = component.get('v.currentPage');
        component.set('v.currentPage',currentPage + 1);
          $A.enqueueAction(component.get('c.request'));
    },

    requestMinusOne: function (component,event,helper){
      let currentPage = component.get('v.currentPage');
        component.set('v.currentPage',currentPage -1 );
          $A.enqueueAction(component.get('c.request'));
    },

   sendSelected: function (component,event,helper){
            let createEvent;
        let selectedOption = component.get('v.selectedOption');
        if(selectedOption == 1){
                    createEvent = $A.get("e.c:MP_SelectPersonEvent");
               }else{
                  createEvent = $A.get("e.c:MP_SelectMovieEvent");
               }
            let selectedRowId = event.getParam('selectedId');

            createEvent.setParam('selectedId',selectedRowId);
            createEvent.fire();
              component.set('v.componentEnabled',false);
    }

});