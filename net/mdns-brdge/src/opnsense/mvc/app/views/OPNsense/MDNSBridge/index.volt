{#

OPNsense® is Copyright © 2014 – 2017 by Deciso B.V.
Copyright (C) 2026 Brynley McDonald <brynley@zephire.nz>

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1.  Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.

2.  Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

#}
<script>

    $( document ).ready(function() {
        /**
         * inline open dialog, go back to previous page on exit
         */
        function openDialog(uuid) {
            var editDlg = "DialogEdit";
            var setUrl = "/api/mdnsbridge/interface/set_item/";
            var getUrl = "/api/mdnsbridge/interface/get_item/";
            var urlMap = {};
            urlMap['frm_' + editDlg] = getUrl + uuid;
            mapDataToFormUI(urlMap).done(function () {
                // update selectors
                $('.selectpicker').selectpicker('refresh');
                // clear validation errors (if any)
                clearFormValidation('frm_' + editDlg);
                // show
                $('#'+editDlg).modal({backdrop: 'static', keyboard: false});
                $('#'+editDlg).on('hidden.bs.modal', function () {
                    // go back to previous page on exit
                    parent.history.back();
                });
            });
        }
        /*************************************************************************************************************
         * link grid actions
         *************************************************************************************************************/

        $("#grid-interfaces").UIBootgrid(
                {   'search':'/api/mdnsbridge/settings/search_interface',
                    'get':'/api/mdnsbridge/interface/get_item/',
                    'set':'/api/mdnsbridge/interface/set_item/',
                    'add':'/api/mdnsbridge/interface/add_item/',
                    'del':'/api/mdnsbridge/interface/del_item/',
                    'toggle':'/api/mdnsbridge/interface/toggle_item/',
                    'options':{selection:false, multiSelect:false}
                }
        );

        {% if (selected_uuid|default("") != "") %}
            openDialog(uuid='{{selected_uuid}}');
        {% endif %}

        /*************************************************************************************************************
         * Commands
         *************************************************************************************************************/

    });

</script>


<ul class="nav nav-tabs" data-tabs="tabs" id="maintabs">
    <li class="active"><a data-toggle="tab" id="settings" href="#tab_settings">{{ lang._('Settings') }}</a></li>
    <li><a data-toggle="tab" id="interfaces" href="#tab_interfaces">{{ lang._('Interfaces') }}</a></li>
</ul>
<div class="tab-content content-box">
    <div id="tab_settings" class="tab-pane fade in active">
        {{ partial("layout_partials/base_form",['fields':formSettings,'id':'frm_settings'])}}
    </div>

    <div id="tab_interfaces" class="tab-pane fade in active">
        <!-- tab page "interfaces" -->
        <table id="grid-interfaces" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="DialogEdit">
            <thead>
            <tr>
                <th data-column-id="enabled" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                <th data-column-id="interface" data-type="string" data-visible="true">{{ lang._('Interface') }}</th>
                <th data-column-id="ipv4disabled" data-type="string" data-visible="true">{{ lang._('Multicast Addresses') }}</th>
                <th data-column-id="ipv4disabled" data-type="string" data-visible="true">{{ lang._('Source Address') }}</th>
                <th data-column-id="listenport" data-type="string" data-visible="true">{{ lang._('Listen Port') }}</th>
                <th data-column-id="InstanceID" data-type="string" data-visible="true">{{ lang._('ID') }}</th>
                <th data-column-id="description" data-type="string">{{ lang._('Description') }}</th>
                <th data-column-id="uuid" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                <th data-column-id="RevertTTL" data-type="string"  data-visible="true" data-formatter="boolean">{{ lang._('Use ID as TTL') }}</th>
                <th data-column-id="commands" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
            </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
            <tr>
                <td></td>
                <td>
                    <button data-action="add" type="button" class="btn btn-xs btn-default"><span class="fa fa-plus"></span></button>
                    <!-- <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button> -->
                </td>
            </tr>
            </tfoot>
        </table>
    </div>
</div>

{# include dialog #}
{{ partial("layout_partials/base_dialog",['fields':formDialogEdit,'id':'DialogEdit','label':lang._('Edit Interface')])}}
