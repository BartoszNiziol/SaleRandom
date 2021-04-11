/**
 * Created by BRITENET on 11.04.2021.
 */
({
   openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   },

   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"
      component.set("v.isOpen", false);
   },

   likenClose: function(component, event, helper) {
      // Display alert message on the click on the "Like and Close" button from Model Footer
      // and set set the "isOpen" attribute to "False for close the model Box.
      alert('Received person add request');
      component.set("v.isOpen", false);
   },
})