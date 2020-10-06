/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

var datasRead=[];
var colors=["#0000CC","#FF0000","#FF9900","#9900FF","#6600FF","#000000"];
var colorUsed=[false,false,false,false,false,false];
$(function () {

	var HVDC_hvdc_PPu_Side_PPu=[];
	HVDC_hvdc_PPu_Side_PPu.push([0.0,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([0.001,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([0.002,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([0.004,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([0.008,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([0.016,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([0.032,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([0.064,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([0.128,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([0.256,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([0.512,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([0.768,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([1.28,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([2.304,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([4.352,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([8.448,0.8980]);
	HVDC_hvdc_PPu_Side_PPu.push([10.0,0.8980]);

	var HVDC_hvdc_PPu_Side_QPu=[];
	HVDC_hvdc_PPu_Side_QPu.push([0.0,0.3010]);
	HVDC_hvdc_PPu_Side_QPu.push([0.001,0.3010]);
	HVDC_hvdc_PPu_Side_QPu.push([0.002,0.3010]);
	HVDC_hvdc_PPu_Side_QPu.push([0.004,0.3010]);
	HVDC_hvdc_PPu_Side_QPu.push([0.008,0.3010]);
	HVDC_hvdc_PPu_Side_QPu.push([0.016,0.3010]);
	HVDC_hvdc_PPu_Side_QPu.push([0.032,0.3010]);
	HVDC_hvdc_PPu_Side_QPu.push([0.064,0.3010]);
	HVDC_hvdc_PPu_Side_QPu.push([0.128,0.3011]);
	HVDC_hvdc_PPu_Side_QPu.push([0.256,0.3012]);
	HVDC_hvdc_PPu_Side_QPu.push([0.512,0.3012]);
	HVDC_hvdc_PPu_Side_QPu.push([0.768,0.3012]);
	HVDC_hvdc_PPu_Side_QPu.push([1.28,0.3012]);
	HVDC_hvdc_PPu_Side_QPu.push([2.304,0.3012]);
	HVDC_hvdc_PPu_Side_QPu.push([4.352,0.3012]);
	HVDC_hvdc_PPu_Side_QPu.push([8.448,0.3012]);
	HVDC_hvdc_PPu_Side_QPu.push([10.0,0.3012]);

	var HVDC_hvdc_dCLine_U1dcPu=[];
	HVDC_hvdc_dCLine_U1dcPu.push([0.0,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([0.001,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([0.002,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([0.004,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([0.008,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([0.016,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([0.032,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([0.064,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([0.128,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([0.256,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([0.512,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([0.768,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([1.28,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([2.304,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([4.352,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([8.448,0.9978]);
	HVDC_hvdc_dCLine_U1dcPu.push([10.0,0.9978]);

	var HVDC_hvdc_Conv1_UPu=[];
	HVDC_hvdc_Conv1_UPu.push([0.0,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([0.001,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([0.002,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([0.004,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([0.008,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([0.016,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([0.032,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([0.064,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([0.128,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([0.256,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([0.512,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([0.768,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([1.28,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([2.304,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([4.352,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([8.448,1.0138]);
	HVDC_hvdc_Conv1_UPu.push([10.0,1.0138]);

	var HVDC_hvdc_Conv1_UPhase=[];
	HVDC_hvdc_Conv1_UPhase.push([0.0,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([0.001,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([0.002,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([0.004,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([0.008,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([0.016,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([0.032,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([0.064,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([0.128,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([0.256,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([0.512,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([0.768,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([1.28,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([2.304,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([4.352,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([8.448,0.0317]);
	HVDC_hvdc_Conv1_UPhase.push([10.0,0.0317]);

	var HVDC_hvdc_UdcPu_Side_PPu=[];
	HVDC_hvdc_UdcPu_Side_PPu.push([0.0,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([0.001,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([0.002,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([0.004,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([0.008,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([0.016,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([0.032,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([0.064,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([0.128,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([0.256,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([0.512,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([0.768,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([1.28,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([2.304,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([4.352,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([8.448,-0.9000]);
	HVDC_hvdc_UdcPu_Side_PPu.push([10.0,-0.9000]);

	var HVDC_hvdc_UdcPu_Side_QPu=[];
	HVDC_hvdc_UdcPu_Side_QPu.push([0.0,0.3010]);
	HVDC_hvdc_UdcPu_Side_QPu.push([0.001,0.3010]);
	HVDC_hvdc_UdcPu_Side_QPu.push([0.002,0.3010]);
	HVDC_hvdc_UdcPu_Side_QPu.push([0.004,0.3010]);
	HVDC_hvdc_UdcPu_Side_QPu.push([0.008,0.3010]);
	HVDC_hvdc_UdcPu_Side_QPu.push([0.016,0.3010]);
	HVDC_hvdc_UdcPu_Side_QPu.push([0.032,0.3010]);
	HVDC_hvdc_UdcPu_Side_QPu.push([0.064,0.3010]);
	HVDC_hvdc_UdcPu_Side_QPu.push([0.128,0.3008]);
	HVDC_hvdc_UdcPu_Side_QPu.push([0.256,0.3007]);
	HVDC_hvdc_UdcPu_Side_QPu.push([0.512,0.3006]);
	HVDC_hvdc_UdcPu_Side_QPu.push([0.768,0.3006]);
	HVDC_hvdc_UdcPu_Side_QPu.push([1.28,0.3006]);
	HVDC_hvdc_UdcPu_Side_QPu.push([2.304,0.3006]);
	HVDC_hvdc_UdcPu_Side_QPu.push([4.352,0.3006]);
	HVDC_hvdc_UdcPu_Side_QPu.push([8.448,0.3006]);
	HVDC_hvdc_UdcPu_Side_QPu.push([10.0,0.3006]);

	var HVDC_hvdc_dCLine_U2dcPu=[];
	HVDC_hvdc_dCLine_U2dcPu.push([0.0,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([0.001,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([0.002,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([0.004,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([0.008,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([0.016,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([0.032,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([0.064,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([0.128,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([0.256,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([0.512,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([0.768,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([1.28,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([2.304,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([4.352,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([8.448,1.0000]);
	HVDC_hvdc_dCLine_U2dcPu.push([10.0,1.0000]);

	var HVDC_hvdc_Conv2_UPu=[];
	HVDC_hvdc_Conv2_UPu.push([0.0,1.0271]);
	HVDC_hvdc_Conv2_UPu.push([0.001,1.0271]);
	HVDC_hvdc_Conv2_UPu.push([0.002,1.0271]);
	HVDC_hvdc_Conv2_UPu.push([0.004,1.0271]);
	HVDC_hvdc_Conv2_UPu.push([0.008,1.0271]);
	HVDC_hvdc_Conv2_UPu.push([0.016,1.0271]);
	HVDC_hvdc_Conv2_UPu.push([0.032,1.0271]);
	HVDC_hvdc_Conv2_UPu.push([0.064,1.0270]);
	HVDC_hvdc_Conv2_UPu.push([0.128,1.0270]);
	HVDC_hvdc_Conv2_UPu.push([0.256,1.0270]);
	HVDC_hvdc_Conv2_UPu.push([0.512,1.0270]);
	HVDC_hvdc_Conv2_UPu.push([0.768,1.0270]);
	HVDC_hvdc_Conv2_UPu.push([1.28,1.0270]);
	HVDC_hvdc_Conv2_UPu.push([2.304,1.0270]);
	HVDC_hvdc_Conv2_UPu.push([4.352,1.0270]);
	HVDC_hvdc_Conv2_UPu.push([8.448,1.0270]);
	HVDC_hvdc_Conv2_UPu.push([10.0,1.0270]);

	var HVDC_hvdc_Conv2_UPhase=[];
	HVDC_hvdc_Conv2_UPhase.push([0.0,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([0.001,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([0.002,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([0.004,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([0.008,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([0.016,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([0.032,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([0.064,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([0.128,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([0.256,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([0.512,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([0.768,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([1.28,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([2.304,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([4.352,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([8.448,-0.0329]);
	HVDC_hvdc_Conv2_UPhase.push([10.0,-0.0329]);

	datasRead=[
	{
		label:"HVDC_hvdc_PPu_Side_PPu",
		data:HVDC_hvdc_PPu_Side_PPu
	},
	{
		label:"HVDC_hvdc_PPu_Side_QPu",
		data:HVDC_hvdc_PPu_Side_QPu
	},
	{
		label:"HVDC_hvdc_dCLine_U1dcPu",
		data:HVDC_hvdc_dCLine_U1dcPu
	},
	{
		label:"HVDC_hvdc_Conv1_UPu",
		data:HVDC_hvdc_Conv1_UPu
	},
	{
		label:"HVDC_hvdc_Conv1_UPhase",
		data:HVDC_hvdc_Conv1_UPhase
	},
	{
		label:"HVDC_hvdc_UdcPu_Side_PPu",
		data:HVDC_hvdc_UdcPu_Side_PPu
	},
	{
		label:"HVDC_hvdc_UdcPu_Side_QPu",
		data:HVDC_hvdc_UdcPu_Side_QPu
	},
	{
		label:"HVDC_hvdc_dCLine_U2dcPu",
		data:HVDC_hvdc_dCLine_U2dcPu
	},
	{
		label:"HVDC_hvdc_Conv2_UPu",
		data:HVDC_hvdc_Conv2_UPu
	},
	{
		label:"HVDC_hvdc_Conv2_UPhase",
		data:HVDC_hvdc_Conv2_UPhase
	}
	];

  // reset graph
  resetGraph();

  var eltitle = document.getElementById('case_title');
  // remove old children
  eltitle.innerHTML='';
  var titleHtml="<h1>curves.csv</h1>";
  var line = document.createElement("LABEL");
  eltitle.appendChild(line);
  var frag = document.createElement('div');
  frag.innerHTML = titleHtml;
  line.appendChild(frag);

  updateLegend();
    });

function listenCheckbox(button,yAxis)
{
    var id = button.getAttribute("id");
    var instanceId = '';
    if (yAxis == 1)
    {
        instanceId = id + ' on left axis';
    }
    else if (yAxis == 2)
    {
        instanceId = id + ' on right axis';
    }
    else
    {
        alert("Unknown axis");
        button.checked = false;
    }
    var checked= button.checked;
    if( checked == true ) { // add serie
      var serie=[];
      var index = 0;
      for( var i=0; i< datasRead.length; i++) {
          if( datasRead[i].label == id)    {
              index = i;
              break;
          }
      }
      if(dataId.length > 5) {
          alert("Unable to plot more than 6 curves");
          button.checked = false;
      }
      else {
          serie=datasRead[index].data;
          addData(serie,instanceId,yAxis);
      }
    }
    if( checked == false ) { // remove serie
      removeData(instanceId);
    }

}

function addData(serie,id,yAxis) {
  dataId.push(id);
  // search the first color not used
  var indexColor = 0;
  for(var i=0; i<colors.length; i++) {
    if(colorUsed[i] == false) {
      indexColor = i;
      break;
    }
  }
  colorUsed[indexColor] = true;

  dataToPlot.push(
    {
      label: id,
        yaxis: yAxis,
        data : serie,
        color: colors[indexColor],
        points: { show: false }
    }
    );
  plotData();
  updateLegend();
}

function removeData(id)
{
  var index = 0;
  for( var i=0; i< dataId.length; i++) {
    if(dataId[i] == id) {
      index = i;
      break;
    }
  }
  // find the color used to refresh the colorUsed table
  var indexColor =0;
  for(var i=0; i<colors.length; i++) {
    if(dataToPlot[index].color ==colors[i]) {
      indexColor = i;
    }
  }
  colorUsed[indexColor] = false;

  dataId.splice(index,1);
  dataToPlot.splice(index,1);
  plotData();
  updateLegend();
}


function plotData()
{
  var  placeholder = $("#placeholder");
  plot = $.plot(placeholder, dataToPlot, oldOptions);
}


function updateLegend()
{
  var  legend = document.getElementById("legend");
  legend.innerHTML='';
  var table = document.createElement('table');
  legend.appendChild(table);
  for(var i=0; i<dataToPlot.length; i++){
    var line = document.createElement("tr");
    table.appendChild(line);
    var legendHtml= '<td><div style="width:4px;height:0;border:4px solid ' + dataToPlot[i].color + ';overflow:hidden"></div></td><td>'+ dataToPlot[i].label+'</td>';
    line.innerHTML = legendHtml;
  }
  for(var i=dataToPlot.length; i<7; i++)    {
    var line = document.createElement("tr");
    table.appendChild(line);
    var legendHtml= '<td><div style="width:4px;height:0;border:4px solid #FFFFFF;overflow:hidden"></div></td><td></td>';
    line.innerHTML = legendHtml;
  }

}

function resetGraph()
{
  // remove old curve
  var  placeholder = $("#placeholder");
  dataToPlot = [];
  plot =  $.plot(placeholder, dataToPlot, oldOptions);
  dataId= [];
  colorUsed =[false,false,false,false,false,false];
  var el = document.getElementById('checkbox');
  // remove old children
  el.innerHTML='';
  // Create table for curves selections
  var table = document.createElement('table');
  el.appendChild(table);
  var headers = document.createElement('tr');
  headers.innerHTML = '<th>Left axis</th><th>Curves available</th><th>Right axis</th>';
  table.appendChild(headers);
  // set new children
  for (var i=0; i<datasRead.length; i++) {
    var line = document.createElement("tr");
    table.appendChild(line);

    var radioHtml = '<td style="text-align:center"><input type="checkbox" name="choice" onclick="listenCheckbox(this,1)" id="'+datasRead[i].label+'"/></td><td><label>'+datasRead[i].label+'</label></td><td style="text-align:center"><input type="checkbox" name="choice" onclick="listenCheckbox(this,2)" id="'+datasRead[i].label+'"/></td>';
    line.innerHTML =  radioHtml;
  }

  var  legend = document.getElementById("legend");
  legend.innerHTML='';
}
