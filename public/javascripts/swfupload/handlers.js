/* Demo Note:  This demo uses a FileProgress class that handles the UI for displaying the file name and percent complete.
The FileProgress class is not part of SWFUpload.
*/


/* **********************
   Event Handlers
   These are my custom event handlers to make my
   web application behave the way I went when SWFUpload
   completes different tasks.  These aren't part of the SWFUpload
   package.  They are part of my application.  Without these none
   of the actions SWFUpload makes will show up in my application.
   ********************** */

window.uploadIdentifierLookup = {}

function fileQueued(file) {
	window.uploadIdentifierLookup[file.id] = "";
	try {
		var progress = new FileProgress(file, window.swfu.customSettings.progressTarget);
		progress.setStatus("Pending...");
		progress.toggleCancel(true, this);

	} catch (ex) {
		window.swfu.debug(ex);
	}

}

function fileQueueError(file, errorCode, message) {
	try {
		if (errorCode === SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED) {
			alert("You have attempted to queue too many files.\n" + (message === 0 ? "You have reached the upload limit." : "You may select " + (message > 1 ? "up to " + message + " files." : "one file.")));
			return;
		}

		var progress = new FileProgress(file, window.swfu.customSettings.progressTarget);
		progress.setError();
		progress.toggleCancel(false);

		switch (errorCode) {
		case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
			progress.setStatus("File is too big.");
			window.swfu.debug("Error Code: File too big, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
			progress.setStatus("Cannot upload Zero Byte files.");
			window.swfu.debug("Error Code: Zero byte file, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
			progress.setStatus("Invalid File Type.");
			window.swfu.debug("Error Code: Invalid File Type, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		default:
			if (file !== null) {
				progress.setStatus("Unhandled Error");
			}
			window.swfu.debug("Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		}
	} catch (ex) {
        window.swfu.debug(ex);
    }
}

function fileDialogComplete(numFilesSelected, numFilesQueued) {
	try {
		if (numFilesSelected > 0) {
			document.getElementById(window.swfu.customSettings.cancelButtonId).disabled = false;
		}
		
		/* I want auto start the upload and I can do that here */
		window.swfu.startUpload();
	} catch (ex)  {
        window.swfu.debug(ex);
	}
}

function uploadStart(file)
{	
	var policyRequestSuccess = false;
	
	try
	{
		// Get a new, validated, upload policy for this file
		new Ajax.Request('/upload/policy?' + Object.toQueryString(file), {
			method:'get',
			asynchronous: false,
			onSuccess: function( transport ){
				policyRequestSuccess = true;
				window.swfu.debug("TRANSPORT FOLLOWING:");
				window.swfu.debug(transport.responseJSON);
				window.swfu.setPostParams( transport.responseJSON["policy_file"] );
				window.swfu.debug("Setting upload_id to " + transport.responseJSON["upload_id"].toString());
				window.uploadIdentifierLookup[file.id] = transport.responseJSON["upload_id"];
			},
			onException: function( transport, e ){
				window.swfu.debug("onException when requesting policy: " + e);
				policyRequestSuccess = false;
			},
			onFailure: function( file, e ){
				window.swfu.debug("onFailure when requesting policy: " + e);
				policyRequestSuccess = false;
			}
		});
		
		// Fire initial progress event
		var progress = new FileProgress(file, window.swfu.customSettings.progressTarget);
		progress.setStatus("Uploading...");
		progress.toggleCancel(true, this);
	}
	catch (ex)
	{
		policyRequestSuccess = false;
	}
	
	if (!policyRequestSuccess)
	{
		// Display error
		uploadError( file, SWFUpload.UPLOAD_ERROR.FILE_VALIDATION_FAILED, "S3 Upload policy not granted." );
	}
	
	return policyRequestSuccess;
}

function uploadProgress(file, bytesLoaded, bytesTotal) {
	try {
		var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);

		var progress = new FileProgress(file, window.swfu.customSettings.progressTarget);
		progress.setProgress(percent);
		progress.setStatus("Uploading... (" + percent.toString() + "%)");
	} catch (ex) {
		window.swfu.debug(ex);
	}
}

function uploadSuccess(file, serverData) {
	window.swfu.debug("Debug, upload ID in uploadSuccess(): " + file.name);
	try {
		var progress = new FileProgress(file, window.swfu.customSettings.progressTarget);
		progress.setComplete();
		progress.setStatus("Generating Thumbnails...");
		progress.toggleCancel(false);
	} catch (ex) {
		window.swfu.debug(ex);
	}
	file.upload_id = window.uploadIdentifierLookup[file.id];
	new Ajax.Request('/upload/file_finished?' + Object.toQueryString(file), {
		method:'get',
		asynchronous: true,
		onSuccess: function(){
			var progress = new FileProgress(file, window.swfu.customSettings.progressTarget);
			progress.setStatus("Finished.");
		},
		onException: function(e){
			window.swfu.debug("uploadSuccess(): onException");
			progress.setStatus("Error finishing the upload. You may need to try again.");
		},
		onFailure: function(e){
			window.swfu.debug("uploadSuccess(): onFailure");
			progress.setStatus("Error finishing the upload. You may need to try again.");
		}
	});
}

function uploadError(file, errorCode, message) {
	try {
		var progress = new FileProgress(file, window.swfu.customSettings.progressTarget);
		progress.setError();
		progress.toggleCancel(false);

		switch (errorCode) {
		case SWFUpload.UPLOAD_ERROR.HTTP_ERROR:
			progress.setStatus("Upload Error: " + message);
			window.swfu.debug("Error Code: HTTP Error, File name: " + file.name + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED:
			progress.setStatus("Upload Failed.");
			window.swfu.debug("Error Code: Upload Failed, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.IO_ERROR:
			progress.setStatus("Server (IO) Error");
			window.swfu.debug("Error Code: IO Error, File name: " + file.name + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.SECURITY_ERROR:
			progress.setStatus("Security Error");
			window.swfu.debug("Error Code: Security Error, File name: " + file.name + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
			progress.setStatus("Upload limit exceeded.");
			window.swfu.debug("Error Code: Upload Limit Exceeded, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.FILE_VALIDATION_FAILED:
			progress.setStatus("Failed Validation.  Upload skipped.");
			window.swfu.debug("Error Code: File Validation Failed, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
			// If there aren't any files left (they were all cancelled) disable the cancel button
			if (window.swfu.getStats().files_queued === 0) {
				document.getElementById(window.swfu.customSettings.cancelButtonId).disabled = true;
			}
			progress.setStatus("Cancelled");
			progress.setCancelled();
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
			progress.setStatus("Stopped");
			break;
		default:
			progress.setStatus("Unhandled Error: " + errorCode);
			window.swfu.debug("Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		}
	} catch (ex) {
        window.swfu.debug(ex);
    }
}

function uploadComplete(file) {
	if (window.swfu.getStats().files_queued === 0) {
		document.getElementById(window.swfu.customSettings.cancelButtonId).disabled = true;
		$('publishBtn').toggle();
	}
}

// This event comes from the Queue Plugin
function queueComplete(numFilesUploaded) {
	var status = document.getElementById("divStatus");
	status.innerHTML = numFilesUploaded + " file" + (numFilesUploaded === 1 ? "" : "s") + " uploaded.";
}
