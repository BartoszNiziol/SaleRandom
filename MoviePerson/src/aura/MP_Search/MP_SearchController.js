/**
 * Created by BRITENET on 07.04.2021.
 */
({
   initSearch: function (component,event,helper) {
        console.log('Start initSearch');
        let createEvent = $A.get("e.c:MP_SearchEvent");
        let searchString = component.get('v.searchString');
        let selectedOption = component.get('v.selectedOption');
        createEvent.setParam('searchString',searchString);
        createEvent.setParam('selectedOption',selectedOption);
         console.log(  createEvent.getParam('searchString'));
       createEvent.fire();
       component.set('v.showResultList',true);
       component.set('v.showActorDesc',false);
       component.set('v.showMovieDesc',false);
   },
   showActor:function (component,event,helper){
        component.set('v.showResultList',false);
        component.set('v.showActorDesc',true);
        component.set('v.showMovieDesc',false);
   },
   showMovie:function (component,event,helper){
       component.set('v.showResultList',false);
       component.set('v.showActorDesc',false);
       component.set('v.showMovieDesc',true);
   }


});