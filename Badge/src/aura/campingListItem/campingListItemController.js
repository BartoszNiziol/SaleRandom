({
    packItem: function(component, event, helper) {
        let item  = component.get("v.item",true);
        item.Packed__c = true ;
        component.set(v.item,item);
        event.getSource().set("v.disabled",true);

    }
})