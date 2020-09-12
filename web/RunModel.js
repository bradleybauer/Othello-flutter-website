function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function setupJS(modelUrl, callback) {
    if (window.hasOwnProperty('state')) {
        await window.state['sessionPromise'];
        callback();
        return;
    }

    // create a session
    window.state = {'onnxSession': new onnx.InferenceSession()};

    // load the ONNX model file
    window.state['sessionPromise'] = await window.state['onnxSession'].loadModel(modelUrl);

    callback();
}

async function getActionJS(board, validPositions, callback, delay) {
    // make the ai 'think'
    await sleep(delay * 1000);

    // generate model board
    board = [new Tensor(new Float32Array(board.flat()), "float32", [1, 64])];
    // execute the model
    output = await window.state['onnxSession'].run(board);
    // consume the output
    outputTensor = output.values().next().value.data;
    maxQ = -123123123;
    maxQAction = [-1, -1]; // NOOP
    if (validPositions.length != 0) {
        for (i = 0; i < validPositions.length; i++) {
            x = validPositions[i][0];
            y = validPositions[i][1];
            if (outputTensor[x * 8 + y] > maxQ) {
                maxQ = outputTensor[x * 8 + y];
                maxQAction = [x, y];
            }
        }
    }
    callback(maxQAction);
}

async function getQValueJS(board, action, callback) {
    // generate model board
    board = [new Tensor(new Float32Array(board.flat()), "float32", [1, 64])];
    // execute the model
    output = await window.state['onnxSession'].run(board);
    // consume the output
    outputTensor = output.values().next().value.data;
    x = action[0];
    y = action[1];
    callback(outputTensor[x * 8 + y]);
}
