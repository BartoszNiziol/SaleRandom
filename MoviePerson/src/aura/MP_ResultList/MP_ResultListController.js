/**
 * Created by BRITENET on 08.04.2021.
 */
({
    request: function (component,event,helper){
         console.log('MAIN');
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
           console.log(currentPage);
        action.setCallback(this,function(response){
            let state  = response.getState();
            console.log(state);
            if(state  == "SUCCESS"){
                 console.log(response.getReturnValue());
                 component.set('v.listedWrappedItems', response.getReturnValue());
                 component.set('v.componentEnabled',true);
            }
        });
        $A.enqueueAction(action);
    },

    requestZero: function (component,event,helper){
        console.log('ZERO');

       let searchString = event.getParam("searchString");
       let selectedOption = event.getParam("selectedOption");

       component.set('v.selectedOption',selectedOption);
       component.set('v.searchString',searchString); 
      component.set('v.currentPage',1);

      $A.enqueueAction(component.get('c.request'));
       console.log('ZERO');

    },

    requestPlusOne: function (component,event,helper){
        console.log('PLUS');
        let currentPage = component.get('v.currentPage');
        component.set('v.currentPage',currentPage + 1);
          $A.enqueueAction(component.get('c.request'));
          console.log('PLUS');
    },

    requestMinusOne: function (component,event,helper){
        console.log('MINUS');
      let currentPage = component.get('v.currentPage');
        component.set('v.currentPage',currentPage -1 );
          $A.enqueueAction(component.get('c.request'));
          console.log('MINUS');
    },

   sendSelected: function (component,event,helper){
            let createEvent;
        let selectedOption = component.get('v.selectedOption');
        if(selectedOption == 1){
                    createEvent = $A.get("e.c:MP_SelectPersonEvent");
               }else{
                  createEvent = $A.get("e.c:MP_SelectMovieEvent");
               }
            let selectedRowId = event.target.id;
            createEvent.setParam('selectedId',selectedRowId);
            createEvent.fire();
              component.set('v.componentEnabled',false);
    }

});