/*
 *Copyright (c) 2005-2014, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *WSO2 Inc. licenses this file to you under the Apache License,
 *Version 2.0 (the "License"); you may not use this file except
 *in compliance with the License.
 *You may obtain a copy of the License at
 *
 *http://www.apache.org/licenses/LICENSE-2.0
 *
 *Unless required by applicable law or agreed to in writing,
 *software distributed under the License is distributed on an
 *"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *KIND, either express or implied.  See the License for the
 *specific language governing permissions and limitations
 *under the License.
 */

package org.wso2.carbon.identity.application.common.model;

import org.apache.axiom.om.OMElement;

import java.io.Serializable;
import java.util.Iterator;

public class ApplicationPermission implements Serializable {

    /**
     *
     */
    private static final long serialVersionUID = -5921176623905192883L;

    private String value;

    /*
     * <ApplicationPermission> <value></value> </ApplicationPermission>
     */
    public static ApplicationPermission build(OMElement applicationPermissionOM) {
        ApplicationPermission applicationPermission = new ApplicationPermission();

        Iterator<?> iter = applicationPermissionOM.getChildElements();

        while (iter.hasNext()) {
            OMElement element = (OMElement) (iter.next());
            String elementName = element.getLocalName();

            if (elementName.equals("value")) {
                applicationPermission.setValue(element.getText());
            }
        }

        return applicationPermission;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

}
