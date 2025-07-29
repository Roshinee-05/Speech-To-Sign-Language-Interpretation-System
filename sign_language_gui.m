function sign_language_gui
    % Main GUI Window
    fig = uifigure('Name', 'Sign Language Interpreter', 'Position', [100 100 800 600]);

    % Status Label
    statusLabel = uilabel(fig, ...
        'Text', 'Click "Start Recording" to begin.', ...
        'Position', [50 540 700 30], ...
        'FontSize', 14);

    % Label for transcribed text
    uilabel(fig, ...
        'Text', '📝 Transcribed Text:', ...
        'Position', [50 490 200 20], ...
        'FontSize', 14);

    % Transcribed Text Box (Medium Size)
    textBox = uitextarea(fig, ...
        'Position', [50 420 700 60], ...
        'Editable', 'off', ...
        'FontSize', 14);

    % Enlarged Video Display Area
    videoDisplay = uiimage(fig, ...
        'Position', [150 20 500 340]);  % Larger video area

    % Start Recording Button
    startBtn = uibutton(fig, ...
        'Text', '🎤 Start Recording', ...
        'Position', [180 380 200 40], ...
        'FontSize', 16, ...
        'ButtonPushedFcn', @(btn,event) startManualRecording(statusLabel));

    % Stop Recording Button
    stopBtn = uibutton(fig, ...
        'Text', '⏹ Stop Recording', ...
        'Position', [420 380 200 40], ...
        'FontSize', 16, ...
        'ButtonPushedFcn', @(btn,event) stopAndProcessRecording(statusLabel, textBox, videoDisplay));

    % Store recorder as app data
    setappdata(fig, 'recorder', []);
end

function startManualRecording(statusLabel)
    recObj = audiorecorder(16000, 16, 1);
    setappdata(gcf, 'recorder', recObj);  % Store recorder for access
    record(recObj);  % Start recording
    statusLabel.Text = '🎙️ Recording... Click "Stop Recording" to finish.';
    drawnow;
end

function stopAndProcessRecording(statusLabel, textBox, videoDisplay)
    recObj = getappdata(gcf, 'recorder');

    if isempty(recObj)
        statusLabel.Text = '⚠️ No recording in progress.';
        return;
    end

    stop(recObj);
    statusLabel.Text = '🛑 Recording stopped. Processing...';
    drawnow;

    % Save audio
    audioData = getaudiodata(recObj);
    audiowrite('recorded_audio.wav', audioData, 16000);

    % Set Python environment
    try
        pyenv("Version", "Path to python.exe");
    catch
        % Already set
    end

    try
        % Transcribe using Python
        transcribedText = py.transcribe_wav2vec.transcribe_audio('recorded_audio.wav');
        transcribedTextStr = char(transcribedText);
        textBox.Value = transcribedTextStr;
        statusLabel.Text = '✅ Transcription done. Playing videos...';
        drawnow;

        % Play each word's video
        videoFolder = "Path to INDIAN SIGN LANGUAGE ANIMATED VIDEOS folder";
        words = split(transcribedTextStr);

        for i = 1:length(words)
            word = strip(lower(words{i}));
            videoPath = fullfile(videoFolder, word + ".mp4");
            if isfile(videoPath)
                statusLabel.Text = "🎬 Playing: " + word;
                drawnow;
                playVideoInGUI(videoPath, videoDisplay);
            else
                statusLabel.Text = "⚠️ No video for: " + word;
                drawnow;
                pause(1);
            end
        end

        statusLabel.Text = '🎉 Done. You can try again.';
    catch ME
        statusLabel.Text = ['❌ Error: ', ME.message];
    end
end

function playVideoInGUI(videoPath, videoDisplay)
    try
        v = VideoReader(videoPath);
        while hasFrame(v)
            frame = readFrame(v);
            videoDisplay.ImageSource = frame;
            drawnow;
            pause(1 / v.FrameRate);
        end
    catch
        warning("Could not play video: " + videoPath);
    end
end
