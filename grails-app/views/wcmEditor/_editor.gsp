<div class="container">
<g:javascript>
<%-- I dont want to do this here but have no choice until we can include resources in header --%>
<%-- Highlight any accordion headers that have errors inside them --%>
$( function() {
    $('div .ui-state-error', $('#panels')).parentsUntil('#panels').prev('.ui-accordion-header').addClass('ui-state-error');
    var originalFormOnSubmits = $('.preview-button').parents('form').attr('onsubmit');
    $('.preview-button').click( function(event) {
        var form = $(event.target).parents('form');
        form.attr('target', '_preview');
        
        //$('#preview-action').val('preview');
        
        // Now submit form using workaround for onsubmit calls
        $('#preview-action-submitter').click()
        
        // Reset the form target so save works as expected
        form.attr('target', '');
    
        //$('#previewaction').val('');
        
        // Don't have a double-submit
        event.preventDefault();
        
        windows
    });
});
</g:javascript>

    <bean:errorClass>ui-state-error</bean:errorClass>

    <g:uploadForm method="post">

        <g:if test="${content.id}">
            <input type="hidden" name="id" value="${params.id.encodeAsHTML()}"/>
        </g:if>    
        <g:else>
            <input type="hidden" name="type" value="${params.type.encodeAsHTML()}"/>
        </g:else>
        
        <div class="span-24 last">
            <div>
        <g:grep in="${editableProperties}" var="prop" filter="${ { p -> p.group == null }}">
                <div class="clear span-4">
                    <bean:label beanName="content" property="${prop.property}" labelKey="${'content.label.'+prop.property}"/>
                </div>
                <div class="field prepend-1 span-18 last">
                    <% println wcm."editorField${prop.editor}"(bean:content, property:prop.property) %>
                </div>
        </g:grep>
            </div>
        </div>

        <div class="clear span-24 last">
            <div class="prepend-top append-bottom editorsaveactions">
                <g:actionSubmit class="ui-widget ui-state-default ui-corner-all" value="Save and continue editing" action="${content.id ? 'updateContinue' : 'saveContinue'}"/>
                <g:actionSubmit class="ui-widget ui-state-default ui-corner-all" value="Save" action="${content.id ? 'update' : 'save'}"/>
                <g:actionSubmit class="ui-widget ui-state-default ui-corner-all" class="ui-widget ui-state-default ui-corner-all preview-button" value="Preview" action="preview"/>
                <input style="display:none" type="submit" id="preview-action-submitter" name="_action_preview" value="preview"/> <%-- Needed to invoke onsubmit on form during our preview submit phase --%>
                <g:actionSubmit class="ui-widget ui-state-default ui-corner-all" value="Cancel" action="cancel"/>
            </div>
        </div>
        
        <div class="span-24 last" id="panels">
            <h2><a href="#">Extra</a></h2>
            <div id="editor-extras">
                <g:grep in="${editableProperties}" var="prop" filter="${ { p -> p.group == 'extra'} }">
                
                    <div class="clear prepend-1 span-4">
                        <bean:label beanName="content" property="${prop.property}" labelKey="${'content.label.'+prop.property}"/>
                    </div>
                    <div class="field prepend-1 span-17 last">
                        <% println wcm."editorField${prop.editor}"(bean:content, property:prop.property) %>
                    </div>
                </g:grep>
            </div>

            <h2><a href="#">Parent &amp; Children</a></h2>
            <div id="editor-family">
                <div class="clear prepend-1 span-2">
                    <label>Parent:</label>
                </div>
                <div class="prepend-1 span-20 last">
                    <g:if test="${content.parent}">
                        ${content.parent.title.encodeAsHTML()} (${message(code:'content.item.name.'+content.parent.class.name, encodeAs:'HTML')})
                        <input type="hidden" name="parent.id" value="${content.parent.id}"/>
                    </g:if><br/>
                </div>
                <%-- Only show children if we are editing --%>
                <g:if test="${content.id}">
                    <div class="clear span-2">
                        <label>Children:</label>
                    </div>
                    <div class="prepend-1 span-21 last">
                        <g:if test="${content.children?.size()}">
                            <ul>
                            <g:each in="${content.children}" var="child">
                                <li>${child.title.encodeAsHTML()} (${message(code:'content.item.name.'+child.class.name, encodeAs:'HTML')})</li>
                            </g:each>
                            </ul>
                        </g:if>
                    </div>
                </g:if>
            </div>
        </div>
  </g:uploadForm>
</div>  
