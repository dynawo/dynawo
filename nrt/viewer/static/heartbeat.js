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
 * Web worker sending the heartbeat of a viewer page (--exit-on-close): the timers of a worker are not slowed down
 * when the page is in a background tab, so the server can stop shortly after the page disappears.
 * Started with { page, period } (period in seconds); posts "stopped" when the server does not answer anymore.
 */
"use strict";

let timer = null;

async function beat(page) {
  try {
    const response = await fetch("/api/heartbeat", {
      method: "POST",
      headers: { "Content-Type": "application/json", "X-NRT-Viewer": "1" },
      body: JSON.stringify({ page: page })
    });
    if (!response.ok) throw new Error(response.statusText);
  } catch (error) {
    clearInterval(timer);
    timer = null;
    self.postMessage("stopped");
  }
}

self.onmessage = event => {
  const { page, period } = event.data;
  if (timer !== null) return;
  beat(page);
  timer = setInterval(() => beat(page), period * 1000);
};
