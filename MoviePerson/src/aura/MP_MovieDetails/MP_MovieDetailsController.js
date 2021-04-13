/**
 * Created by BRITENET on 09.04.2021.
 */
 ({
 loadDescription: function (component,event,helper){

         let externalId = event.getParam("selectedId");
        let action;
        action = component.get("c.findMovieDetails");
        action.setParam('externalId',externalId);

        action.setCallback(this,function(response){
            let state  = response.getState();
            if(state  == "SUCCESS"){
                 component.set('v.movieDetailsWrapper', response.getReturnValue());
                 component.set('v.componentEnabled',true);

                  let path = component.get("v.movieDetailsWrapper.backdropPath");

                                             if (path != null){
                                              if(path.startsWith('http')){
                                                  component.set('v.internalPath',true);
                                              }
                                              }

            }
        });
        $A.enqueueAction(action);
    },
     hideComponent: function(component,event,helper){
            component.set('v.componentEnabled',false);
        }
    });