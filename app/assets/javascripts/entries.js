var message_types = {
    ERROR : 1001,
    INFO : 1002,
    WARNING : 1003
};


window.onload = function() {

    recorder = new Recorder();


    recordingsList = new RecordingsList('recordings-list');
    recordingsList.reloadList(recordings);

    recorder.setSuccessfulRecordingCallback(function(recording) {
	recordings.push(recording);
	recordingsList.reloadList(recordings);
    });

};

var Recorder = function() {

    var audioPanel;

    var recordToggleButton;



    //var audioField;
    
    var myAudioRecorder = null;
    var rafID = null;
    var recIndex = 0;

    var states = {
	NOT_RECORDING : 0,
	RECORDING_TEACHER : 1,
	PLAYING_TEACHER : 3
    };

    var successfulRecordingCallback = null;

    this.setSuccessfulRecordingCallback = function(cb) {
	if (typeof(cb) !== 'function') {
	    throw new Error('cb must be a function');
	}

	successfulRecordingCallback = cb;
    };

    var currentState = states.NOT_RECORDING;

    var gotOggCallback = function(blob) {

    	transmitBlob(blob, function(recording) {

    	    //if (typeof fileid !== 'number') {
    	    //throw new Error('could not transmit file?!' + fileid);
    	//}

	    successfulRecordingCallback(recording);

    	    recordToggleButton.enable();
	    

	    myAudioRecorder.clear();
    	});
    };

    // Transmits a blob to the server and, if successful,
    // returns its file id as a string
    var transmitBlob = function(blob, callback) {
	if (typeof callback !== 'function')
	    throw new Error('callback is not a function');

	var formData = new FormData();

	formData.append('audio_file', blob);

	var request = new XMLHttpRequest();

	request.responseType = 'json';

	request.onreadystatechange = function(event) {
	    if (request.readyState !== 4 || request.status !== 200) {
		// something went wrong
		console.log('received from server: ' + request);
	    }
	    else {
		if (request.response.status === 1) {
		    callback(request.response.recording);
		}
		else {
		    // something went wrong
		    console.log('unable to transmit the recording to the server: ' + request.response.msg);
		}
	    }
	};

	var entry_id = document.getElementById('entry_id').value;
	request.open("POST", '/entries/' + entry_id + '/recordings');
	request.send(formData);
    };

    var pressRecordButton = function(event) {
	console.log('hallo teacher');

	if (myAudioRecorder === null) {

	    throw new Error('audio recorder was found null');
	}

	if (currentState === states.NOT_RECORDING) {

	    currentState = states.RECORDING;
	    

	    recordToggleButton.setToggledOn();

	    myAudioRecorder.clear();

	    myAudioRecorder.record();

	}
	else if (currentState === states.RECORDING) {
	    currentState = states.NOT_RECORDING;

	    recordToggleButton.setToggledOff();

	    recordToggleButton.disable();

	    myAudioRecorder.stop();

	    myAudioRecorder.exportOGG(function (blob) {
		gotOggCallback(blob);
	    });
	}
	else {
	    console.log("we're recording!");
	}
    };

    


    var resetButtons = function() {

	recordToggleButton.enable();






    };

    var playbackErrorHandler = function(error) {
	var messageBoxContainer =
	    document.getElementById('message-box-container');

	switch (error.target.error.code) {
	case error.target.error.ERR_NETWORK:
	    var panel =
		new MessagePanel('no network connection',
				 message_types.ERROR);

	    messageBoxContainer.appendChild(panel.getElement());
	    break;



	case error.target.error.MEDIA_ERR_DECODE:
	    var panel =
		new MessagePanel('MEDIA ERR DECODE',
				 message_types.ERROR);

	    messageBoxContainer.appendChild(panel.getElement());
	    break;

	default:
	    var panel =
		new MessagePanel('an error occurred',
				 message_types.WARNING);
	    
	    messageBoxContainer.appendChild(panel.getElement());

	    console.log(error);
	    break;


	}

	currentState = states.NOT_RECORDING;

	resetButtons();
    };




    var gotDeviceCallback = function(ar) {
	myAudioRecorder = ar;

    };
    
    var initView = function() {
	audioPanel =
	    document.getElementById('audio-panel');
	
	if (audioPanel === null) {
	    throw new Error('cannot find the audio panel');
	}

	audioPanel.classList.add('card');

	var audioCardHeader = document.createElement('div');
	audioCardHeader.classList.add('card-header');
	audioCardHeader.appendChild(document.createTextNode('Recorder'));

	audioPanel.appendChild(audioCardHeader);

	var cardBlock = document.createElement('div');
	cardBlock.classList.add('card-block');
	audioPanel.appendChild(cardBlock);

	var buttonGroup = document.createElement('div');
	buttonGroup.classList.add('btn-group-vertical');
	cardBlock.appendChild(buttonGroup);

	recordToggleButton =
	    new ToggleButton('record-on',
			     'record-off',
			     pressRecordButton);
	
	buttonGroup.appendChild(recordToggleButton.getElement());





	resetButtons();

    };

    initView();

    audioRecorder.requestDevice(gotDeviceCallback);
    
};

