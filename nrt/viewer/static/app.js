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

(function () {
  "use strict";

  const app = document.getElementById("app");
  const formatNumber = window.NrtChart.formatNumber;

  // the list scroll position is restored by route(), not by the browser
  if ("scrollRestoration" in history) history.scrollRestoration = "manual";

  const state = {
    results: null,
    filter: { category: "failing", search: "", family: "" },
    sort: { key: "status", asc: true },
    currentCase: null, // id of the case displayed in the case view
    tree: null,
    chart: null,
    showError: readPreference("showError", true),
    curvesKoOnly: readPreference("curvesKoOnly", false),
    filesKoOnly: readPreference("filesKoOnly", true)
  };

  // per-viewer display preferences (storage may be unavailable: fall back to defaults)
  function readPreference(key, defaultValue) {
    try {
      const value = localStorage.getItem("nrtViewer." + key);
      return value === null ? defaultValue : JSON.parse(value);
    } catch (error) {
      return defaultValue;
    }
  }

  function writePreference(key, value) {
    try {
      localStorage.setItem("nrtViewer." + key, JSON.stringify(value));
    } catch (error) {
      // ignored: the preference is simply not remembered
    }
  }

  // ---------------------------------------------------------------- utils

  function escapeHtml(text) {
    return String(text === null || text === undefined ? "" : text)
      .replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
  }

  async function api(path, params) {
    const query = params ? "?" + new URLSearchParams(params).toString() : "";
    const response = await fetch("/api/" + path + query);
    const payload = await response.json();
    if (!response.ok) throw new Error(payload && payload.error ? payload.error : response.statusText);
    return payload;
  }

  async function post(path, body) {
    const response = await fetch("/api/" + path, {
      method: "POST",
      headers: { "Content-Type": "application/json", "X-NRT-Viewer": "1" },
      body: JSON.stringify(body)
    });
    const payload = await response.json();
    if (!response.ok) throw new Error(payload && payload.error ? payload.error : response.statusText);
    return payload;
  }

  let toastTimer = null;
  function toast(message, isError) {
    const node = document.getElementById("toast");
    node.textContent = message;
    node.className = "toast show" + (isError ? " error" : "");
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => { node.className = "toast" + (isError ? " error" : ""); }, isError ? 6000 : 3000);
  }

  function formatDuration(seconds) {
    if (seconds === null || seconds === undefined) return "—";
    if (seconds < 1) return seconds.toFixed(2) + " s";
    if (seconds < 60) return seconds.toFixed(1) + " s";
    const minutes = Math.floor(seconds / 60);
    return minutes + " min " + Math.round(seconds - minutes * 60) + " s";
  }

  function splitPath(path) {
    const index = path.lastIndexOf("/");
    return index < 0 ? ["", path] : [path.slice(0, index + 1), path.slice(index + 1)];
  }

  // ---------------------------------------------------------------- case classification

  const CATEGORIES = {
    simko:   { label: "Simulation KO", badge: "SIM KO",  cls: "ko",   rank: 0, failing: true },
    toolong: { label: "Too long",      badge: "TIMEOUT", cls: "ko",   rank: 1, failing: true },
    diffko:  { label: "Comparison KO", badge: "DIFF KO", cls: "ko",   rank: 2, failing: true },
    warn:    { label: "Within tolerance", badge: "WARN", cls: "warn", rank: 3, failing: false },
    noref:   { label: "No reference",  badge: "NO REF",  cls: "",     rank: 4, failing: false },
    ok:      { label: "OK",            badge: "OK",      cls: "ok",   rank: 5, failing: false }
  };

  function category(testCase) {
    if (testCase.simulation_status === "TOO_LONG") return "toolong";
    if (testCase.simulation_status === "KO") return "simko";
    if (testCase.diff_status === "KO") return "diffko";
    if (testCase.diff_status === "Warn") return "warn";
    if (testCase.diff_status === "NoReference" || testCase.diff_status === "Unable") return "noref";
    return "ok";
  }

  function fileKind(path) {
    const lower = path.toLowerCase();
    const name = lower.split("/").pop();
    if (name.startsWith("curves") || lower.includes("/curves/")) return "Curves";
    if (lower.includes("timeline")) return "Timeline";
    if (lower.includes("constraint")) return "Constraints";
    if (lower.includes("finalstatevalues") || lower.includes("/fsv")) return "Final state values";
    if (lower.includes("finalvalues")) return "Final values";
    if (lower.includes("initvalues")) return "Init values";
    if (lower.includes("lineari")) return "Linearization";
    if (name.startsWith("outputiidm") || lower.endsWith(".iidm") || lower.endsWith(".xiidm")) return "IIDM";
    if (lower.endsWith(".log")) return "Logs";
    return "Other";
  }

  function isCurvesFile(path) {
    return /(^|\/)curves[^/]*\.(csv|xml|h5|hdf5)$/i.test(path) && !path.includes("curvesOutput");
  }

  function isBinaryFile(path) {
    return /\.(h5|hdf5)$/i.test(path);
  }

  // same rule as nrtDiff (outputIIDM*.xml) plus the native IIDM extensions
  function isIidmFile(path) {
    const name = path.split("/").pop().toLowerCase();
    return (name.includes("outputiidm") && name.endsWith(".xml")) || /\.x?iidm$/.test(name);
  }

  function failingFiles(testCase) {
    return (testCase.compared_files || []).filter(f => f.status === "KO" || f.status === "Warn");
  }

  const REASON_MAX_LENGTH = 160;
  const REASON_MAX_FILES = 3;
  const MESSAGES_OPEN_MAX_LENGTH = 400;  // longer nrtDiff messages start collapsed

  function truncate(text, maxLength) {
    return text.length > maxLength ? text.slice(0, maxLength - 1) + "…" : text;
  }

  // e.g. "3 files different: curves.csv, outputIIDM.xml, timeline.log (+2 more)"
  function fileListSummary(files, what) {
    const names = files.slice(0, REASON_MAX_FILES).map(f => f.path.split("/").pop());
    const more = files.length > REASON_MAX_FILES ? " (+" + (files.length - REASON_MAX_FILES) + " more)" : "";
    return files.length + " file" + (files.length === 1 ? "" : "s") + " " + what + ": " + names.join(", ") + more;
  }

  function reason(testCase) {
    const cat = category(testCase);
    const files = failingFiles(testCase);
    if (cat === "simko") {
      const lines = (testCase.console_errors || "").split("\n").map(l => l.trim()).filter(Boolean);
      return { msg: "Simulation failed (return code " + testCase.return_code + ")", sub: lines.slice(-3).join("\n") };
    }
    if (cat === "toolong") return { msg: "Simulation exceeded the timeout", sub: "" };
    if (cat === "diffko") {
      const ko = files.filter(f => f.status === "KO");
      if (ko.length) return { msg: fileListSummary(ko, "different"), sub: "" };
      const messages = testCase.diff_messages || [];
      return { msg: messages.length ? truncate(messages[0], REASON_MAX_LENGTH) : "Comparison failed", sub: "" };
    }
    if (cat === "warn") return { msg: fileListSummary(files, "within tolerance"), sub: "" };
    if (cat === "noref") return { msg: testCase.diff_label || "No reference data", sub: "" };
    return { msg: "", sub: "" };
  }

  function tags(testCase) {
    const kinds = new Set(failingFiles(testCase).map(f => fileKind(f.path)));
    return Array.from(kinds);
  }

  // ---------------------------------------------------------------- top bar

  function renderRunInfo() {
    const results = state.results;
    const parts = [];
    parts.push("<span>Branch <b>" + escapeHtml(results.branch) + "</b></span>");
    parts.push("<span>" + escapeHtml((results.date || "").replace("T", " ")) + "</span>");
    parts.push("<span>" + results.cases.length + " cases · " + formatDuration(results.real_time) + " on " + results.nb_processors + " proc.</span>");
    if (results.read_only) parts.push("<span class='badge info'>read-only</span>");
    parts.push("<span class='path' title='" + escapeHtml(results.results_file) + "'>" + escapeHtml(results.results_file) + "</span>");
    document.getElementById("run-info").innerHTML = parts.join("");
  }

  // ---------------------------------------------------------------- list view

  function renderList() {
    destroyChart();
    state.currentCase = null;
    const cases = state.results.cases;
    const counts = { all: cases.length, failing: 0 };
    for (const key in CATEGORIES) counts[key] = 0;
    for (const testCase of cases) {
      const cat = category(testCase);
      counts[cat]++;
      if (CATEGORIES[cat].failing) counts.failing++;
    }
    const families = Array.from(new Set(cases.map(c => c.family))).sort();

    const stat = (key, label, cls) =>
      "<button class='stat " + cls + (state.filter.category === key ? " active" : "") + "' data-category='" + key + "'>" +
      "<div class='value'>" + counts[key] + "</div><div class='label'>" + label + "</div></button>";

    app.innerHTML =
      "<div class='stats'>" +
        stat("failing", "Failing cases", counts.failing ? "ko" : "ok") +
        stat("simko", "Simulation KO", counts.simko ? "ko" : "") +
        stat("toolong", "Too long", counts.toolong ? "ko" : "") +
        stat("diffko", "Comparison KO", counts.diffko ? "ko" : "") +
        stat("warn", "Within tolerance", counts.warn ? "warn" : "") +
        stat("noref", "No reference", "") +
        stat("all", "All cases", "") +
      "</div>" +
      "<div class='toolbar'>" +
        "<input type='search' id='search' placeholder='Filter by name, directory or reason…' value='" + escapeHtml(state.filter.search) + "'>" +
        "<select id='family'><option value=''>All families</option>" +
          families.map(f => "<option" + (f === state.filter.family ? " selected" : "") + ">" + escapeHtml(f) + "</option>").join("") +
        "</select>" +
        "<span class='count' id='count'></span>" +
      "</div>" +
      "<div class='table-wrap'><table class='cases'><thead><tr>" +
        header("status", "Status") + header("name", "Test case") + header("reason", "Reason") +
        header("time", "Time") + header("code", "Code") +
      "</tr></thead><tbody id='rows'></tbody></table></div>";

    app.querySelectorAll(".stat").forEach(button => button.addEventListener("click", () => {
      state.filter.category = button.dataset.category;
      renderList();
    }));
    const search = document.getElementById("search");
    search.addEventListener("input", () => { state.filter.search = search.value; renderRows(); });
    document.getElementById("family").addEventListener("change", event => { state.filter.family = event.target.value; renderRows(); });
    app.querySelectorAll("th[data-key]").forEach(th => th.addEventListener("click", () => {
      if (state.sort.key === th.dataset.key) state.sort.asc = !state.sort.asc;
      else state.sort = { key: th.dataset.key, asc: true };
      renderList();
    }));
    renderRows();
  }

  function header(key, label) {
    const sorted = state.sort.key === key;
    return "<th data-key='" + key + "' class='" + (sorted ? "sorted" + (state.sort.asc ? " asc" : "") : "") + "'>" + label + "</th>";
  }

  function renderRows() {
    const filter = state.filter;
    const search = filter.search.trim().toLowerCase();
    let cases = state.results.cases.filter(testCase => {
      const cat = category(testCase);
      if (filter.category === "failing" && !CATEGORIES[cat].failing) return false;
      if (filter.category !== "failing" && filter.category !== "all" && filter.category !== cat) return false;
      if (filter.family && testCase.family !== filter.family) return false;
      if (search) {
        const r = reason(testCase);
        const haystack = [testCase.name, testCase.directory, testCase.description, r.msg, r.sub].concat(testCase.diff_messages || []).join(" ").toLowerCase();
        if (!haystack.includes(search)) return false;
      }
      return true;
    });

    const key = state.sort.key;
    const value = testCase => {
      switch (key) {
        case "status": return CATEGORIES[category(testCase)].rank;
        case "name": return testCase.directory.toLowerCase();
        case "reason": return reason(testCase).msg.toLowerCase();
        case "time": return -testCase.time;
        case "code": return testCase.return_code;
      }
      return 0;
    };
    cases.sort((a, b) => {
      const va = value(a), vb = value(b);
      const order = va < vb ? -1 : va > vb ? 1 : a.directory.localeCompare(b.directory);
      return state.sort.asc ? order : -order;
    });

    document.getElementById("count").textContent = cases.length + " / " + state.results.cases.length + " cases";
    const rows = document.getElementById("rows");
    if (cases.length === 0) {
      const message = filter.category === "failing" && !search && !filter.family ? "No failing test case 🎉" : "No test case matches the filters";
      rows.innerHTML = "<tr><td colspan='5' class='empty'>" + message + "</td></tr>";
      return;
    }
    rows.innerHTML = cases.map(testCase => {
      const cat = CATEGORIES[category(testCase)];
      const r = reason(testCase);
      const updated = testCase.reference_updated && testCase.reference_updated.length
        ? " <span class='badge info'>reference updated</span>" : "";
      return "<tr data-case='" + escapeHtml(testCase.case) + "'>" +
        "<td><span class='badge " + cat.cls + "'>" + cat.badge + "</span></td>" +
        "<td class='name'><div>" + escapeHtml(testCase.name) + updated + "</div><div class='dir'>" + escapeHtml(testCase.directory) + "</div></td>" +
        "<td class='reason' title='" + escapeHtml((testCase.diff_messages || []).join("\n") || r.msg) + "'>" + tags(testCase).map(t => "<span class='tag'>" + escapeHtml(t) + "</span>").join("") +
          "<span class='msg'>" + escapeHtml(r.msg) + "</span>" + (r.sub ? "<div class='sub'>" + escapeHtml(r.sub) + "</div>" : "") + "</td>" +
        "<td class='num'>" + formatDuration(testCase.time) + "</td>" +
        "<td class='num'>" + escapeHtml(testCase.return_code) + "</td>" +
        "</tr>";
    }).join("");
    rows.querySelectorAll("tr[data-case]").forEach(row => row.addEventListener("click", () => {
      location.hash = "#/case/" + encodeURIComponent(row.dataset.case);
    }));
  }

  // ---------------------------------------------------------------- case view

  function findCase(id) {
    return state.results.cases.find(c => c.case === id);
  }

  async function renderCase(id, params) {
    const testCase = findCase(id);
    if (!testCase) {
      app.innerHTML = "<p class='placeholder'>Unknown test case " + escapeHtml(id) + ". <a href='#/'>Back to the list</a></p>";
      return;
    }
    if (state.currentCase === id && state.tree) {
      renderFileViewer(testCase, params);
      return;
    }
    destroyChart();
    state.currentCase = id;
    state.tree = null;
    const cat = CATEGORIES[category(testCase)];
    const r = reason(testCase);
    const messages = testCase.diff_messages || [];
    const updated = testCase.reference_updated || [];
    const nbFailingFiles = failingFiles(testCase).length;
    const acceptLabel = "Update reference" + (nbFailingFiles ? " (" + nbFailingFiles + " file" + (nbFailingFiles === 1 ? "" : "s") + " to review)" : "") + "…";

    app.innerHTML =
      "<div class='crumbs'><a href='#/'>← All cases</a> · " + escapeHtml(testCase.family) + "</div>" +
      "<div class='case-header'><h1>" + escapeHtml(testCase.name) + "</h1>" +
        "<span class='badge " + cat.cls + "'>" + cat.badge + "</span>" +
        (updated.length ? "<span class='badge info'>reference updated</span>" : "") +
        "<span class='spacer'></span>" +
        "<button class='btn btn-update" + (nbFailingFiles ? " btn-danger" : "") + "' id='accept-button'" +
          (state.results.read_only ? " disabled title='Viewer started in read-only mode'" : "") + ">" + escapeHtml(acceptLabel) + "</button>" +
      "</div>" +
      "<div class='case-sub'>" + escapeHtml(testCase.description) + "</div>" +
      "<div class='case-layout'>" +
        // sticky side column: the file list stays reachable while the viewer is scrolled
        "<div class='case-side'>" +
          "<section class='panel'><h2>Files<span class='spacer'></span>" +
            "<label class='check' title='Only show the files whose comparison with the reference failed'>" +
            "<input type='checkbox' id='files-ko-only'" + (state.filesKoOnly ? " checked" : "") + "> KO only</label></h2><div id='files'><p class='panel-body placeholder'>Loading…</p></div></section>" +
          "<section class='panel'><h2>Summary</h2><div class='panel-body'>" +
            "<dl class='props'>" +
              "<dt>Directory</dt><dd class='mono'>" + escapeHtml(testCase.directory) + "</dd>" +
              "<dt>Simulation</dt><dd>" + escapeHtml(testCase.simulation_status) + " · code " + escapeHtml(testCase.return_code) + " · " + formatDuration(testCase.time) + "</dd>" +
              "<dt>Comparison</dt><dd>" + escapeHtml(testCase.diff_label) + "</dd>" +
              (r.msg && cat !== CATEGORIES.ok ? "<dt>Reason</dt><dd>" + escapeHtml(r.msg) + "</dd>" : "") +
              "<dt>Jobs</dt><dd>" + (testCase.jobs || []).map(j => escapeHtml(j.name) + " <span class='tag'>" + escapeHtml(j.solver) + "</span>").join("<br>") + "</dd>" +
            "</dl>" +
            (messages.length ? "<details class='messages-block'" + (messages.join("").length <= MESSAGES_OPEN_MAX_LENGTH ? " open" : "") + ">" +
              "<summary>nrtDiff messages (" + messages.length + ")</summary>" +
              "<ul class='messages'>" + messages.map(m => "<li>" + escapeHtml(m) + "</li>").join("") + "</ul></details>" : "") +
            "<div class='command' style='margin-top:10px'><code>" + escapeHtml(testCase.command) + "</code>" +
              "<button class='btn btn-small' id='copy-command'>Copy</button></div>" +
          "</div></section>" +
          (testCase.console_errors ? "<section class='panel'><h2>Console errors</h2><div class='panel-body'><pre class='console'>" + escapeHtml(testCase.console_errors) + "</pre></div></section>" : "") +
        "</div>" +
        "<section class='panel' id='viewer'><div class='panel-body placeholder'>Select a file to display it.</div></section>" +
      "</div>";

    document.documentElement.style.setProperty("--topbar-height", topbarHeight() + "px");
    document.getElementById("copy-command").addEventListener("click", () => {
      navigator.clipboard.writeText(testCase.command).then(() => toast("Command copied"), () => toast("Copy failed", true));
    });
    document.getElementById("accept-button").addEventListener("click", () => openAcceptDialog(testCase));
    document.getElementById("files-ko-only").addEventListener("change", event => {
      state.filesKoOnly = event.target.checked;
      writePreference("filesKoOnly", state.filesKoOnly);
      if (!state.tree) return;
      renderFileList(testCase);
      markSelectedFile(new URLSearchParams(location.hash.split("?")[1] || "").get("file"));
    });

    try {
      const tree = await api("tree", { case: id });
      if (state.currentCase !== id) return;
      state.tree = tree.files;
      state.treeJobs = tree.jobs || [];
    } catch (error) {
      document.getElementById("files").innerHTML = "<p class='panel-body placeholder'>" + escapeHtml(error.message) + "</p>";
      return;
    }
    renderFileList(testCase);
    if (!params.get("file")) {
      const preferred = state.tree.find(f => f.status === "KO") || state.tree.find(f => f.status === "Warn") ||
        state.tree.find(f => isCurvesFile(f.path) && f.out);
      if (preferred) {
        history.replaceState(null, "", caseHash(id, preferred.path));
        params = new URLSearchParams({ file: preferred.path });
      }
    }
    renderFileViewer(testCase, params);
  }

  function caseHash(id, file, tab, variable) {
    const params = new URLSearchParams();
    if (file) params.set("file", file);
    if (tab) params.set("tab", tab);
    if (variable) params.set("var", variable);
    const query = params.toString();
    return "#/case/" + encodeURIComponent(id) + (query ? "?" + query : "");
  }

  const STATUS_RANK = { KO: 0, Warn: 1 };

  function statusDotClass(status) {
    return status === "KO" ? "ko" : status === "Warn" ? "warn" : status === "OK" ? "ok" : "";
  }

  function isFailing(file) {
    return file.status === "KO" || file.status === "Warn";
  }

  // Group files by job (in the jobs file order); files outside every job output directory go to a last group.
  // Returns a single anonymous group when there is no more than one job, so that simple cases stay flat.
  function groupFilesByJob(files) {
    const jobs = state.treeJobs || [];
    const groups = jobs.map(job => ({ job: job.job, title: job.name || job.job, solver: job.solver, outputDir: job.output_dir, files: [] }));
    const other = { job: null, title: "Other files", solver: "", outputDir: "", files: [] };
    for (const file of files) {
      const group = groups.find(g => g.job === file.job) || other;
      group.files.push(file);
    }
    const result = groups.filter(g => g.files.length);
    if (other.files.length) result.push(other);
    for (const group of result) {
      group.files.sort((a, b) => ((STATUS_RANK[a.status] ?? 2) - (STATUS_RANK[b.status] ?? 2)) || a.path.localeCompare(b.path));
      group.nbKO = group.files.filter(f => f.status === "KO").length;
      group.nbWarn = group.files.filter(f => f.status === "Warn").length;
    }
    if (result.length <= 1) {
      return [{ job: null, title: null, outputDir: result.length ? result[0].outputDir : "", files: result.length ? result[0].files : [] }];
    }
    return result;
  }

  // path displayed relatively to the job output directory (the full path is in the tooltip)
  function displayPath(file, outputDir) {
    if (outputDir && outputDir !== "." && file.path.startsWith(outputDir + "/")) return file.path.slice(outputDir.length + 1);
    return file.path;
  }

  function groupSummary(group) {
    const counts = [];
    if (group.nbKO) counts.push("<span class='badge ko'>" + group.nbKO + " KO</span>");
    if (group.nbWarn) counts.push("<span class='badge warn'>" + group.nbWarn + " warn</span>");
    counts.push("<span class='job-count'>" + group.files.length + " file" + (group.files.length === 1 ? "" : "s") + "</span>");
    return "<span class='job-title'>" + escapeHtml(group.title) + "</span>" +
      (group.solver ? "<span class='tag'>" + escapeHtml(group.solver) + "</span>" : "") +
      (group.outputDir && group.outputDir !== "." ? "<span class='job-dir'>" + escapeHtml(group.outputDir) + "/</span>" : "") +
      "<span class='spacer'></span>" + counts.join("");
  }

  // folders whose files are grouped in a collapsible sub-group of the file list (the matched prefix is hidden)
  const FILE_FOLDERS = [
    { title: "Init values", match: /^(.*\/)?initValues\// },
    { title: "Final values", match: /^(.*\/)?finalValues\// },
    { title: "Logs", match: /^(.*\/)?logs\// },
  ];

  function renderFileList(testCase) {
    const container = document.getElementById("files");
    if (!state.tree.length) {
      container.innerHTML = "<p class='panel-body placeholder'>No output nor reference file found</p>";
      return;
    }
    const renderItem = (file, shownPath) => {
      const [dir, name] = splitPath(shownPath);
      const sides = file.out && file.ref ? "out · ref" : file.out ? "out only" : "ref only";
      return "<li data-path='" + escapeHtml(file.path) + "' title='" + escapeHtml(file.path + (file.message ? "\n" + file.message : "")) + "'>" +
        "<span class='dot " + statusDotClass(file.status) + "'></span>" +
        "<span class='fname'><span class='fdir'>" + escapeHtml(dir) + "</span>" + escapeHtml(name) + "</span>" +
        "<span class='sides'>" + sides + "</span></li>";
    };
    // init values and logs can be numerous: they go to folder sub-groups, collapsed unless they hold a failing file
    const renderItems = (files, outputDir) => {
      const plain = [];
      const folders = [];
      files.forEach(file => {
        const shownPath = displayPath(file, outputDir);
        const folder = FILE_FOLDERS.find(f => f.match.test(shownPath));
        if (!folder) {
          plain.push(renderItem(file, shownPath));
          return;
        }
        let group = folders.find(g => g.folder === folder);
        if (!group) folders.push(group = { folder: folder, items: [], nbKO: 0, nbWarn: 0 });
        group.items.push(renderItem(file, shownPath.replace(folder.match, "")));
        if (file.status === "KO") group.nbKO++;
        if (file.status === "Warn") group.nbWarn++;
      });
      folders.sort((a, b) => FILE_FOLDERS.indexOf(a.folder) - FILE_FOLDERS.indexOf(b.folder));
      return "<ul class='files'>" + plain.join("") + "</ul>" + folders.map(group =>
        "<details class='folder-group'" + (group.nbKO || group.nbWarn ? " open" : "") + "><summary>" +
          "<span class='job-title'>" + escapeHtml(group.folder.title) + "</span><span class='spacer'></span>" +
          (group.nbKO ? "<span class='badge ko'>" + group.nbKO + " KO</span>" : "") +
          (group.nbWarn ? "<span class='badge warn'>" + group.nbWarn + " warn</span>" : "") +
          "<span class='job-count'>" + group.items.length + " file" + (group.items.length === 1 ? "" : "s") + "</span>" +
        "</summary><ul class='files'>" + group.items.join("") + "</ul></details>").join("");
    };

    // "KO only" is ignored when no comparison failed (OK cases): an empty list would be useless
    const failing = state.tree.filter(isFailing);
    const shown = state.filesKoOnly && failing.length ? failing : state.tree;
    const groups = groupFilesByJob(shown);
    if (groups.length === 1 && groups[0].title === null) {
      container.innerHTML = renderItems(groups[0].files, "");
    } else {
      // jobs with failing files are expanded, the others are collapsed
      const anyFailing = groups.some(g => g.nbKO || g.nbWarn);
      container.innerHTML = groups.map(group =>
        "<details class='job-group'" + (group.nbKO || group.nbWarn || !anyFailing ? " open" : "") + ">" +
          "<summary>" + groupSummary(group) + "</summary>" +
          renderItems(group.files, group.outputDir) +
        "</details>").join("");
    }
    container.querySelectorAll("li[data-path]").forEach(item => item.addEventListener("click", () => {
      location.hash = caseHash(testCase.case, item.dataset.path);
      // bring the top of the viewer back on screen if the page was scrolled down
      const viewer = document.getElementById("viewer");
      if (viewer && viewer.getBoundingClientRect().top < topbarHeight()) {
        window.scrollTo({ top: window.scrollY + viewer.getBoundingClientRect().top - topbarHeight() - 8 });
      }
    }));
  }

  // escaped text with the changed character ranges ([start, end[) wrapped in <mark>
  function highlightSpans(text, spans) {
    if (!spans || !spans.length) return escapeHtml(text);
    let html = "";
    let position = 0;
    for (const [start, end] of spans) {
      html += escapeHtml(text.slice(position, start)) + "<mark class='chg'>" + escapeHtml(text.slice(start, end)) + "</mark>";
      position = end;
    }
    return html + escapeHtml(text.slice(position));
  }

  function topbarHeight() {
    const topbar = document.querySelector(".topbar");
    return topbar ? topbar.offsetHeight : 0;
  }

  function markSelectedFile(path) {
    document.querySelectorAll("#files li[data-path]").forEach(item => {
      const selected = item.dataset.path === path;
      item.classList.toggle("selected", selected);
      // open every enclosing group (job, then folder) of the selected file
      for (let group = item.closest("details"); selected && group; group = group.parentElement.closest("details")) group.open = true;
    });
  }

  function renderFileViewer(testCase, params) {
    const path = params.get("file");
    markSelectedFile(path);
    const viewer = document.getElementById("viewer");
    if (!path) return;
    const file = state.tree.find(f => f.path === path);
    if (!file) {
      viewer.innerHTML = "<div class='panel-body placeholder'>File not found: " + escapeHtml(path) + "</div>";
      return;
    }
    const tabs = [];
    if (isCurvesFile(path)) tabs.push(["curves", "Curves"]);
    if (isIidmFile(path) && file.out && file.ref) tabs.push(["iidm", "IIDM"]);
    if (!isBinaryFile(path)) {
      if (file.out && file.ref) tabs.push(["diff", "Diff"]);
      if (file.out) tabs.push(["out", "Output"]);
      if (file.ref) tabs.push(["ref", "Reference"]);
    }
    if (!tabs.length) {
      viewer.innerHTML = "<div class='panel-body placeholder'>No viewer for this file: " + escapeHtml(path) + "</div>";
      return;
    }
    let tab = params.get("tab");
    if (!tabs.some(t => t[0] === tab)) tab = tabs[0][0];

    const statusBadge = file.status ? "<span class='badge " + ({ KO: "ko", Warn: "warn", OK: "ok" }[file.status] || "") + "'>" + escapeHtml(file.status) + "</span>" : "";
    viewer.innerHTML =
      "<h2><span class='viewer-title' title='" + escapeHtml(path) + "'>" + escapeHtml(path) + "</span>" + statusBadge + "</h2>" +
      "<div class='tabs'>" + tabs.map(t => "<button class='tab" + (t[0] === tab ? " active" : "") + "' data-tab='" + t[0] + "'>" + t[1] + "</button>").join("") + "</div>" +
      "<div class='viewer-body' id='viewer-body'><p class='placeholder'>Loading…</p></div>";
    viewer.querySelectorAll(".tab").forEach(button => button.addEventListener("click", () => {
      location.hash = caseHash(testCase.case, path, button.dataset.tab);
    }));

    destroyChart();
    const body = document.getElementById("viewer-body");
    const fail = error => { body.innerHTML = "<p class='placeholder'>" + escapeHtml(error.message) + "</p>"; };
    if (tab === "curves") renderCurves(testCase, file, body, params.get("var")).catch(fail);
    else if (tab === "iidm") renderIidm(testCase, file, body).catch(fail);
    else if (tab === "diff") renderDiff(testCase, file, body).catch(error => {
      const iidmHint = isIidmFile(file.path) && file.out && file.ref
        ? " <a href='" + escapeHtml(caseHash(testCase.case, file.path, "iidm")) + "'>Use the IIDM tab</a> to compare the network objects." : "";
      body.innerHTML = "<p class='placeholder'>" + escapeHtml(error.message) + "." + iidmHint + "</p>";
    });
    else renderRaw(testCase, file, tab, body).catch(fail);
  }

  // big files are displayed by chunks of lines to keep the browser responsive
  const RAW_CHUNK_LINES = 5000;

  async function renderRaw(testCase, file, side, body) {
    const first = await api("file", { case: testCase.case, side: side, path: file.path, offset: 0, limit: RAW_CHUNK_LINES });
    body.innerHTML =
      "<div class='viewer-note'><span id='raw-count'></span></div>" +
      "<div class='code-view'><table class='code'><tbody id='raw-lines'></tbody></table></div>" +
      "<div class='load-more'><button class='btn btn-small' id='raw-more'>Load " + RAW_CHUNK_LINES + " more lines</button></div>";
    const tbody = document.getElementById("raw-lines");
    const more = document.getElementById("raw-more");
    let loaded = 0;
    const append = payload => {
      let html = "";
      payload.lines.forEach((line, index) => {
        html += "<tr><td class='ln'>" + (payload.offset + index + 1) + "</td><td>" + escapeHtml(line) + "</td></tr>";
      });
      tbody.insertAdjacentHTML("beforeend", html);
      loaded = payload.offset + payload.lines.length;
      document.getElementById("raw-count").textContent = loaded < payload.total_lines
        ? "Lines 1–" + loaded + " of " + payload.total_lines : payload.total_lines + " lines";
      more.parentElement.style.display = loaded < payload.total_lines ? "" : "none";
    };
    append(first);
    more.addEventListener("click", async () => {
      more.disabled = true;
      try {
        append(await api("file", { case: testCase.case, side: side, path: file.path, offset: loaded, limit: RAW_CHUNK_LINES }));
      } catch (error) {
        toast(error.message, true);
      }
      more.disabled = false;
    });
  }

  // ---------------------------------------------------------------- IIDM comparison

  const IIDM_PAGE_SIZE = 100;

  const IIDM_CATEGORIES = {
    missing_left: { label: "missing in output", cls: "ko" },
    missing_right: { label: "missing in reference", cls: "ko" },
    attribute: { label: "attribute on one side", cls: "ko" },
    discrete: { label: "changed", cls: "ko" }
  };

  function iidmCategoryBadge(row) {
    if (row.category === "numeric") {
      return row.within_tolerance ? "<span class='badge'>within tol.</span>" : "<span class='badge ko'>Δ</span>";
    }
    const category = IIDM_CATEGORIES[row.category] || { label: row.category, cls: "" };
    return "<span class='badge " + category.cls + "'>" + escapeHtml(category.label) + "</span>";
  }

  async function renderIidm(testCase, file, body) {
    const filters = { within: false, type: "", attribute: "", search: "", offset: 0, sort: "delta" };
    body.innerHTML = "<p class='placeholder'>Comparing the network objects (this may take a while for big networks)…</p>";
    let searchTimer = null;

    const load = async () => {
      const payload = await api("iidm", {
        case: testCase.case, path: file.path, within: filters.within ? "1" : "0",
        type: filters.type, attribute: filters.attribute, search: filters.search,
        offset: filters.offset, limit: IIDM_PAGE_SIZE, sort: filters.sort
      });
      draw(payload);
    };

    // sortable delta columns (always largest first)
    const sortHeader = (key, label) =>
      "<th data-sort='" + key + "' class='" + (filters.sort === key ? "sorted" : "") + "' title='Sort by decreasing " + label + "'>" + label + "</th>";

    const draw = payload => {
      const total = payload.nb_beyond_tolerance + (filters.within ? payload.nb_within_tolerance : 0);
      const groupLabel = g => escapeHtml(g.type) + (g.attribute ? "." + escapeHtml(g.attribute) : "") +
        (g.category ? " <span class='tag'>" + escapeHtml(IIDM_CATEGORIES[g.category].label) + "</span>" : "");
      const isActive = g => filters.type === g.type && filters.attribute === (g.attribute || "");
      const first = payload.filtered ? payload.offset + 1 : 0;
      const last = Math.min(payload.offset + IIDM_PAGE_SIZE, payload.filtered);

      let html =
        "<div class='viewer-note'>" +
          "<span><b>" + payload.nb_beyond_tolerance + "</b> difference" + (payload.nb_beyond_tolerance === 1 ? "" : "s") + " beyond tolerance" +
            (payload.tolerance !== null ? " (relative tolerance " + formatNumber(payload.tolerance) + ", same rule as nrtDiff)" : "") + "</span>" +
          "<label class='check'><input type='checkbox' id='iidm-within'" + (filters.within ? " checked" : "") + "> Show " +
            payload.nb_within_tolerance + " differences within tolerance</label>" +
        "</div>";
      if (total === 0) {
        body.innerHTML = html + "<p class='placeholder'>No difference on the values compared by nrtDiff.</p>";
        bindWithin();
        return;
      }
      html +=
        "<div class='iidm-summary'>" +
          "<button class='chip" + (!filters.type ? " active" : "") + "' data-type='' data-attribute=''>All <b>" + total + "</b></button>" +
          payload.summary.map(g =>
            "<button class='chip" + (isActive(g) ? " active" : "") + "' data-type='" + escapeHtml(g.type) + "' data-attribute='" + escapeHtml(g.attribute || "") + "'" +
              (g.max_delta !== null ? " title='max |Δ| = " + escapeHtml(formatNumber(g.max_delta)) + "'" : "") + ">" +
              groupLabel(g) + " <b>" + g.count + "</b></button>").join("") +
        "</div>" +
        "<div class='toolbar'>" +
          "<input type='search' id='iidm-search' placeholder='Filter by object id…' value='" + escapeHtml(filters.search) + "'>" +
          "<span class='count'>" + first + "–" + last + " of " + payload.filtered + "</span>" +
          "<button class='btn btn-small' id='iidm-prev'" + (payload.offset === 0 ? " disabled" : "") + ">← Prev</button>" +
          "<button class='btn btn-small' id='iidm-next'" + (last >= payload.filtered ? " disabled" : "") + ">Next →</button>" +
        "</div>" +
        "<div class='code-view'><table class='cases iidm'><thead><tr>" +
          "<th></th><th>Type</th><th>Id</th><th>Attribute</th><th>Output</th><th>Reference</th>" +
          sortHeader("delta", "|Δ|") + sortHeader("rel_delta", "Rel. Δ") +
        "</tr></thead><tbody>" +
        (payload.rows.length ? payload.rows.map(row =>
          "<tr><td>" + iidmCategoryBadge(row) + "</td>" +
          "<td>" + escapeHtml(row.type) + "</td>" +
          "<td class='mono'>" + escapeHtml(row.id) + "</td>" +
          "<td class='mono'>" + escapeHtml(row.attribute || "") + "</td>" +
          "<td class='mono'>" + escapeHtml(row.left ?? "—") + "</td>" +
          "<td class='mono'>" + escapeHtml(row.right ?? "—") + "</td>" +
          "<td class='num'>" + (row.delta !== null ? formatNumber(row.delta) : "") + "</td>" +
          "<td class='num'>" + (row.rel_delta !== null ? formatNumber(row.rel_delta) : "") + "</td></tr>").join("")
          : "<tr><td colspan='8' class='empty'>No difference matches the filters</td></tr>") +
        "</tbody></table></div>";
      body.innerHTML = html;
      bindWithin();

      body.querySelectorAll("th[data-sort]").forEach(th => th.addEventListener("click", () => {
        if (filters.sort === th.dataset.sort) return;
        filters.sort = th.dataset.sort;
        filters.offset = 0;
        load().catch(fail);
      }));
      body.querySelectorAll(".chip").forEach(chip => chip.addEventListener("click", () => {
        filters.type = chip.dataset.type;
        filters.attribute = chip.dataset.attribute;
        filters.offset = 0;
        load().catch(fail);
      }));
      const search = document.getElementById("iidm-search");
      search.addEventListener("input", () => {
        clearTimeout(searchTimer);
        searchTimer = setTimeout(() => {
          filters.search = search.value.trim();
          filters.offset = 0;
          load().then(() => {
            const input = document.getElementById("iidm-search");
            if (input) { input.focus(); input.setSelectionRange(input.value.length, input.value.length); }
          }).catch(fail);
        }, 300);
      });
      document.getElementById("iidm-prev").addEventListener("click", () => {
        filters.offset = Math.max(0, filters.offset - IIDM_PAGE_SIZE);
        load().catch(fail);
      });
      document.getElementById("iidm-next").addEventListener("click", () => {
        filters.offset += IIDM_PAGE_SIZE;
        load().catch(fail);
      });
    };

    const bindWithin = () => {
      document.getElementById("iidm-within").addEventListener("change", event => {
        filters.within = event.target.checked;
        filters.offset = 0;
        load().catch(fail);
      });
    };

    const fail = error => { body.innerHTML = "<p class='placeholder'>" + escapeHtml(error.message) + "</p>"; };
    await load();
  }

  async function renderDiff(testCase, file, body, ignoreTimestamps) {
    if (ignoreTimestamps === undefined) ignoreTimestamps = file.path.toLowerCase().endsWith(".log");
    const payload = await api("diff", { case: testCase.case, path: file.path, ignore_timestamps: ignoreTimestamps ? "1" : "0" });
    let html = "<div class='viewer-note'><span>" + payload.nb_changes + " changed block" + (payload.nb_changes === 1 ? "" : "s") +
      " · output " + payload.nb_lines_out + " lines · reference " + payload.nb_lines_ref + " lines</span>" +
      "<label class='check'><input type='checkbox' id='ignore-ts'" + (ignoreTimestamps ? " checked" : "") + "> Ignore log timestamps</label>" +
      (payload.truncated ? "<span class='badge warn'>truncated</span>" : "") + "</div>";
    if (payload.nb_changes === 0) {
      html += "<p class='placeholder'>Output and reference are identical" + (ignoreTimestamps ? " (timestamps ignored)" : "") + ".</p>";
    } else {
      html += "<div class='code-view'><table class='code diff'><thead><tr><th colspan='2'>Output</th><th class='sep'></th><th colspan='2'>Reference</th></tr></thead><tbody>";
      for (const row of payload.rows) {
        if (row[0] === "skip") {
          html += "<tr class='skip'><td colspan='5'>⋯ " + row[1] + " identical lines ⋯</td></tr>";
          continue;
        }
        const changes = row[5] || [null, null];
        html += "<tr class='" + row[0] + "'>" +
          "<td class='ln'>" + (row[1] ?? "") + "</td><td class='txt left'>" + (row[2] === null ? "" : highlightSpans(row[2], changes[0])) + "</td>" +
          "<td class='sep'></td>" +
          "<td class='ln'>" + (row[3] ?? "") + "</td><td class='txt right'>" + (row[4] === null ? "" : highlightSpans(row[4], changes[1])) + "</td></tr>";
      }
      html += "</tbody></table></div>";
    }
    body.innerHTML = html;
    document.getElementById("ignore-ts").addEventListener("change", event => {
      renderDiff(testCase, file, body, event.target.checked).catch(error => { body.innerHTML = "<p class='placeholder'>" + escapeHtml(error.message) + "</p>"; });
    });
  }

  async function renderCurves(testCase, file, body, selected) {
    const summary = await api("curves", { case: testCase.case, path: file.path });
    const variables = summary.variables;
    if (!variables.length) {
      body.innerHTML = "<p class='placeholder'>No curve in this file.</p>";
      return;
    }
    if (!selected || !variables.some(v => v.name === selected)) selected = variables[0].name;
    const maxRel = Math.max(1e-300, ...variables.map(v => v.max_rel || 0));
    const rangeNote = (summary.out_range && summary.ref_range &&
      (summary.out_range[1] !== summary.ref_range[1] || summary.out_range[0] !== summary.ref_range[0]))
      ? " · <span class='badge warn'>time ranges differ</span>" : "";
    const nbKO = variables.filter(v => v.verdict === "KO" || v.only).length;
    const criteria = [];
    if (summary.max_dtw !== null && summary.max_dtw !== undefined) criteria.push("DTW > " + formatNumber(summary.max_dtw));
    if (summary.max_time_error !== null && summary.max_time_error !== undefined) criteria.push("time-aligned error > " + formatNumber(summary.max_time_error));
    const criterionNote = summary.criterion_error
      ? " · <span class='badge warn' title='" + escapeHtml(summary.criterion_error) + "'>nrtDiff verdict unavailable</span>"
      : " · <b>" + nbKO + "</b> KO for nrtDiff (" + criteria.join(" or ") + ")";

    body.innerHTML =
      "<div class='viewer-note'>" + variables.length + " curves" + criterionNote + " · output " + summary.out_points + " points · reference " + summary.ref_points + " points" + rangeNote + "</div>" +
      "<div class='curves'>" +
        "<div class='var-list'><input type='search' id='var-search' placeholder='Filter curves…'>" +
          "<label class='check var-filter'><input type='checkbox' id='ko-only'" + (state.curvesKoOnly ? " checked" : "") + "> KO only</label>" +
          "<ul id='var-items'></ul></div>" +
        "<div class='chart-area'>" +
          "<div id='chart-verdict'></div>" +
          "<div class='chart-tools'><span class='legend'>" +
            "<span><span class='sw' style='border-color:var(--series-out)'></span>output</span>" +
            "<span><span class='sw ref' style='border-color:var(--series-ref)'></span>reference</span>" +
            "<span title='|output − reference| > " + formatNumber(window.NrtChart.DIVERGENCE_RELATIVE_THRESHOLD) + " × max(1, max |value|)'>" +
              "<span class='sw zone'></span>deviation</span></span>" +
            "<label class='check'><input type='checkbox' id='show-error'" + (state.showError ? " checked" : "") + "> Show difference</label>" +
            "<button class='btn btn-small' id='zoom-max'>Zoom on max deviation</button>" +
            "<button class='btn btn-small' id='zoom-reset'>Reset zoom</button>" +
          "</div>" +
          "<div id='chart'></div>" +
          "<div class='viewer-note' style='margin-top:4px'>drag to zoom · double-click to reset</div>" +
        "</div>" +
      "</div>";

    const items = document.getElementById("var-items");
    const verdictBadge = v => {
      if (v.only) return "<span class='badge ko'>KO</span>";
      if (v.verdict === "KO") return "<span class='badge ko'>KO</span>";
      if (v.verdict === "OK") return "<span class='badge ok'>OK</span>";
      if (v.verdict === "?") return "<span class='badge' title='DTW computed when the curve is displayed'>?</span>";
      return "";
    };
    const renderItems = () => {
      const text = document.getElementById("var-search").value.toLowerCase();
      const koOnly = document.getElementById("ko-only").checked;
      const shown = variables.filter(v => v.name.toLowerCase().includes(text) && (!koOnly || v.only || v.verdict === "KO" || v.verdict === "?"));
      items.innerHTML = shown.length ? shown.map(v => {
        let detail;
        if (v.only === "out") detail = "<span>missing in reference</span>";
        else if (v.only === "ref") detail = "<span>missing in output</span>";
        else detail = "<span class='bar'><span style='width:" + Math.min(100, 100 * (v.max_rel || 0) / maxRel).toFixed(1) + "%'></span></span>" +
          "<span>|Δ| " + formatNumber(v.max_abs) + "</span>";
        return "<li data-name='" + escapeHtml(v.name) + "'" + (v.name === selected ? " class='selected'" : "") + ">" +
          "<div class='vname'>" + verdictBadge(v) + " " + escapeHtml(v.name) + "</div><div class='verr'>" + detail + "</div></li>";
      }).join("") : "<li class='placeholder'>No curve matches</li>";
      items.querySelectorAll("li[data-name]").forEach(item => item.addEventListener("click", () => {
        history.replaceState(null, "", caseHash(testCase.case, file.path, "curves", item.dataset.name));
        selected = item.dataset.name;
        items.querySelectorAll("li").forEach(other => other.classList.toggle("selected", other === item));
        showCurve(testCase, file, variables.find(v => v.name === selected), summary, renderItems);
      }));
    };
    renderItems();
    document.getElementById("var-search").addEventListener("input", renderItems);
    document.getElementById("ko-only").addEventListener("change", event => {
      state.curvesKoOnly = event.target.checked;
      writePreference("curvesKoOnly", state.curvesKoOnly);
      renderItems();
    });
    document.getElementById("zoom-max").addEventListener("click", () => state.chart && state.chart.zoomOnMaxError());
    document.getElementById("zoom-reset").addEventListener("click", () => state.chart && state.chart.resetZoom());
    document.getElementById("show-error").addEventListener("change", event => {
      state.showError = event.target.checked;
      writePreference("showError", state.showError);
      if (state.chart) state.chart.setShowError(state.showError);
    });
    const selectedItem = items.querySelector("li.selected");
    if (selectedItem) selectedItem.scrollIntoView({ block: "nearest" });
    await showCurve(testCase, file, variables.find(v => v.name === selected), summary, renderItems);
  }

  // One line telling whether the displayed curve passes the nrtDiff criterion, and where it deviates
  function verdictHtml(variable, summary, divergence) {
    const name = "<span class='mono'>" + escapeHtml(variable.name) + "</span>";
    const deviation = divergence && divergence.firstTime !== null
      ? "visible deviation from t = " + formatNumber(divergence.firstTime)
      : "curves superposed (|Δ| ≤ " + formatNumber(window.NrtChart.DIVERGENCE_RELATIVE_THRESHOLD) + " × amplitude)";
    const detail = variable.max_abs !== null && variable.max_abs !== undefined
      ? "<div class='detail'>max |Δ| = " + formatNumber(variable.max_abs) + (variable.t_max !== null ? " at t = " + formatNumber(variable.t_max) : "") + "</div>" : "";
    if (variable.only) {
      return "<div class='verdict ko'>✖ " + name + " is missing in the " + (variable.only === "out" ? "reference" : "output") + "</div>";
    }
    // one part per nrtDiff criterion, e.g. "✖ time-aligned error 2.3e-3 > 1e-3 · ✔ DTW ≤ 0.05 ≤ 0.1"
    const parts = [];
    if (variable.time_verdict) {
      const ko = variable.time_verdict === "KO";
      parts.push((ko ? "✖" : "✔") + " time-aligned error " + formatNumber(variable.time_error) + (ko ? " > " : " ≤ ") + formatNumber(summary.max_time_error));
    }
    if (variable.dtw_verdict === "?") {
      parts.push("DTW being computed…");
    } else if (variable.dtw_verdict) {
      const ko = variable.dtw_verdict === "KO";
      const bound = variable.dtw_kind === "at_least" ? "≥ " : variable.dtw_kind === "at_most" ? "≤ " : "";
      parts.push((ko ? "✖" : "✔") + " DTW " + bound + formatNumber(variable.dtw) + (ko ? " > " : " ≤ ") + formatNumber(summary.max_dtw));
    }
    const criteriaText = "<div class='detail'>" + parts.join(" · ") + "</div>";
    if (variable.verdict === "KO") {
      return "<div class='verdict ko'>✖ KO for nrtDiff · " + deviation + criteriaText + detail + "</div>";
    }
    if (variable.verdict === "OK") {
      return "<div class='verdict ok'>✔ OK for nrtDiff · " + deviation + criteriaText + detail + "</div>";
    }
    if (variable.verdict === "?") {
      return "<div class='verdict'>Computing the nrtDiff verdict… · " + deviation + criteriaText + detail + "</div>";
    }
    return "<div class='verdict'>" + (summary.criterion_error ? escapeHtml(summary.criterion_error) + " · " : "") + deviation + detail + "</div>";
  }

  async function showCurve(testCase, file, variable, summary, onVerdictUpdate) {
    destroyChart();
    const container = document.getElementById("chart");
    if (!container) return;
    container.innerHTML = "<p class='placeholder'>Loading…</p>";
    const data = await api("curve", { case: testCase.case, path: file.path, name: variable.name });
    if (!document.body.contains(container)) return;
    container.innerHTML = "";
    state.chart = new window.NrtChart.ComparisonChart(container, { out: data.out, ref: data.ref, tMax: variable.t_max, showError: state.showError });
    const chart = state.chart;
    const verdict = document.getElementById("chart-verdict");
    verdict.innerHTML = verdictHtml(variable, summary, chart.divergence);
    if (variable.verdict === "?") {
      // the full DTW did not fit in the listing budget: compute it now for this curve only
      try {
        const result = await api("dtw", { case: testCase.case, path: file.path, name: variable.name });
        Object.assign(variable, result);
        onVerdictUpdate();
      } catch (error) {
        variable.verdict = undefined;
        toast("DTW computation failed: " + error.message, true);
      }
      if (state.chart === chart && document.body.contains(verdict)) verdict.innerHTML = verdictHtml(variable, summary, chart.divergence);
    }
  }

  function destroyChart() {
    if (state.chart) {
      state.chart.destroy();
      state.chart = null;
    }
  }

  // ---------------------------------------------------------------- reference update

  function openAcceptDialog(testCase) {
    const dialog = document.getElementById("accept-dialog");
    const candidates = (state.tree || []).filter(f => f.out && (f.ref || isFailing(f)));
    document.getElementById("accept-case").textContent = testCase.directory;
    const renderCandidate = (f, outputDir) =>
      "<label title='" + escapeHtml(f.path) + "'><input type='checkbox' value='" + escapeHtml(f.path) + "'" + (isFailing(f) ? " checked" : "") + ">" +
      "<span class='dot " + statusDotClass(f.status) + "'></span>" + escapeHtml(displayPath(f, outputDir)) +
      (f.ref ? "" : " <span class='badge'>new</span>") + "</label>";
    const groups = groupFilesByJob(candidates);
    let html;
    if (!candidates.length) {
      html = "<p class='placeholder'>No output file can be used as reference.</p>";
    } else if (groups.length === 1 && groups[0].title === null) {
      html = groups[0].files.map(f => renderCandidate(f, "")).join("");
    } else {
      html = groups.map(group =>
        "<div class='accept-group'><div class='accept-job'>" + groupSummary(group) + "</div>" +
        group.files.map(f => renderCandidate(f, group.outputDir)).join("") + "</div>").join("");
    }
    document.getElementById("accept-files").innerHTML = html;

    // quick selection by file type: a type chip selects only the failing files of that type
    const failingKinds = [];
    candidates.filter(isFailing).forEach(f => {
      const kind = fileKind(f.path);
      const entry = failingKinds.find(k => k.kind === kind);
      if (entry) entry.count++;
      else failingKinds.push({ kind: kind, count: 1 });
    });
    const kindChip = (selection, label) =>
      "<button type='button' class='chip' data-select='" + escapeHtml(selection) + "'>" + escapeHtml(label) + "</button>";
    const kindsBar = document.getElementById("accept-kinds");
    kindsBar.innerHTML = candidates.length ?
      "<span class='accept-kinds-label'>Select:</span>" +
      kindChip("failing", "All failing") +
      (failingKinds.length > 1 ? failingKinds.map(k => kindChip("kind:" + k.kind, k.kind + " only (" + k.count + ")")).join("") : "") +
      kindChip("none", "None") : "";
    kindsBar.querySelectorAll("button[data-select]").forEach(button => button.addEventListener("click", () => {
      const selection = button.dataset.select;
      dialog.querySelectorAll(".accept-files input").forEach(input => {
        const file = candidates.find(f => f.path === input.value);
        input.checked = selection === "failing" ? isFailing(file)
          : selection.startsWith("kind:") ? isFailing(file) && fileKind(file.path) === selection.slice(5)
          : false;
      });
      updateConfirm();
    }));

    // two-step confirmation: the first click arms the button, the second one overwrites the reference
    const confirm = document.getElementById("accept-confirm");
    let armed = false;
    let disarmTimer = null;
    const updateConfirm = () => {
      armed = false;
      clearTimeout(disarmTimer);
      confirm.classList.remove("armed");
      const count = dialog.querySelectorAll(".accept-files input:checked").length;
      confirm.disabled = count === 0;
      confirm.textContent = "Overwrite " + count + " reference file" + (count === 1 ? "" : "s");
    };
    dialog.querySelectorAll(".accept-files input").forEach(input => input.addEventListener("change", updateConfirm));
    updateConfirm();
    confirm.onclick = event => {
      if (armed) return; // second click: let the form close the dialog with "confirm"
      event.preventDefault();
      armed = true;
      confirm.classList.add("armed");
      confirm.textContent = "Click again to confirm";
      disarmTimer = setTimeout(updateConfirm, 5000);
    };

    dialog.onclose = async () => {
      clearTimeout(disarmTimer);
      if (dialog.returnValue !== "confirm") return;
      const paths = Array.from(dialog.querySelectorAll(".accept-files input:checked")).map(input => input.value);
      try {
        const result = await post("accept", { case: testCase.case, paths: paths });
        toast("Reference updated: " + result.copied.length + " file" + (result.copied.length === 1 ? "" : "s"));
        await reloadResults();
        state.currentCase = null; // force a full re-render (badges, tree, viewer)
        route();
      } catch (error) {
        toast("Reference update failed: " + error.message, true);
      }
    };
    dialog.returnValue = "";
    dialog.showModal();
  }

  // ---------------------------------------------------------------- routing & loading

  function route() {
    if (!state.results) return;
    const hash = location.hash.replace(/^#/, "") || "/";
    const [path, query] = hash.split("?");
    const params = new URLSearchParams(query || "");
    const match = path.match(/^\/case\/(.+)$/);
    const previousView = state.view;
    state.view = match ? "case" : "list";
    if (match) {
      if (previousView === "list") {
        // leaving the list: remember where we were, and open the case at its top
        state.listScroll = window.scrollY;
        window.scrollTo(0, 0);
      }
      state.lastCase = decodeURIComponent(match[1]);
      renderCase(state.lastCase, params);
    } else {
      renderList();
      if (previousView === "case") restoreListPosition();
    }
  }

  // back from a case: same scroll position as before, with the case just visited highlighted and on screen
  function restoreListPosition() {
    window.scrollTo(0, state.listScroll || 0);
    const row = Array.from(document.querySelectorAll("tr[data-case]")).find(r => r.dataset.case === state.lastCase);
    if (!row) return;
    row.classList.add("last-visited");
    const box = row.getBoundingClientRect();
    if (box.top < topbarHeight() || box.bottom > window.innerHeight) row.scrollIntoView({ block: "center" });
  }

  async function reloadResults() {
    state.results = await api("results");
    renderRunInfo();
  }

  async function checkForNewResults() {
    if (!state.results) return;
    try {
      const previousDate = state.results.date;
      const results = await api("results");
      if (results.date !== previousDate) {
        state.results = results;
        state.currentCase = null;
        renderRunInfo();
        route();
        toast("New NRT results loaded");
      }
    } catch (error) {
      // server stopped or results file removed: keep the current display
    }
  }

  window.addEventListener("hashchange", route);
  window.addEventListener("focus", checkForNewResults);

  reloadResults().then(route).catch(error => {
    app.innerHTML = "<p class='placeholder'>Unable to load the results: " + escapeHtml(error.message) + "</p>";
  });
})();
