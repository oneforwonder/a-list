function addRecipient(name, email)
{
    var recipients = Ext.get("recipients");
    var recipient = "<div class=\"recipient\" id=\"" + email + "\">";
    recipient += "<input type=\"hidden\" name=\"recipients[]\" value=\"" + email + "\" />";
    recipient += name;
    recipient += "</div>";
    recipients.insertHtml("beforeEnd", recipient);
}

function addUnknownRecipient(email)
{
    if(Ext.form.VTypes.email(email))
        addRecipient(email, email);
    else
    {
        Ext.get("unknown_recipient_message").update("We were unable to find a user named <b>" + email + "</b>. Please enter their email address:");
        Ext.get("unknown_recipient").fadeIn();
    }
}

Ext.onReady(function()
{
    Ext.QuickTips.init();
    
    // turn on validation errors beside the field globally
    Ext.form.Field.prototype.msgTarget = 'side';
    
    var store = new Ext.data.JsonStore({
        autoDestroy: true,
        url: "/users/friends",
        root: "friends",
        idProperty: "email",
        fields: ["name", "email"]
    });
    
    var friendFinder = new Ext.form.ComboBox({
        store: store,
        displayField: "name",
//         valueField: 'email',
//         hiddenName: 'friend_finder',
        typeAhead: true,
        minChars: 2,
//         allowBlank: false,
//         vtype: "email",
//         vtypeText: "We couldn't find that user. Please enter a valid email address for them instead.",
        triggerAction: "all",
        emptyText: "Type a friend\'s name or email...",
        selectOnFocus: true,
        renderTo: "friend_finder",
        width: 250,
        
        listeners: {
            beforeselect: function(box, record, index) {
                console.debug("Selected record:");
                console.debug(record);
                console.debug(index);
                box.selectedRecord = record;
                
                return true;
            },
            change: function(box, newValue, oldValue) {
                if(box.selectedRecord)
                {
                    addRecipient(box.selectedRecord.data["name"], box.selectedRecord.data["email"]);
                }
                else if(newValue != "")
                {
                    unknownRecipientBox.reset();
                    addUnknownRecipient(newValue);
                }
                box.selectedRecord = false;
                box.reset();
//             invalid: function(box, msg) {
//                 console.debug(msg);
//             },
//             valid: function(box) {
//                 console.debug("Valid field.");
//             }
            }
        }
    });
    
    var unknownRecipientBox = new Ext.form.TextField({
        allowBlank: false,
        renderTo: "unknown_recipient_box",
        vtype: "email",
        emptyText: "Email address...",
        validationDelay: 1000,
        
        listeners: {
            valid: function(box) {
                if(box.getValue() == "")
                    return;
                addRecipient(box.getValue(), box.getValue());
                Ext.get("unknown_recipient").fadeOut();
                box.reset();
            }
        }
    });
        
});
