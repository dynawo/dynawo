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

	var SM_gen_omegaPu=[];
	SM_gen_omegaPu.push([0.0,1.000000]);
	SM_gen_omegaPu.push([1.0,1.000000]);
	SM_gen_omegaPu.push([2.0,1.000000]);
	SM_gen_omegaPu.push([3.0,1.000000]);
	SM_gen_omegaPu.push([4.0,1.000000]);
	SM_gen_omegaPu.push([5.0,1.000000]);
	SM_gen_omegaPu.push([6.0,1.000000]);
	SM_gen_omegaPu.push([7.0,1.000000]);
	SM_gen_omegaPu.push([8.0,1.000000]);
	SM_gen_omegaPu.push([9.0,1.000000]);
	SM_gen_omegaPu.push([10.0,1.000000]);
	SM_gen_omegaPu.push([11.0,1.000000]);
	SM_gen_omegaPu.push([12.0,1.000000]);
	SM_gen_omegaPu.push([13.0,1.000000]);
	SM_gen_omegaPu.push([14.0,1.000000]);
	SM_gen_omegaPu.push([15.0,1.000000]);
	SM_gen_omegaPu.push([16.0,1.000000]);
	SM_gen_omegaPu.push([17.0,1.000000]);
	SM_gen_omegaPu.push([18.0,1.000000]);
	SM_gen_omegaPu.push([19.0,1.000000]);
	SM_gen_omegaPu.push([20.0,1.000000]);
	SM_gen_omegaPu.push([21.0,1.000000]);
	SM_gen_omegaPu.push([22.0,1.000000]);
	SM_gen_omegaPu.push([23.0,1.000000]);
	SM_gen_omegaPu.push([24.0,1.000000]);
	SM_gen_omegaPu.push([25.0,1.000000]);
	SM_gen_omegaPu.push([26.0,1.000000]);
	SM_gen_omegaPu.push([27.0,1.000000]);
	SM_gen_omegaPu.push([28.0,1.000000]);
	SM_gen_omegaPu.push([29.0,1.000000]);
	SM_gen_omegaPu.push([30.0,1.000000]);

	var SM_avr_UsRefPu=[];
	SM_avr_UsRefPu.push([0.0,1.127905]);
	SM_avr_UsRefPu.push([1.0,1.127905]);
	SM_avr_UsRefPu.push([2.0,1.127905]);
	SM_avr_UsRefPu.push([3.0,1.127905]);
	SM_avr_UsRefPu.push([4.0,1.127905]);
	SM_avr_UsRefPu.push([5.0,1.127905]);
	SM_avr_UsRefPu.push([6.0,1.127905]);
	SM_avr_UsRefPu.push([7.0,1.127905]);
	SM_avr_UsRefPu.push([8.0,1.127905]);
	SM_avr_UsRefPu.push([9.0,1.127905]);
	SM_avr_UsRefPu.push([10.0,1.127905]);
	SM_avr_UsRefPu.push([11.0,1.127905]);
	SM_avr_UsRefPu.push([12.0,1.127905]);
	SM_avr_UsRefPu.push([13.0,1.127905]);
	SM_avr_UsRefPu.push([14.0,1.127905]);
	SM_avr_UsRefPu.push([15.0,1.127905]);
	SM_avr_UsRefPu.push([16.0,1.127905]);
	SM_avr_UsRefPu.push([17.0,1.127905]);
	SM_avr_UsRefPu.push([18.0,1.127905]);
	SM_avr_UsRefPu.push([19.0,1.127905]);
	SM_avr_UsRefPu.push([20.0,1.127905]);
	SM_avr_UsRefPu.push([21.0,1.127905]);
	SM_avr_UsRefPu.push([22.0,1.127905]);
	SM_avr_UsRefPu.push([23.0,1.127905]);
	SM_avr_UsRefPu.push([24.0,1.127905]);
	SM_avr_UsRefPu.push([25.0,1.127905]);
	SM_avr_UsRefPu.push([26.0,1.127905]);
	SM_avr_UsRefPu.push([27.0,1.127905]);
	SM_avr_UsRefPu.push([28.0,1.127905]);
	SM_avr_UsRefPu.push([29.0,1.127905]);
	SM_avr_UsRefPu.push([30.0,1.127905]);

	datasRead=[
	{
		label:"SM_gen_omegaPu",
		data:SM_gen_omegaPu
	},
	{
		label:"SM_avr_UsRefPu",
		data:SM_avr_UsRefPu
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