var ToggleButton = function(onClass,
			    offClass,
			    callback) {
    
    if (typeof onClass !== 'string') {
	throw new Error('onClass is not a string');
    }

    if (typeof offClass !== 'string') {
	throw new Error('offClass is not a string');
    }

    if (typeof callback !== 'function') {
	throw new Error('toggleOffCallback is not a function but ' + typeof callback);
    }
	

    var that = this;

    var element;

    function setup() {
	element = document.createElement('button');

	element.setAttribute('type', 'button');

	element.classList.add('btn');
	element.classList.add('btn-secondary');


	element.addEventListener('click', callback);

	that.setToggledOff();
    }

    this.setToggledOn = function() {
	element.classList.remove(offClass);
	element.classList.add(onClass);
    };

    this.setToggledOff = function() {
	element.classList.remove(onClass);
	element.classList.add(offClass);
    };

    this.disable = function() {
	element.disabled = true;
    };

    this.enable = function() {
	element.disabled = false;
    };

    this.getElement = function() {
	return element;
    };

    setup();
};

var MessagePanel = function(contents,
			    message_type) {

    var panel = null;

    this.getElement = function() {
	return panel;
    };


    
    // constructor
    (function() {

	if (message_type !== message_types.INFO
	    && message_type !== message_types.ERROR
	    && message_type !== message_types.WARNING) {

	    throw new Error('unknown message type');
	}

	panel = document.createElement('div');
	panel.classList.add('card');

	switch (message_type) {
	case message_types.INFO:
	    panel.classList.add('panel-info');
	    break;

	case message_types.ERROR:
	    panel.classList.add('panel-error');
	    break;

	case message_types.WARNING:
	    panel.classList.add('panel-warning')
	    break;
	}

	var cardHeader = document.createElement('div');
	cardHeader.classList.add('card-header');
	cardHeader.appendChild(document.createTextNode('Message'));

	panel.appendChild(cardHeader);

	var panelBody = document.createElement('p');
	panelBody.classList.add('panel-text');
	panel.appendChild(panelBody);

	panelBody.appendChild(document.createTextNode(contents));
    })();


};


var RecordingsList = function(container_id) {

    var element = null;
    var listElement = null;

    var that = this;

    // public methods

    this.getElement = function() {
	return element;
    };

    this.reloadList = function(recordings) {
	listElement.innerHTML = '';

	for (var i = 0; i < recordings.length; i++) {
	    listElement.appendChild(getNewItem(recordings[i]));
	}
    };

    // private methods


    var playbackErrorHandler = function(err) {
	console('error! help!');
    };

    var play = function(id) {

	var audio = new Audio('/uploads/' + id + '.ogg');

	audio.addEventListener('error', playbackErrorHandler);

	audio.onended = function() {

	};

	audio.play();

    };


    var getNewItem = function(recording) {
	var newItem = document.createElement('div');
	newItem.classList.add('list-group-item');

	newItem.appendChild(
	    document.createTextNode('recording ' + recording.id + ' created by user ' + recording.user_id));

	// create the playback button

	var playButton = document.createElement('button');
	playButton.classList.add('btn');
	playButton.classList.add('btn-primary');
	playButton.classList.add('btn-sm');
	//playButton.classList.add('pull-xs-right');
	playButton.appendChild(document.createTextNode('play'))

	playButton.addEventListener('click', function(ev) {
	    play(recording.id);
	});

	newItem.appendChild(playButton);

	// create a button to delete the recording

	var deleteButton = document.createElement('button');
	deleteButton.classList.add('btn');
	deleteButton.classList.add('btn-danger');
	deleteButton.classList.add('btn-sm');
	//deleteButton.classList.add('btn-xs-right');
	deleteButton.appendChild(document.createTextNode('delete'));

	newItem.appendChild(deleteButton);
	

	return newItem;
    };

    var setupView = function() {
	element = document.getElementById(container_id);	

	if (element === null) {
	    throw new Error('no element with id ' + container_id);
	}

	element.classList.add('card');

	var cardHeader = document.createElement('div');
	cardHeader.classList.add('card-header');
	cardHeader.appendChild(
	    document.createTextNode('Recordings'))

	element.appendChild(cardHeader);

	listElement = document.createElement('div');
	listElement.classList.add('list-group');

	element.appendChild(listElement);
    };

    (function() {
	setupView();
	
    })();
     
};
