"use strict";

////////  GLOBAL OBJECTS ///////////
const datasets_map = new Map();

// Create a chart with Chart.js
const crv_chart_data = {
  labels: [],
  datasets: [],
};
const crv_chart_ctx = document.getElementById('curves-chart').getContext('2d');
const crv_chart_config = {
type: 'line',
data: crv_chart_data,
options: {
  scales: {
    x: {
      type: 'linear',
    },
    y: {
      position: 'left'
    },
    yRight: {
      position: 'right',
      grid: {
        drawOnChartArea: false // Hide grid on the right y-axis
      }
    }
  },
  plugins: {
    legend: {
      position: 'top',
    },
    title: {
      display: true,
      text: 'curves'
    },
    zoom: {
      x: {min: 0, max: 100}
    }
  }
},
};

const curves_chart = new Chart(crv_chart_ctx, crv_chart_config);

// ===============

const evt_chart_data = {
  labels: [],
  datasets: [],
};
const evt_chart_ctx = document.getElementById('event-chart').getContext('2d');
const evt_chart_config = {
type: 'line',
data: evt_chart_data,
options: {
  scales: {
    x: {
      type: 'linear',
    },
    y: {
      position: 'left'
    },
    yRight: {
      position: 'right',
      grid: {
        drawOnChartArea: false // Hide grid on the right y-axis
      }
    }
  },
  plugins: {
    legend: {
      position: 'top',
    },
    title: {
      display: true,
      text: 'curves'
    },
    zoom: {
      x: {min: 0, max: 100}
    }
  }
},
};
// const event_chart = new Chart(evt_chart_ctx, evt_chart_config);

const dataset_list_node = document.getElementById('dataset-list');

//////// FUNCTIONS /////////

// Establish WebSocket connection
function start_ws(websocketServerLocation){
  const ws = new WebSocket(websocketServerLocation);
  ws.onmessage = function(evt) {
    console.log(evt.data);
    parse_event(evt.data);
  };
  ws.onopen = function() {
    console.log('WebSocket connection established');
  };
  ws.onclose = function() {
      console.log('WebSocket connection closed');
      // Try to reconnect in 1 seconds
      setTimeout(function(){start_ws(websocketServerLocation)}, 1000);
  };
}

function parse_event(evt_data) {
  const data_obj = JSON.parse(evt_data);
  console.log(data_obj)

  if ("curves" in data_obj) {
    setup_curves(data_obj.curves);
    console.log(datasets_map)
    if (dataset_list_node.textContent.trim() === "")
      update_curve_list();
  }
}

function setup_curves(curves_data) {
  console.log(curves_data);
  if ("values" in curves_data && "time" in curves_data) {
    let i = 0
    for (let curve_name in curves_data["values"]) {
      if (!(datasets_map.has(curve_name))) {
        const new_dataset = {
          label: curve_name,
          data: [],
          fill: false,
          tension: 0.1,
          borderColor: `hsl(${137.508 * i}, 75%, 75%)`,
          backgroundColor: `hsl(${137.508 * i++}, 50%, 75%)`
          };
        datasets_map.set(curve_name, new_dataset);
      }
      datasets_map.get(curve_name).data.push(curves_data["values"][curve_name]);
    }
    crv_chart_data.labels.push(curves_data["time"])
  }
  curves_chart.update('none')
}

function create_dataset(i_name, i_index) {
  const new_ds = {
    label: i_name,
    data: [],
    fill: false,
    tension: 0.1,
    };
  return new_ds;
}

// Populate the checkbox list
// const datasetList = document.getElementById('datasetList');
function update_curve_list() {
  datasets_map.forEach((dataset, key) => {
    const li = document.createElement('li');

    // Left checkbox
    const leftCheckbox = document.createElement('input');
    leftCheckbox.type = 'checkbox';
    leftCheckbox.dataset.name = key;
    leftCheckbox.dataset.axis = 'left';
    leftCheckbox.addEventListener('change', toggle_dataset);

    // Right checkbox
    const rightCheckbox = document.createElement('input');
    rightCheckbox.type = 'checkbox';
    rightCheckbox.dataset.name = key;
    rightCheckbox.dataset.axis = 'right';
    rightCheckbox.addEventListener('change', toggle_dataset);

    // Label for the dataset name
    const label = document.createElement('span');
    label.textContent = key;

    // Append checkboxes and label to the list item
    li.appendChild(leftCheckbox);
    li.appendChild(label);
    li.appendChild(rightCheckbox);
    dataset_list_node.appendChild(li);
  });
}

// Function to toggle dataset visibility
function toggle_dataset() {
  const dataset_name = this.dataset.name;
  const is_checked = this.checked;
  const axis = this.dataset.axis;
  const dataset_index = curves_chart.data.datasets.findIndex(ds => ds.label === dataset_name);

  if (is_checked) {
    const dataset = { ...datasets_map.get(dataset_name) };

    // Add or update the dataset in the chart
    dataset.yAxisID = axis === 'left' ? 'y' : 'yRight';
    if (dataset_index === -1) {
      curves_chart.data.datasets.push(dataset);
    } else {
      curves_chart.data.datasets[dataset_index].yAxisID = dataset.yAxisID;
    }
  } else {
    // Remove the dataset if neither checkbox is checked
    if (!document.querySelector(`input[data-name="${dataset_name}"][data-axis="${axis === 'left' ? 'right' : 'left'}"]`).checked) {
      curves_chart.data.datasets.splice(dataset_index, 1);
    } else if (dataset_index !== -1) {
      // Otherwise, update the y-axis based on the other checkbox
      curves_chart.data.datasets[dataset_index].yAxisID = axis === 'left' ? 'yRight' : 'y';
    }

  }

  curves_chart.update('none');
}


start_ws('ws://localhost:9001')
