/*
 * Copyright (c) 2026, RTE (http://www.rte-france.com)
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

/*
 * Minimal dependency-free SVG chart comparing an output curve with its reference:
 * - main plot: output (solid) and reference (dashed)
 * - error plot: output - reference (reference interpolated on the output time grid)
 * Drag to zoom on time, double-click to reset, hover for values.
 */
(function () {
  "use strict";

  const NS = "http://www.w3.org/2000/svg";
  const MARGIN = { left: 64, right: 14, top: 10, bottom: 22 };
  const MAIN_HEIGHT = 320;
  const ERROR_HEIGHT = 130;
  const GAP = 18;

  function svgElement(name, attrs, parent) {
    const node = document.createElementNS(NS, name);
    for (const key in attrs) node.setAttribute(key, attrs[key]);
    if (parent) parent.appendChild(node);
    return node;
  }

  function formatNumber(value) {
    if (value === null || value === undefined || Number.isNaN(value)) return "—";
    if (value === 0) return "0";
    const abs = Math.abs(value);
    if (abs >= 1e5 || abs < 1e-3) return value.toExponential(3);
    return Number(value.toPrecision(6)).toString();
  }

  function niceTicks(min, max, count) {
    if (!(max > min)) return [min];
    const rawStep = (max - min) / count;
    const magnitude = Math.pow(10, Math.floor(Math.log10(rawStep)));
    const residual = rawStep / magnitude;
    const step = (residual > 5 ? 10 : residual > 2 ? 5 : residual > 1 ? 2 : 1) * magnitude;
    const ticks = [];
    for (let tick = Math.ceil(min / step) * step; tick <= max + step * 1e-9; tick += step) {
      ticks.push(Math.abs(tick) < step * 1e-9 ? 0 : tick);
    }
    return ticks;
  }

  // index of the first time strictly greater than x
  function upperBound(times, x) {
    let low = 0;
    let high = times.length;
    while (low < high) {
      const mid = (low + high) >> 1;
      if (times[mid] <= x) low = mid + 1; else high = mid;
    }
    return low;
  }

  function interpolate(series, x) {
    if (!series || series.t.length === 0) return NaN;
    const t = series.t;
    const v = series.v;
    if (x < t[0] || x > t[t.length - 1]) return NaN;
    const index = upperBound(t, x);
    if (index >= t.length) return v[t.length - 1] === null ? NaN : v[t.length - 1];
    if (index === 0) return v[0] === null ? NaN : v[0];
    const t0 = t[index - 1];
    const t1 = t[index];
    const v0 = v[index - 1];
    const v1 = v[index];
    if (v0 === null || v1 === null) return NaN;
    if (t1 === t0) return v1;
    return v0 + (v1 - v0) * (x - t0) / (t1 - t0);
  }

  // Display-only threshold used to highlight where the curves visibly diverge:
  // |output - reference| > DIVERGENCE_RELATIVE_THRESHOLD * max(1, max |value| of both curves),
  // the same normalization as the nrtDiff time-aligned error.
  // The OK/KO verdict itself comes from the nrtDiff criteria, computed by the server.
  const DIVERGENCE_RELATIVE_THRESHOLD = 1e-3;

  function computeDivergence(error, out, ref) {
    if (!error || !out || !ref || error.t.length === 0) return null;
    let amplitude = 0;
    for (const series of [out, ref]) {
      for (const value of series.v) {
        if (value !== null && Math.abs(value) > amplitude) amplitude = Math.abs(value);
      }
    }
    const threshold = DIVERGENCE_RELATIVE_THRESHOLD * Math.max(1, amplitude);
    const t = error.t;
    // zones separated by less than 1% of the simulation are merged to keep the display readable
    const gap = ((t[t.length - 1] - t[0]) || 1) * 0.01;
    const zones = [];
    let start = null;
    let last = null;
    for (let i = 0; i < t.length; i++) {
      const value = error.v[i];
      if (value !== null && Math.abs(value) > threshold) {
        if (start === null) start = t[i];
        last = t[i];
      } else if (start !== null && t[i] - last > gap) {
        zones.push([start, last]);
        start = null;
      }
    }
    if (start !== null) zones.push([start, last]);
    return { threshold, zones, firstTime: zones.length ? zones[0][0] : null };
  }

  function errorSeries(out, ref) {
    const values = out.t.map((x, i) => {
      const reference = interpolate(ref, x);
      return out.v[i] === null || Number.isNaN(reference) ? null : out.v[i] - reference;
    });
    return { t: out.t, v: values };
  }

  // Keep first/min/max/last points per pixel column so that peaks survive downsampling
  function decimate(series, x0, x1, width) {
    const t = series.t;
    const v = series.v;
    const start = Math.max(0, upperBound(t, x0) - 1);
    const end = Math.min(t.length, upperBound(t, x1) + 1);
    if (end - start <= width * 4) {
      const points = [];
      for (let i = start; i < end; i++) points.push(i);
      return points;
    }
    const points = [];
    const span = (x1 - x0) || 1;
    let column = null;
    let first = -1, last = -1, min = -1, max = -1;
    const flush = () => {
      if (first < 0) return;
      const picked = [first, min, max, last].filter((value, index, array) => value >= 0 && array.indexOf(value) === index);
      picked.sort((a, b) => a - b);
      points.push(...picked);
    };
    for (let i = start; i < end; i++) {
      const c = Math.floor((t[i] - x0) / span * width);
      if (c !== column) {
        flush();
        column = c;
        first = last = min = max = -1;
      }
      if (v[i] === null) continue;
      if (first < 0) first = i;
      last = i;
      if (min < 0 || v[i] < v[min]) min = i;
      if (max < 0 || v[i] > v[max]) max = i;
    }
    flush();
    return points;
  }

  function valueRange(seriesList, x0, x1) {
    let min = Infinity;
    let max = -Infinity;
    for (const series of seriesList) {
      if (!series) continue;
      const start = Math.max(0, upperBound(series.t, x0) - 1);
      const end = Math.min(series.t.length, upperBound(series.t, x1) + 1);
      for (let i = start; i < end; i++) {
        const value = series.v[i];
        if (value === null || Number.isNaN(value)) continue;
        if (value < min) min = value;
        if (value > max) max = value;
      }
    }
    if (!Number.isFinite(min)) return [-1, 1];
    if (max - min < 1e-12 * Math.max(1, Math.abs(max))) {
      const pad = Math.abs(max) * 0.01 || 1;
      return [min - pad, max + pad];
    }
    const pad = (max - min) * 0.06;
    return [min - pad, max + pad];
  }

  class ComparisonChart {
    constructor(container, data) {
      this.container = container;
      this.out = data.out;
      this.ref = data.ref;
      this.tMax = data.tMax;
      this.showError = data.showError !== false;
      this.error = this.out && this.ref ? errorSeries(this.out, this.ref) : null;
      this.divergence = computeDivergence(this.error, this.out, this.ref);
      const all = [this.out, this.ref].filter(Boolean);
      this.fullDomain = [
        Math.min(...all.map(s => s.t.length ? s.t[0] : Infinity)),
        Math.max(...all.map(s => s.t.length ? s.t[s.t.length - 1] : -Infinity))
      ];
      if (!(this.fullDomain[1] > this.fullDomain[0])) this.fullDomain = [this.fullDomain[0] - 1, this.fullDomain[0] + 1];
      this.domain = this.fullDomain.slice();
      this.tip = document.createElement("div");
      this.tip.className = "chart-tip";
      document.body.appendChild(this.tip);
      this.resizeObserver = new ResizeObserver(() => this.draw());
      this.resizeObserver.observe(container);
      this.draw();
    }

    destroy() {
      this.resizeObserver.disconnect();
      this.tip.remove();
      this.container.innerHTML = "";
    }

    setDomain(x0, x1) {
      this.domain = [Math.max(this.fullDomain[0], x0), Math.min(this.fullDomain[1], x1)];
      if (!(this.domain[1] > this.domain[0])) this.domain = this.fullDomain.slice();
      this.draw();
    }

    resetZoom() { this.setDomain(this.fullDomain[0], this.fullDomain[1]); }

    setShowError(showError) {
      this.showError = showError;
      this.draw();
    }

    zoomOnMaxError() {
      if (this.tMax === null || this.tMax === undefined) return;
      const span = (this.fullDomain[1] - this.fullDomain[0]) * 0.05;
      this.setDomain(this.tMax - span, this.tMax + span);
    }

    draw() {
      const width = this.container.clientWidth;
      if (width <= 0) return;
      const plotWidth = width - MARGIN.left - MARGIN.right;
      // the reference is drawn first as a wide translucent band, the output on top as a thin line:
      // superposed curves show a thin line centered in the band
      const plots = [{ series: [this.ref, this.out], classes: ["s-ref", "s-out"], height: MAIN_HEIGHT, title: null }];
      if (this.error && this.showError) plots.push({ series: [this.error], classes: ["s-err"], height: ERROR_HEIGHT, title: "output − reference", zero: true, threshold: true });
      const totalHeight = plots.reduce((sum, plot) => sum + plot.height + MARGIN.top + MARGIN.bottom, 0) + GAP * (plots.length - 1);

      this.container.innerHTML = "";
      const svg = svgElement("svg", { class: "chart", viewBox: "0 0 " + width + " " + totalHeight, height: totalHeight, role: "img" }, this.container);
      const [x0, x1] = this.domain;
      const xScale = x => MARGIN.left + (x - x0) / (x1 - x0) * plotWidth;
      const xInverse = px => x0 + (px - MARGIN.left) / plotWidth * (x1 - x0);

      let top = 0;
      const plotGeometries = [];
      const clipId = "clip-" + Math.random().toString(36).slice(2);
      plots.forEach((plot, plotIndex) => {
        const y0 = top + MARGIN.top;
        const y1 = y0 + plot.height;
        const [vMin, vMax] = valueRange(plot.series, x0, x1);
        const yScale = v => y1 - (v - vMin) / (vMax - vMin) * plot.height;
        const group = svgElement("g", {}, svg);
        svgElement("clipPath", { id: clipId + plotIndex }, group).appendChild(
          svgElement("rect", { x: MARGIN.left, y: y0, width: plotWidth, height: plot.height }));

        if (this.divergence) {
          for (const [z0, z1] of this.divergence.zones) {
            if (z1 < x0 || z0 > x1) continue;
            const left = xScale(Math.max(z0, x0));
            const right = xScale(Math.min(z1, x1));
            svgElement("rect", { class: "zone", x: Math.min(left, right - 1), y: y0, width: Math.max(2, right - left), height: plot.height }, group);
          }
        }

        for (const tick of niceTicks(vMin, vMax, plot.height > 200 ? 6 : 3)) {
          const y = yScale(tick);
          svgElement("line", { class: "grid", x1: MARGIN.left, x2: MARGIN.left + plotWidth, y1: y, y2: y }, group);
          svgElement("text", { class: "axis-label", x: MARGIN.left - 6, y: y + 3.5, "text-anchor": "end" }, group).textContent = formatNumber(tick);
        }
        for (const tick of niceTicks(x0, x1, Math.max(2, Math.floor(plotWidth / 90)))) {
          const x = xScale(tick);
          svgElement("line", { class: "grid", x1: x, x2: x, y1: y0, y2: y1 }, group);
          svgElement("text", { class: "axis-label", x: x, y: y1 + 14, "text-anchor": "middle" }, group).textContent = formatNumber(tick);
        }
        if (plot.title) {
          svgElement("text", { class: "title", x: MARGIN.left + 4, y: y0 + 11 }, group).textContent = plot.title;
        }
        if (plot.zero && vMin < 0 && vMax > 0) {
          svgElement("line", { class: "zero", x1: MARGIN.left, x2: MARGIN.left + plotWidth, y1: yScale(0), y2: yScale(0) }, group);
        }
        if (plot.threshold && this.divergence) {
          for (const level of [this.divergence.threshold, -this.divergence.threshold]) {
            if (level <= vMin || level >= vMax) continue;
            svgElement("line", { class: "threshold", x1: MARGIN.left, x2: MARGIN.left + plotWidth, y1: yScale(level), y2: yScale(level) }, group);
          }
        }
        if (this.tMax !== null && this.tMax !== undefined && this.tMax >= x0 && this.tMax <= x1) {
          svgElement("line", { class: "tmax", x1: xScale(this.tMax), x2: xScale(this.tMax), y1: y0, y2: y1 }, group);
        }
        plot.series.forEach((series, seriesIndex) => {
          if (!series) return;
          const indices = decimate(series, x0, x1, plotWidth);
          let path = "";
          let pen = false;
          for (const i of indices) {
            const value = series.v[i];
            if (value === null || Number.isNaN(value)) { pen = false; continue; }
            path += (pen ? "L" : "M") + xScale(series.t[i]).toFixed(1) + " " + yScale(value).toFixed(1);
            pen = true;
          }
          svgElement("path", { class: plot.classes[seriesIndex], d: path, "clip-path": "url(#" + clipId + plotIndex + ")" }, group);
        });
        plotGeometries.push({ y0, y1 });
        top = y1 + MARGIN.bottom + GAP;
      });

      // interaction layer
      const cursor = svgElement("line", { class: "cursor", y1: 0, y2: totalHeight, visibility: "hidden" }, svg);
      const zoomRect = svgElement("rect", { class: "zoom-rect", y: 0, height: totalHeight, visibility: "hidden" }, svg);
      const overlay = svgElement("rect", { x: MARGIN.left, y: 0, width: plotWidth, height: totalHeight, fill: "transparent", style: "cursor: crosshair" }, svg);
      let dragStart = null;
      const localX = event => {
        const box = svg.getBoundingClientRect();
        return Math.min(MARGIN.left + plotWidth, Math.max(MARGIN.left, (event.clientX - box.left) * width / box.width));
      };
      overlay.addEventListener("pointerdown", event => {
        dragStart = localX(event);
        overlay.setPointerCapture(event.pointerId);
      });
      overlay.addEventListener("pointermove", event => {
        const px = localX(event);
        cursor.setAttribute("x1", px);
        cursor.setAttribute("x2", px);
        cursor.setAttribute("visibility", "visible");
        if (dragStart !== null) {
          zoomRect.setAttribute("x", Math.min(dragStart, px));
          zoomRect.setAttribute("width", Math.abs(px - dragStart));
          zoomRect.setAttribute("visibility", "visible");
        }
        const x = xInverse(px);
        const out = interpolate(this.out, x);
        const ref = interpolate(this.ref, x);
        let html = "t = " + formatNumber(x);
        if (this.out) html += "<br><span style='color:var(--series-out)'>output</span>    " + formatNumber(out);
        if (this.ref) html += "<br><span style='color:var(--series-ref)'>reference</span> " + formatNumber(ref);
        if (this.out && this.ref && this.showError) html += "<br><span style='color:var(--series-err)'>diff</span>      " + formatNumber(out - ref);
        this.tip.innerHTML = html;
        this.tip.style.display = "block";
        const tipWidth = this.tip.offsetWidth;
        const left = event.clientX + 14 + tipWidth > window.innerWidth ? event.clientX - 14 - tipWidth : event.clientX + 14;
        this.tip.style.left = left + "px";
        this.tip.style.top = (event.clientY + 14) + "px";
      });
      overlay.addEventListener("pointerleave", () => {
        cursor.setAttribute("visibility", "hidden");
        this.tip.style.display = "none";
      });
      overlay.addEventListener("pointerup", event => {
        if (dragStart === null) return;
        const px = localX(event);
        const start = dragStart;
        dragStart = null;
        zoomRect.setAttribute("visibility", "hidden");
        if (Math.abs(px - start) > 4) this.setDomain(xInverse(Math.min(start, px)), xInverse(Math.max(start, px)));
      });
      overlay.addEventListener("dblclick", () => this.resetZoom());
    }
  }

  window.NrtChart = { ComparisonChart, formatNumber, DIVERGENCE_RELATIVE_THRESHOLD };
})();
