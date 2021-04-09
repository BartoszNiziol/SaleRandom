/**
 * Created by BRITENET on 09.04.2021.
 */
({
    fireSelect: function (component,event,helper){


                    let  createEvent = $A.get("e.c:MP_DirectPersonClickEvent");
                    let selectedRowId = component.get('v.externalId');

                    createEvent.setParam('selectedId',selectedRowId);

                    createEvent.fire();

            }
})