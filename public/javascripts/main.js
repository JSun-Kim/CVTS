// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function () {
    //Add Member Button
    var $add_member_dialog = $('#add_member_dialog').dialog({
        autoOpen:false,
        title:'Add Member',
        modal:true,
        draggable:false,
        width:230
    });

    $('#add_member').click(function () {
        $add_member_dialog.dialog('open');
    });

    //Remove Member Button
    var $remove_member_dialog = $('#remove_member_dialog').dialog({
        autoOpen:false,
        title:'Remove Member',
        modal:true,
        draggable:false,
        width:230
    });

    $('#remove_member').click(function () {
        $remove_member_dialog.dialog('open');
    });

    //Edit Description Button
    var $edit_description_dialog = $('#edit_description_dialog').dialog({
        autoOpen:false,
        title:'Edit Description',
        modal:true,
        draggable:false,
        width:500
    });

    $('#edit_description').click(function () {
        $edit_description_dialog.dialog('open');
    });

    //Set the submit action to 'trash', hide the row, submit form
    $("#delete_top, #delete_bottom").click(function () {
        $('#theaction').val('trash');

        $('input:checked').each(function (i, e) {
            $(e).closest('tr').hide();
        });

        $('#action_form').submit();

        return false;
    });

    //Set the submit action to 'read', remove <strong> tags, submit form, uncheck boxes
    $("#mark_read_top, #mark_read_bottom").click(function () {
        $('#theaction').val('read');

        $('input:checked').each(function (i, e) {
            $(e).closest('tr').find('strong').contents().unwrap();
        });

        $('#action_form').submit();

        $('input:checked').each(function (i, e) {
            $(e).removeAttr('checked');
        });

        return false;
    });

    $("#vote_yes_top, #vote_yes_bottom").click(function () {
        $('#theaction').val('yes');
        var checkboxCount = 0;
        $('input:checked').each(function (i, e) {
            $(e).closest('tr').hide();
            checkboxCount++;
        });

        if (checkboxCount > 0) {
            $('#action_form').submit();
            $.n.success("You just voted yes on " + checkboxCount + " ballot(s)!");
        }

        $('input:checked').each(function (i, e) {
            e.checked = false;
        });

        return false;
    });

    $("#vote_no_top, #vote_no_bottom").click(function () {
        $('#theaction').val('no');
        var checkboxCount = 0;
        $('input:checked').each(function (i, e) {
            $(e).closest('tr').hide();
            checkboxCount++;
        });

        if (checkboxCount > 0) {
            $('#action_form').submit();
            $.n.success("You just voted no on " + checkboxCount + " ballot(s)!");
        }

        $('input:checked').each(function (i, e) {
            e.checked = false;
        });

        return false;
    });

    $("#archive_top, #archive_bottom").click(function () {
        $('#theaction').val('archive');

        var checkboxCount = 0;

        $('input:checked').each(function (i, e) {
            $(e).closest('tr').hide();
            checkboxCount++;
        });

        if (checkboxCount > 0) {
            $('#action_form').submit();
            $.n.success(checkboxCount + " tags moved to archived tags");
        }

        $('input:checked').each(function (i, e) {
            e.checked = false;
        });

        return false;
    });

    $("#restore_top, #restore_bottom").click(function () {
        $('#theaction').val('restore');

        var checkboxCount = 0;

        $('input:checked').each(function (i, e) {
            $(e).closest('tr').hide();
            checkboxCount++;
        });

        if (checkboxCount > 0) {
            $('#action_form').submit();
            $.n.success(checkboxCount + " tags moved to active tags");
        }

        $('input:checked').each(function (i, e) {
            e.checked = false;
        });

        return false;
    });

    $("#vote_yes").click(function () {
        $("#approval").val(true)
        $(".edit_vote").submit()
        var button_area = $('#header_buttons');
        button_area.html("You just voted 'yes' on this ballot.");
        setTimeout(function(){ button_area.fadeOut() }, 3000);
        return false;
    });

    $("#vote_no").click(function () {
        $("#approval").val(false)
        $(".edit_vote").submit()
        var button_area = $('#header_buttons');
        button_area.html("You just voted 'no' on this ballot.");
        setTimeout(function(){ button_area.fadeOut() }, 3000);
        return false;

    });

    $("#delete_email_top, #delete_email_bottom").click(function () {
        $("#delete").val(true)
        $(".edit_email").submit()
        return true;
    });

    $("#mark_unread_top, #mark_unread_bottom").click(function () {
        $("#mark_read").val(false)
        $(".edit_email").submit()
        return true;
    });

    //function for multiple tags auto complete
    function split(val) {
        return val.split(/[,;]\s*/);
    }

    function extractLast(term) {
        return split(term).pop();
    }

    //Autocomplete for tags
    $("#tags, #other_tags").autocomplete({
        //should add caching
        minLength:0,
        //source: "../tags.json";
        source:function (request, response) {
            // delegate back to autocomplete, but extract the last term
            $.getJSON("/tags.json", {
                    "term":extractLast(request.term)
                },
                function (data) {
                    response($.ui.autocomplete.filter(data, extractLast(request.term)));
                });
        },
        focus:function () {
            // prevent value inserted on focus
            return false;
        },
        select:function (event, ui) {
            var terms = split(this.value);
            // remove the current input
            terms.pop();
            // add the selected item
            terms.push(ui.item.value);
            // add placeholder to get the comma-and-space at the end
            terms.push("");
            this.value = terms.join(", ");
            return false;
        }

    });

    $("#members, #recipients").autocomplete({
        //should add caching
        minLength:0,
        //source: "../tags.json";
        source:function (request, response) {
            // delegate back to autocomplete, but extract the last term
            $.getJSON("/users.json", {
                    "term":extractLast(request.term)
                },
                function (data) {
                    response($.ui.autocomplete.filter(data, extractLast(request.term)));
                });
        },
        focus:function () {
            // prevent value inserted on focus
            return false;
        },
        select:function (event, ui) {
            var terms = split(this.value);
            // remove the current input
            terms.pop();
            // add the selected item
            terms.push(ui.item.value);
            // add placeholder to get the comma-and-space at the end
            terms.push("");
            this.value = terms.join(", ");
            return false;
        }

    });

    $("#add_person, #remove_person").autocomplete({
        //should add caching
        minLength:0,
        //source: "../tags.json";
        source:function (request, response) {
            // delegate back to autocomplete, but extract the last term
            $.getJSON("/users.json", {
                    "term":extractLast(request.term)
                },
                function (data) {
                    response($.ui.autocomplete.filter(data, extractLast(request.term)));
                });
        },
        focus:function () {
            // prevent value inserted on focus
            return false;
        },
        select:function (event, ui) {
            return this.value;
        }

    });

    $('.delete_notification').bind('ajax:complete', function() {
        $(this).closest('li').fadeOut();
        $.get("/notifications/", {}, null, "script");
    });

    setInterval(function() {
        $.get("/notifications/", {}, null, "script");
    }, 5000);

})