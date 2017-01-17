 /*
 * Copyright (c) 2008-2010, JFXtras Group
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
 */
package cargoloader;

import cargoloader.PositionNode;
import cargoloader.ULD;
import cargoloader.envelope.DataUtil;

/**
 * the load plan data objects which keeps the information of updated weight on each position where a user can place cargo container.
 * @author Abhilshit Soni
 */
public var basicOperatingWeight: Number = 9005;
public var basicOperatingMoment: Number = 2593400;
public var basicCG: Number = basicOperatingMoment / basicOperatingWeight;
public var crewWeight: Number = 340;
public var crewMoment: Number = 43900;
public var fuelVolume: Number = 385;
public var burnOffFuelVolume = 380;
public var fuelDensity: Number = 6.8;
public var fuelWeight: Number = 2633;
public var burnOffFuelWeight: Number = 256800;
public var burnOffFuelMoment: Number = 7722;
public var fuelMoment: Number = 7866;
public var initialTotalMoment:Number=basicOperatingMoment+fuelMoment+crewMoment;
public var initialTotalWeight:Number= basicOperatingWeight+fuelWeight+crewWeight;
public var initialCG:Number= (initialTotalMoment - fuelMoment) / (initialTotalWeight - fuelWeight);
public class PlanData {

    public var dataPanel: DataPanel;
    public var currentPlanWeight: Number;
    public var currentPlanMoment: Number;
    public var totalWeight: Number;
    public var totalMoment: Number;
    /**
     *zero fuel center of gravity
     */
    public var centerOfGravity: Number;
    /**
     *take off center of gravity
     */
    public var takeOffCG: Number;
    /**
     *landing center of gravity
     */
    public var landingCG: Number;
    public var loadedPositions = [];
    public var weightAR: Number = 0;
    public var weightBR: Number = 0;
    public var weightCR: Number = 0;
    public var weightDR: Number = 0;
    public var weightER: Number = 0;
    public var weightFR: Number = 0;
    public var weightGR: Number = 0;
    public var weightHR: Number = 0;
    public var weightIR: Number = 0;
    public var weightAL: Number = 0;
    public var weightBL: Number = 0;
    public var weightCL: Number = 0;
    public var weightDL: Number = 0;
    public var weightEL: Number = 0;
    public var weightFL: Number = 0;
    public var weightGL: Number = 0;
    public var weightHL: Number = 0;
    public var weightIL: Number = 0;

    init {
        dataPanel.cWeight = 0;
        dataPanel.cMoment = 0;
        dataPanel.tMoment = initialTotalMoment;
        dataPanel.tWeight = initialTotalWeight;
        dataPanel.cg = initialCG;
    }

    public function update(deck: DeckPanel) {
        var tempPlanWeight: Number = 0;
        var tempPlanMoment: Number = 0;
        delete  loadedPositions;
        for (i in deck.content) {
            var position = (i as PositionNode);
            var obj = position.dataObject;
            position.moment = 0;
            if (obj != null) {
                var uld = obj as ULD;
                position.moment = uld.weight * position.fuselageStation;
                insert position into loadedPositions;
                setPositionWeight(position.id, uld.weight);
                // println("{i.id} has {uld.weight} kgs");
                tempPlanWeight = tempPlanWeight + uld.weight;
                tempPlanMoment = tempPlanMoment + position.moment;
            } else {
                setPositionWeight(position.id, 0);
            }

        }
        currentPlanWeight = tempPlanWeight;
        currentPlanMoment = tempPlanMoment;
        totalWeight = currentPlanWeight + basicOperatingWeight + crewWeight + fuelWeight;
        totalMoment = currentPlanMoment + basicOperatingMoment + crewMoment + fuelMoment;
        centerOfGravity = (totalMoment - fuelMoment) / (totalWeight - fuelWeight);
        takeOffCG = totalMoment / totalWeight;
        landingCG = (totalMoment - burnOffFuelMoment) / (totalWeight - burnOffFuelWeight);
        dataPanel.cMoment = currentPlanMoment;
        dataPanel.cWeight = currentPlanWeight;
        dataPanel.tMoment = totalMoment;
        dataPanel.tWeight = totalWeight;
        dataPanel.cg = centerOfGravity;
        DataUtil.populateCGData(totalWeight / 100, centerOfGravity);
    }

    public function setPositionWeight(positionID: String, weight: Number) {
        if (positionID.equals("AR")) {
            weightAR = weight;
        } else if (positionID.equals("AL")) {
            weightAL = weight;
        } else if (positionID.equals("BR")) {
            weightBR = weight;
        } else if (positionID.equals("BL")) {
            weightBL = weight;
        } else if (positionID.equals("CR")) {
            weightCR = weight;
        } else if (positionID.equals("CL")) {
            weightCL = weight;
        } else if (positionID.equals("DR")) {
            weightDR = weight;
        } else if (positionID.equals("DL")) {
            weightDL = weight;
        } else if (positionID.equals("ER")) {
            weightER = weight;
        } else if (positionID.equals("EL")) {
            weightEL = weight;
        } else if (positionID.equals("FR")) {
            weightFR = weight;
        } else if (positionID.equals("FL")) {
            weightFL = weight;
        } else if (positionID.equals("GR")) {
            weightGR = weight;
        } else if (positionID.equals("GL")) {
            weightGL = weight;
        } else if (positionID.equals("HR")) {
            weightHR = weight;
        } else if (positionID.equals("HL")) {
            weightHL = weight;
        } else if (positionID.equals("IR")) {
            weightIR = weight;
        } else if (positionID.equals("IL")) {
            weightIL = weight;
        }
    }

}
