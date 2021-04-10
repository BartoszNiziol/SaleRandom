/**
 * Created by BRITENET on 09.04.2021.
 */
({
    fireSelect: function (component,event,helper){


                    let inSearch = component.get('v.inSearch');
                                         let  createEvent;
                                         if(inSearch){
                                              createEvent = $A.get("e.c:MP_DirectMovieClickEventInSearch");
                                         }else{
                                              createEvent = $A.get("e.c:MP_DirectMovieClickEvent");
                                         }
                                        let selectedRowId = component.get('v.externalId');
                                        createEvent.setParam('selectedId',selectedRowId);
                                        createEvent.fire();
            }
})