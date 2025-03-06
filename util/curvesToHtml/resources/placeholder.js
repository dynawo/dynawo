/*
 * Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
 * See AUTHORS.txt
 * All rights reserved.
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, you can obtain one at http://mozilla.org/MPL/2.0/.
 * SPDX-License-Identifier: MPL-2.0
 *
 * This file is part of Dynawo, an hybrid C++/Modelica open source time domain
 * simulation tool for power systems.
 */

var plot;
var dataToPlot;
var dataId;
var oldOptions;

$(function () {

  dataToPlot= [];
  dataId=[];

    var placeholder = $("#placeholder");

    var options = {
      xaxis: { show: true, ticks: 5, min: 0 },
      yaxis: { show: true, ticks: 3 },
      series: { lines: { show: true },
        point:{ radius: 3, show: true },
        shadowSize: 5
    },
      zoom: {interactive: false },
      pan: {interactive: false },
      crosshair: { mode: "xy" },
      grid: { color: "#67523F",
        backgroundColor: { colors: ["#fff", "#e9e9e9"] },
        hoverable: true,
        autoHighlight: true
      },
      selection: { mode: "xy" },
      legend: { show : false }
    };
    oldOptions = options;
    plot = $.plot(placeholder, dataToPlot, options);

    $("#resetButton").click(function() {
  plot=$.plot(placeholder, dataToPlot, options);
      });

    $("#zoomOut").click(function() {
  plot.zoomOut();
      });

    $("#zoomIn").click(function() {
  plot.zoom();
      });

    $("#resetGraph").click(function() {
  resetGraph();
      });

    $("#arrow-left").click(function() {
  plot.pan({ left: -10 });
      });

    $("#arrow-right").click(function() {
  plot.pan({ left: 10 });
      });

    $("#arrow-up").click(function() {
  plot.pan({ top: -10 });
      });

    $("#arrow-down").click(function() {
  plot.pan({ top: 10 });
      });

    $("#placeholder").bind("plotselected", function (event, ranges) {
        // clamp the zooming to prevent eternal zoom
        if (ranges.xaxis.to - ranges.xaxis.from < 0.00001)
    ranges.xaxis.to = ranges.xaxis.from + 0.00001;
        if (ranges.yaxis.to - ranges.yaxis.from < 0.00001)
    ranges.yaxis.to = ranges.yaxis.from + 0.00001;

        // do the zooming
        plot = $.plot($("#placeholder"), dataToPlot,
                      $.extend(true, {}, options, {
                          xaxis: { min: ranges.xaxis.from, max: ranges.xaxis.to },
                          yaxis: { min: ranges.yaxis.from, max: ranges.yaxis.to },
        }));
     });

  $("<div id='tooltip'></div>").css({
    position: "absolute",
    display: "none",
    border: "1px solid #fdd",
    padding: "2px",
    opacity: 1.0,
    "font-size": "small",
  }).appendTo("body");

  $("#placeholder").bind("plothover", function (event, pos, item) {
    if (!pos.x || !pos.y) {
      return;
    }
    if (item) {
      var x = item.datapoint[0],
          y = item.datapoint[1];

      $("#tooltip").html(x + "<br />" + y)
        .css({top: item.pageY+5, left: item.pageX+5, backgroundColor: item.series.color + "30"})
        .fadeIn(50);
    } else {
      $("#tooltip").hide();
    }
  });
});
