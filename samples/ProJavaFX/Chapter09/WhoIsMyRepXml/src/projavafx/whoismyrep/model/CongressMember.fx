/*
 * Copyright (c) 2009, Pro JavaFX Authors
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of JFXtras nor the names of its contributors may be used
 *    to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * CongressMember.fx
 *
 * Created on Mar 3, 2009, 10:33:33 PM
 */

package projavafx.whoismyrep.model;

import java.lang.Exception;

/**
 * @author Dean Iverson
 */
def SEN_HONORIFIC = "Sen.";
def REP_HONORIFIC = "Rep.";

public class CongressMember {
    public-read package var honorific = SEN_HONORIFIC;
    public-read package var name: String;
    public-read package var party: String;
    public-read package var state: String;

    /**
     * If the district is a number, this is a representative.  This is a senator if the
     * district string is "Junior Seat" or "Senior Seat".
     */
    public-read package var district: String on replace {
        try {
            Integer.parseInt( district );
            honorific = REP_HONORIFIC;
        } catch (e:Exception) {
            honorific = SEN_HONORIFIC;
        }
    }

    public-read package var phone: String;
    public-read package var office: String;
    public-read package var website: String;

    /**
     * @return True if this member is a senator, false if this is a representative.
     */
    public function isSenator(): Boolean {
        return honorific == SEN_HONORIFIC;
    }
}

