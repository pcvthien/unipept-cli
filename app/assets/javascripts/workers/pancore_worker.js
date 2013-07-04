// vars
var data = {},
    unicoreData = [],
    unicore2Data = [],
    order = [],
    lca = 0,
    pans = [],
    cores = [],
    unicores = []
    unicores2 = [];

// Add an event handler to the worker
self.addEventListener('message', function (e) {
    var data = e.data;
    switch (data.cmd) {
    case 'log':
        sendToHost("log", data.msg);
        break;
    case 'loadData':
        loadData(data.msg.bioproject_id);
        break;
    case 'removeData':
        removeData(data.msg.bioproject_id, data.msg.order, data.msg.start);
        break;
    case 'clearAllData':
        clearAllData();
        break;
    case 'recalculatePanCore':
        recalculatePanCore(data.msg.order, data.msg.start, data.msg.stop);
        break;
    case 'getUniqueSequences':
        getUniqueSequences(data.msg.lca, data.msg.type);
        break;
    default:
        sendToHost("error", data.msg);
    }
}, false);

// Sends a response type and message to the host
function sendToHost(type, message) {
    self.postMessage({'type': type, 'msg': message});
}

// Loads peptides, based on bioproject_id
function loadData(bioproject_id) {
    getJSON("/pancore/sequences/" + bioproject_id + ".json", function (json_data) {
        addData(bioproject_id, json_data);
    });
}

// Adds new dataset to the data array
function addData(bioproject_id, set) {
    // Store data for later use
    data[bioproject_id] = set;
    order.push(bioproject_id);

    // Calculate pan and core
    var core = cores.length === 0 ? set : intersection(cores[cores.length - 1], set);
    var pan = pans.length === 0 ? set : union(pans[pans.length - 1], set);
    pans.push(pan);
    cores.push(core);

    // Return the results to the host
    var temp = {};
    temp.bioproject_id = bioproject_id;
    temp.pan = pan.length;
    temp.core = core.length;
    sendToHost("addData", temp);
}

// Retrieves the unique sequences
function getUniqueSequences(l, type) {
    lca = l;
    var r = data[order[0]];
    getJSONByPost("/pancore/unique_sequences/", "type=" + type + "&lca=" + lca + "&sequences=[" + r + "]", function (d) {calculateUnicore(d, type); });
}

// Removes a genomes from the data
function removeData(bioproject_id, newOrder, start) {
    var l = pans.length;
    delete data[bioproject_id];
    pans.splice(l - 1, 1);
    cores.splice(l - 1, 1);
    unicores.splice(l - 1, 1);
    recalculatePanCore(newOrder, start, l - 2);
}

// Recalculates the pan and core data based on a
// given order, from start till stop
function recalculatePanCore(newOrder, start, stop) {
    order = newOrder;
    for (var i = start; i <= stop; i++) {
        var set = data[order[i]];
        if (i === 0) {
            cores[i] = set;
            pans[i] = set;
        } else {
            cores[i] = intersection(cores[i - 1], set);
            pans[i] = union(pans[i - 1], set);
            if (start !== 0) {
                unicores[i] = intersection(unicores[i - 1], set);
                unicores2[i] = intersection(unicores2[i - 1], set);
            }
        }
    }
    var response = [];
    for (var i = 0; i < order.length; i++) {
        var temp = {};
        temp.bioproject_id = order[i];
        temp.pan = pans[i].length;
        temp.core = cores[i].length;
        if (start !== 0) {
            temp.unicore = unicores[i].length;
            temp.unicore2 = unicores2[i].length;
        }
        response.push(temp);
    }
    sendToHost("setVisData", response);
    if (start === 0) {
        unicores = [];
        unicores2 = [];
        getUniqueSequences(lca, "uniprot");
        getUniqueSequences(lca, "genome");
    }
}

// Calculates the unique peptides data
function calculateUnicore(ud, type) {
    if (type === "uniprot") {
        unicoreData = ud;
        unicores[0] = unicoreData;
        var u = unicores;
    } else {
        unicore2Data = ud;
        unicores2[0] = unicore2Data;
        var u = unicores2;
    }
    for (var i = 1; i < order.length; i++) {
        var set = data[order[i]];
        u[i] = intersection(u[i - 1], set);
    }
    var response = [];
    for (var i = 0; i < order.length; i++) {
        var temp = {};
        temp.bioproject_id = order[i];
        temp.pan = pans[i].length;
        temp.core = cores[i].length;
        if (unicores.length > 0) temp.unicore = unicores[i].length;
        if (unicores2.length > 0) temp.unicore2 = unicores2[i].length;
        response.push(temp);
    }
    sendToHost("setVisData", response);
}

// Resets the data vars
function clearAllData() {
    data = {};
    unicoreData = [];
    unicore2Data = [];
    order = [];
    lca = 0;
    pans = [];
    cores = [];
    unicores = [];
    unicores2 = [];
}

// Provide an error function with the same signature as in the host
function error(error, message) {
    sendToHost("error", {"error" : error, "msg" : message});
}

// Wrapper around xhr json request
function getJSON(url, callback) {
    var req = new XMLHttpRequest();
    req.open('GET', url, true);
    req.onreadystatechange = function () {
        if (req.readyState === 4) {
            if (req.status === 200) {
                var data = JSON.parse(req.responseText);
                callback(data);
            } else {
                error("request error for " + url, "It seems like something went wrong while we loaded the data");
            }
        }
    };
    req.send(null);
}

// Wrapper around xhr json request
function getJSONByPost(url, data, callback) {
    var req = new XMLHttpRequest();
    req.open('POST', url, true);
    req.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    req.onreadystatechange = function () {
        if (req.readyState === 4) {
            if (req.status === 200) {
                var data = JSON.parse(req.responseText);
                callback(data);
            } else {
                error("request error for " + url, "It seems like something went wrong while we loaded the data");
            }
        }
    };
    req.send(data);
}

// union and intersection for sorted arrays
function union(a, b) {
    var r = [],
        i = 0,
        j = 0;
    while (i < a.length && j < b.length) {
        if (a[i] < b[j]) {
            r.push(a[i]);
            i++;
        } else if (a[i] > b[j]) {
            r.push(b[j]);
            j++;
        } else {
            r.push(a[i]);
            i++;
            j++;
        }
    }
    while (i < a.length) {
        r.push(a[i]);
        i++;
    }
    while (j < b.length) {
        r.push(b[j]);
        j++;
    }
    return r;
}
function intersection(a, b) {
    var r = [],
        i = 0,
        j = 0;
    while (i < a.length && j < b.length) {
        if (a[i] < b[j]) {
            i++;
        } else if (a[i] > b[j]) {
            j++;
        } else {
            r.push(a[i]);
            i++;
            j++;
        }
    }
    return r;
}