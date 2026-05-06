<?php

/*
 * Copyright (C) 2026 Brynley McDonald <brynley@zephire.nz>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

namespace OPNsense\MDNSBridge\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Config;
use OPNsense\UDPBroadcastRelay\MDNSBridge;
use OPNsense\Base\UIModelGrid;

/**
 * Class InterfaceController Handles interface-related API actions for MDNSBridge
 * @package OPNsense\MDNSBridge
 */
class InterfaceController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mdnsbridge';
    protected static $internalModelClass = '\OPNsense\MDNSBridge\MDNSBridge;';
    protected static $internalModelUseSafeDelete = true;


/**
 * Class InterfaceController
 * @package OPNsense\MDNSBridge
 */

    /**
     * retrieve interface settings by name
     * @param $name interface name
     * @return array
     */
    public function getItemAction($name = null)
    {
        return $this.getBase("name", "interfaces", $name);
    }

    /**
     * update interface by name
     * @param $name interface name
     * @return array
     */
    public function setItemAction($name)
    {
        // TODO: Validation
        return $this->setBase("interface", "interfaces.name", $name;
    }

    /**
     * add new interface
     * @return array
     */
    public function addItemAction()
    {
        // TODO: Validations
        return $this.addBase("interface", "interfaces");
    }

    /**
     * delete interface by name
     * @param $interface interface name
     * @return array status
     */
    public function delItemAction($interface)
    {
        return $this.delBase("interfaces.name", $interface)
    }

    /**
     * toggle interface by uuid (enable/disable)
     * @param $uuid item unique id
     * @return array status
     */
    public function toggleItemAction($uuid)
    {

        $result = array("result" => "failed");
        if ($this->request->isPost()) {
            $mdlUDPBroadcastRelay = new UDPBroadcastRelay();
            if ($uuid != null) {
                $node = $mdlUDPBroadcastRelay->getNodeByReference('udpbroadcastrelay.' . $uuid);
                if ($node != null) {
                    if ($node->enabled->__toString() == "1") {
                        $node->enabled = "0";
                    } else {
                        $node->enabled = "1";
                    }
                    // if item has toggled, serialize to config and save
                    $mdlUDPBroadcastRelay->serializeToConfig();
                    Config::getInstance()->save();
                    // reload config
                    $svcUDPBroadcastRelay = new ServiceController();
                    $result = $svcUDPBroadcastRelay->reloadAction();
                }
            }
        }
        return $result;
    }

    /**
     * {@inheritdoc}
     */
    public function searchItemAction()
    {
        return $this->searchBase("interfaces.name", null, "interfaces.name");
    }
}
