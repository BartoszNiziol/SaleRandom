/**
 * Created by BRITENET on 07.04.2021.
 */
({
   initSearch: function (component,event,helper) {

        let createEvent = $A.get("e.c:MP_SearchEvent");
        let searchString = component.get('v.searchString');
        let selectedOption = component.get('v.selectedOption');
        createEvent.setParam('searchString',searchString);
        createEvent.setParam('selectedOption',selectedOption);

       createEvent.fire();

   }
});