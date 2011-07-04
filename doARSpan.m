function results = doARSpan(opt,win)
%     DEBUG_SKIP_PRAC1 = [];
%     DEBUG_SKIP_PRAC2 = [];
%     DEBUG_SKIP_PRAC3 = [];
    
    % WLAB check
    if(~exist('opt','var') || ~exist('win','var'))
        ME = MException('WLAB:ARSpan:WLABNotFound', ...
            'This function can only be called from WLAB');
        throw(ME);
    end
    
    results = [];
    
    % Marker definition(s) (more are defined elsewhere in this file)
    eSenseResponse = 6;
    eSecStart = [6 7];
    eSecEnd = [5 6 7];
    
    % Constants
    global ptb_mouseclick_timeout; ptb_mouseclick_timeout = 0;
    
    textGreet = ['ARSPAN\n\n' ...
        'Task Copyright (c) 2005 Dr. Randall Engle\n' ...
        'http://psychology.gatech.edu/renglelab/\n\n' ...
        'Adapted to MATLAB as a part of WLAB\n' ...
        'Code Copyright (c) 2010 Nick Penaranda\n' ...
        'George Mason University / ARCH Lab\n\n' ...
        'In this section of the experiment you will try to memorize letters\n' ...
        'you see on the screen while you also read sentences.\n\n' ...
        'This section will take approximately 15 minutes.\n\n' ...
        'In the next few minutes, you will have some practice\n' ...
        'to get you familiar with how the experiment works.\n\n' ...
        'Click the mouse button to continue.'];
    textPracLetter = ['Practice part I\n\n' ...
        'For this practice set, letters will appear on the screen\n' ...
        'one at a time. Try to remember each letter in the order\n' ...
        'they were presented.\n\n' ...
        'After 2 to 3 letters have been shown, you will see a\n' ...
        'screen listing 12 possible letters.\n\n' ...
        'Your job is to select each letter in the order presented.\n' ...
        'To do this, use the mouse to select each letter.\n' ...
        'The letters you select will appear at the bottom of the screen.\n\n' ...
        'Click the mouse button to continue.'];
    textPracLetter2 = ['Practice part I\n\n' ...
        'When you have selected all the letters, and they are in the\n' ...
        'correct order, hit the OK box at the bottom right of the screen.\n' ...
        'If you make a mistake, hit the BACK box to backspace.\n' ...
        'If you forget one of the letters, click the ? box to mark the spot\n' ...
        'for the missing letter.\n\n' ...
        'Remember, it is very important to get the letters in\n' ...
        'the same order as you see them. If you forget one, use the ? box\n' ...
        'to mark the position.\n' ...
        'Do you have any questions so far?\n\n' ...
        'When you''re ready, click the mouse button to\n' ...
        'start the letter practice.'];
    textPracReading = ['Practice part II\n\n' ...
        'Now you will practice doing the sentence reading part of the\n' ...
        'experiment.\n\n' ...
        'A sentence will appear on the screen, like this:\n\n' ...
        '"I like to run in the park."\n\n' ...
        'As soon as you see the sentence, you should read it and determine\n' ...
        'if it makes sense or not. The above sentence makes sense.\n' ...
        'An example of a sentence that does not make sense would be:\n\n' ...
        '"I like to run in the sky."\n\n' ...
        'When you have read the sentence and determined whether it makes\n' ...
        'sense or not, you will click the mouse button.\n\n\n' ...
        'Click the mouse to continue'];
    textPracReading2 = ['Practice part II\n\n' ...
        'You will then see "This sentence makes sense." displayed on the\n' ...
        'next screen, along with a box marked TRUE and a box marked FALSE.\n\n' ...
        'If the sentence on the previous screen made sense, click\n' ...
        'on the TRUE box with the mouse.\n' ...
        'If the sentence did not make sense, click on the FALSE box.\n\n' ...
        'After you click on one of the boxes, the computer will tell you\n' ...
        'if you made the right choice.\n\n' ...
        'It is VERY important that you answer the sentence problems\n' ...
        'correctly. It is also important that you try and read the\n' ...
        'sentences as quickly as you can.\n\n' ...
        'Do you have any questions?\n\n' ...
        'When you''re ready, click the mouse to try some practice problems.\n'];
    textPracBoth = ['Practice part III\n\n' ...
        'Now you will practice doing both parts of the experiment at the\n' ...
        'same time.\n\n' ...
        'In the next practice set, you will be given one sentence to read.\n' ...
        'Once you make your decision about the sentence, a letter will\n' ...
        'appear on the screen. Try and remember the letter.\n' ...
        'In the previous section where you only read the sentences,\n' ...
        'the computer computed your average time to read the sentences.\n' ...
        'If you take longer than your average time, the computer will\n' ...
        'automatically move you onto the next letter part, thus skipping\n' ...
        'the True or False part and will count that problem as a sentence\n' ...
        'error.\n\n' ...
        'Therefore, it is VERY important to read the sentences as quickly\n' ...
        'and as accurately as possible.\n\n' ...
        'Click the mouse to continue.'];
    textPracBoth2 = ['Practice part III\n\n' ...
        'After the letter goes away, another sentence will appear,\n' ...
        'and then another letter.\n\n' ...
        'At the end of each set of letters and sentences, a recall screen\n' ...
        'will appear. Use the mouse to select the letters you just saw.\n\n' ...
        'Try your best to get the letters in the correct order.\n' ...
        'It is important to work QUICKLY and ACCURATELY on the sentences.\n' ...
        'Make sure you know whether the sentence makes sense or not\n' ...
        'before clicking to the next screen.\n\n' ...
        'You will not be told if your answer regarding the sentence is\n' ...
        'correct. After the recall screen, you will be given feedback\n' ...
        'about your performance regarding both the number of letters\n' ...
        'recalled and the percent correct on the sentence problems.\n\n' ...
        'Do you have any questions?\n\n' ...
        'Click the mouse to continue.\n'];
    textPracBoth3 = ['Practice part III\n\n' ...
        'During the feedback, you will see a number in red in the top right\n' ...
        'of the screen.\n\n' ...
        'This indicates your percent correct for the sentence problems for\n' ...
        'the entire experiment.\n' ...
        'It is VERY important for you to keep this at least at 85%.\n' ...
        'For our purposes, we can only use data where the participant was\n' ...
        'at least 85% accurate on the sentences.\n\n' ...
        'Therefore, in order for you to be asked to come back for future\n' ...
        'experiments, you must perform at least at 85% on the sentence\n' ...
        'problems WHILE doing your best to recall as many letters as possible.\n\n' ...
        'Do you have any questions?\n\n' ...
        'Click the mouse to try some practice problems.'];
    textExperiment = ['Experiment I\n\n' ...
        'The real trials will look like the practice trials you just completed.\n' ...
        'First you will get a sentence to read, then a letter to remember.\n\n' ...
        'When you see the recall screen, select the letters in the order presented.\n' ...
        'Some sets will have as few as 3 sentences and letters, while others\n' ...
        'may have as many as 7 sentences and letters.\n\n' ...
        'It is important that you do your best on both the sentence problems and\n' ...
        'the letter recall parts of this experiment.\n\n' ...
        'Remember for the sentences you must work as QUICKLY and ACCURATELY as\n' ...
        'possible. Also, remember to keep your sentence accuracy at 85% or above.\n\n' ...
        'Do you have any questions?\n\n' ...
        'If not, click the mouse to begin the experiment.'];
    textComplete = ['That concludes this portion of the experiment.\n\n' ...
        'Please inform your experimenter.'];
        
    r.yes = [win.mx+20, win.my + 30, win.mx + 320, win.my + 120];
    [r.yesCenterX,r.yesCenterY] = RectCenter(r.yes);

    r.no  = [win.mx-320, win.my + 30, win.mx - 20, win.my + 120];
    [r.noCenterX,r.noCenterY] = RectCenter(r.no);
    
    stimInterval = 0.5; % Seconds
    recallDispTime = 1.0; % Seconds
    
    z = load('RSpanPractice.mat'); cPractice = z.Practice;
    z = load('RSpanExperiment.mat'); cExperiment = z.Experiment;
    
    letters = ['F','P','Q','J','H','K','T','S','N','R','Y','L'];

    if(opt.bSpeedy)
        numPrac = round(size(cPractice,1)/2);
        pracSpans = [3 3 2 2]; 
        expSpansLow = [3 3 4 4]; 
        expSpansHigh = [6 6 7 7];
    else
        numPrac = size(cPractice,1);
        pracSpans = [3 3 3 2 2 2]; 
        expSpansLow = [3 3 3 3 3 3 4 4 4 4 4 4]; 
        expSpansHigh = [6 6 6 7 7 7];
    end
    
    r.X = 4;
    r.Y = 3;
    r.sizeX = 120;
    r.sizeY = 80;
    r.padding = 10;
    r.letters = cell(r.Y,r.X);
    r.xOffset = win.mx - (((r.sizeX * r.X) + (r.padding * (r.X - 1))) / 2);
    r.yOffset = win.my - (((r.sizeY * r.Y) + (r.padding * (r.Y - 1))) / 2) - 250;
    
    % Define matrix of letter button bounding boxes
    for i=1:r.X
        for j=1:r.Y
            r.letters{j,i} = [...
                r.xOffset + ((r.sizeX + r.padding) * (i - 1)), ...
                r.yOffset + ((r.sizeY + r.padding) * (j - 1)), ...
                r.xOffset + ((r.sizeX + r.padding) * (i - 1)) + r.sizeX, ...
                r.yOffset + ((r.sizeY + r.padding) * (j - 1)) + r.sizeY];
        end
    end
    
    % Define bounding boxes for other recall screen buttons
    r.unknown = [win.mx - r.sizeX - 10, r.yOffset + ((r.sizeY + r.padding) * 3), ...
         win.mx - 10, r.yOffset + ((r.sizeY + r.padding) * 3) + r.sizeY];
    r.back = [win.mx + 10, r.yOffset + ((r.sizeY + r.padding) * 3), ...
         win.mx + r.sizeX + 10, r.yOffset + ((r.sizeY + r.padding) * 3) + r.sizeY];
    r.ok = [win.mx - r.sizeX/2, r.yOffset + ((r.sizeY + r.padding) * 5), ...
        win.mx + r.sizeX/2, r.yOffset + ((r.sizeY + r.padding) * 5) + r.sizeY];
    r.buffer = [win.mx - 200, r.yOffset + ((r.sizeY + r.padding) * 4), ...
        win.mx + 200, r.yOffset + ((r.sizeY + r.padding) * 4) + r.sizeY];
     
    headersSentence = {'subID','spanSize','totalN','setN','trialN','sentence', ...
        'sentType','resp','correct','respTime','practice'};
    rSentence = 1;
    
    headersRecall = {'subID','spanSize','totalN','setN','recallSet', ...
        'respSet','nCorrect','practice',' ',' ',' '};
    rRecall = 1;
    
    nCols = max(length(headersSentence),length(headersRecall));
    dataSentence = cell(1,nCols);
    dataRecall = cell(1,nCols);
    
    ShowCursor('Hand');
    
    dispInfo(win.pointer,textGreet,opt.colText);
    
    try
        %% **** PRACTICE I ****
        if(~exist('DEBUG_SKIP_PRAC1','var'))
            dispInfo(win.pointer,textPracLetter,opt.colText);
            dispInfo(win.pointer,textPracLetter2,opt.colText);

            orderPracSpans = randperm(length(pracSpans));
            nRecallSet = 1;
            % @@MARKER@@ Practice I start
            for n=orderPracSpans
                stimLetters = shuffle(letters); % First n will be stimulus
                pracSpanSize = pracSpans(n);
                stimLetters = stimLetters(1:pracSpanSize);
                disp(['Recall set = ' stimLetters]);
                mLetters = reshape(shuffle(letters),4,3)'; % These will be the letters in the buttons

                for i=1:length(stimLetters)
                    showLetter(win,opt,stimLetters(i),stimInterval,recallDispTime,3,true);
                end

                buffer = showRecallScreen(win,opt,r,mLetters,3,true);
                letterPerf = judgeRecall(stimLetters,buffer);
                dataRecall{rRecall,1} = opt.subID;
                dataRecall{rRecall,2} = pracSpanSize;
                dataRecall{rRecall,3} = rRecall;
                dataRecall{rRecall,4} = nRecallSet;
                dataRecall{rRecall,5} = stimLetters;
                dataRecall{rRecall,6} = buffer;
                dataRecall{rRecall,7} = letterPerf.nCorrect;
                dataRecall{rRecall,8} = true; % This is practice!

                rRecall = rRecall + 1;
                nRecallSet = nRecallSet + 1;
            end

        end

        %% **** PRACTICE II ****
        if(~exist('DEBUG_SKIP_PRAC2','var'))
            dispInfo(win.pointer,textPracReading,opt.colText);
            dispInfo(win.pointer,textPracReading2,opt.colText);
            % @@MARKER@@ Practice II start
            orderPrac = randperm(numPrac);
            pracRT = zeros(numPrac,1);
            n = 1;
            nWrong = 0;

            for i=orderPrac
                sText = cPractice{i,1};
                nType = cPractice{i,2};
                RT = showSentence(win,opt,sText,stimInterval,-1,3,nType,true);

                % Prompt screen
                [response,RTPrompt] = showSensePrompt(win,opt,r);

                bCorrect = false;
                if(response && nType == 1)
                    bCorrect = true;
                    %disp('Correct Detection');
                elseif(~response && nType == 0)
                    bCorrect = true;
                    %disp('Correct Rejection');
                elseif(response && nType == 0)
                    %disp('False Alarm');
                    nWrong = nWrong + 1;
                elseif(~response && nType == 1)
                    %disp('Miss');
                    nWrong = nWrong + 1;
                end

                pracRT(n) = RT;
                disp(['RT: ' num2str(pracRT(n))]);

                dataSentence{rSentence,1} = opt.subID;
                dataSentence{rSentence,2} = 'N/A';
                dataSentence{rSentence,3} = rSentence;
                dataSentence{rSentence,4} = 'N/A';
                dataSentence{rSentence,5} = n;
                dataSentence{rSentence,6} = sText;
                dataSentence{rSentence,7} = nType;
                dataSentence{rSentence,8} = response;
                dataSentence{rSentence,9} = bCorrect;
                dataSentence{rSentence,10} = RT;
                dataSentence{rSentence,11} = true; % This is practice!
                rSentence = rSentence + 1;
                n = n + 1;        
            end

            avgRT = mean(pracRT);
            sdRT = std(pracRT);
            cutoffRT = avgRT + sdRT*2.5;
            disp(['Correct %: ' num2str((numPrac-nWrong)/numPrac*100,'%2.2f')]);
            disp(['Average RT: ' num2str(avgRT)]);
            disp(['RT S.D.:    ' num2str(sdRT)]);
            disp(['Cut-off: ' num2str(cutoffRT)]);
        else
            cutoffRT = 2.0;
        end

        %% **** PRACTICE III ****
        if(~exist('DEBUG_SKIP_PRAC3','var'))
            dispInfo(win.pointer,textPracBoth,opt.colText);
            dispInfo(win.pointer,textPracBoth2,opt.colText);
            dispInfo(win.pointer,textPracBoth3,opt.colText);

            %cPractice = shuffle(cPractice); % Shuffle the practice sentences order
            orderPracBoth = randperm(length(pracSpans));
            n = 1;
            nRecallSet = 1;

            cumSentPerf.nCorrect = 0;
            cumSentPerf.nTotal = 0;
            for i = orderPracBoth
                nWrong = 0;
                stimLetters = shuffle(letters); % First n will be stimulus
                pracSpanSize = pracSpans(i);
                stimLetters = stimLetters(1:pracSpanSize);
                disp(['Recall set = ' stimLetters]);
                mLetters = reshape(shuffle(letters),4,3)'; % These will be the letters in the buttons

                for j=1:length(stimLetters) % Sentence/letter loop
                    sText = cPractice{n,1};
                    nType = cPractice{n,2};

                    RT = showSentence(win,opt,sText,stimInterval,cutoffRT,3,nType,true);
                    bCorrect = false;
                    if(RT > 0)
                        [response, RTPrompt] = showSensePrompt(win,opt,r);
                        if(response && nType == 1)
                            bCorrect = true;
                            disp('Correct Detection');
                        elseif(~response && nType == 0)
                            bCorrect = true;
                            disp('Correct Rejection');
                        elseif(response && nType == 0)
                            disp('False Alarm');
                            nWrong = nWrong + 1;
                        elseif(~response && nType == 1)
                            disp('Miss');
                            nWrong = nWrong + 1;
                        end
                    else
                        disp('No response to sentence');
                        nWrong = nWrong + 1;
                    end

                    disp(['RT: ' num2str(RT)]);
                    dataSentence{rSentence,1} = opt.subID;
                    dataSentence{rSentence,2} = pracSpanSize;
                    dataSentence{rSentence,3} = rSentence;
                    dataSentence{rSentence,4} = nRecallSet;
                    dataSentence{rSentence,5} = j;
                    dataSentence{rSentence,6} = sText;
                    dataSentence{rSentence,7} = nType;
                    dataSentence{rSentence,8} = response;
                    dataSentence{rSentence,9} = bCorrect;
                    dataSentence{rSentence,10} = RT;
                    dataSentence{rSentence,11} = true; % This is practice!
                    rSentence = rSentence + 1;
                    n = n + 1;

                    showLetter(win,opt,stimLetters(j),stimInterval,recallDispTime,3,true);
                end

                sentPerf.nCorrect = j-nWrong;
                sentPerf.nTotal = j;
                cumSentPerf.nCorrect = cumSentPerf.nCorrect + sentPerf.nCorrect;
                cumSentPerf.nTotal = cumSentPerf.nTotal + sentPerf.nTotal;

                buffer = showRecallScreen(win,opt,r,mLetters,3,true);
                letterPerf = judgeRecall(stimLetters,buffer);
                dataRecall{rRecall,1} = opt.subID;
                dataRecall{rRecall,2} = pracSpanSize;
                dataRecall{rRecall,3} = rRecall;
                dataRecall{rRecall,4} = nRecallSet;
                dataRecall{rRecall,5} = stimLetters;
                dataRecall{rRecall,6} = buffer;
                dataRecall{rRecall,7} = letterPerf.nCorrect;
                dataRecall{rRecall,8} = true; % This is practice!
                rRecall = rRecall + 1;
                nRecallSet = nRecallSet + 1;
                showFeedbackScreen(win,opt,sentPerf,letterPerf,cumSentPerf);
            end
        end
        
        %% **** EXPERIMENT ****
        dispInfo(win.pointer,textExperiment,opt.colText);

        cExperiment = shuffle(cExperiment); % Shuffle the experimental sentences

        % Shuffle difficulties within each
        expSpansLow = expSpansLow(randperm(length(expSpansLow)));
        expSpansHigh = expSpansHigh(randperm(length(expSpansHigh)));

        % Concatenate span arrays
        if(rand() >= 0.5) % High difficulty first
            condVal = 2;
            expSpans = [expSpansHigh,expSpansLow];
        else
            condVal = 1;
            expSpans = [expSpansLow,expSpansHigh];
        end

        n = 1;
        nRecallSet = 1;
        cumSentPerf.nCorrect = 0;
        cumSentPerf.nTotal = 0;

        bSwitchedCond = false;
        sendEvent(ev(eSecStart,condVal));
        for i = 1:length(expSpans);
            nWrong = 0;
            stimLetters = shuffle(letters); % First n will be stimulus
            spanSize = expSpans(i);
            if(~bSwitchedCond && condVal==2 && spanSize < 5)
                sendEvent(ev(eSecEnd,condVal));
                condVal = 1;
                bSwitchedCond = true;
                sendEvent(ev(eSecStart,condVal));
            elseif(~bSwitchedCond && condVal==1 && spanSize > 5)
                sendEvent(ev(eSecEnd,condVal));
                condVal = 2;
                bSwitchedCond = true;
                sendEvent(ev(eSecStart,condVal));
            end
            
            stimLetters = stimLetters(1:spanSize);
            disp(['Recall set = ' stimLetters]);
            mLetters = reshape(shuffle(letters),4,3)'; % These will be the letters in the buttons

            for j=1:length(stimLetters) % Sentence/letter loop
                sText = cExperiment{n,1};
                nType = cExperiment{n,2};

                RT = showSentence(win,opt,sText,stimInterval,cutoffRT,condVal,nType);
                bCorrect = false;
                if(RT > 0)
                    [response, RTPrompt] = showSensePrompt(win,opt,r);
                    if(response && nType == 1)
                        bCorrect = true;
                        disp('Correct Detection');
                    elseif(~response && nType == 0)
                        bCorrect = true;
                        disp('Correct Rejection');
                    elseif(response && nType == 0)
                        disp('False Alarm');
                        nWrong = nWrong + 1;
                    elseif(~response && nType == 1)
                        disp('Miss');
                        nWrong = nWrong + 1;
                    end
                    sendEvent(ev(eSenseResponse,2*condVal-bCorrect,false));
                else
                    disp('No response to sentence');
                    nWrong = nWrong + 1;
                end

                disp(['RT: ' num2str(RT)]);
                dataSentence{rSentence,1} = opt.subID;
                dataSentence{rSentence,2} = spanSize;
                dataSentence{rSentence,3} = rSentence;
                dataSentence{rSentence,4} = nRecallSet;
                dataSentence{rSentence,5} = j;
                dataSentence{rSentence,6} = sText;
                dataSentence{rSentence,7} = nType;
                dataSentence{rSentence,8} = response;
                dataSentence{rSentence,9} = bCorrect;
                dataSentence{rSentence,10} = RT;
                dataSentence{rSentence,11} = false;
                rSentence = rSentence + 1;
                n = n + 1;

                showLetter(win,opt,stimLetters(j),stimInterval,recallDispTime,condVal);
            end

            sentPerf.nCorrect = j-nWrong;
            sentPerf.nTotal = j;
            cumSentPerf.nCorrect = cumSentPerf.nCorrect + sentPerf.nCorrect;
            cumSentPerf.nTotal = cumSentPerf.nTotal + sentPerf.nTotal;

            buffer = showRecallScreen(win,opt,r,mLetters,condVal);
            letterPerf = judgeRecall(stimLetters,buffer);
            dataRecall{rRecall,1} = opt.subID;
            dataRecall{rRecall,2} = spanSize;
            dataRecall{rRecall,3} = rRecall;
            dataRecall{rRecall,4} = nRecallSet;
            dataRecall{rRecall,5} = stimLetters;
            dataRecall{rRecall,6} = buffer;
            dataRecall{rRecall,7} = letterPerf.nCorrect;
            dataRecall{rRecall,8} = false;
            rRecall = rRecall + 1;
            nRecallSet = nRecallSet + 1;
            
            showFeedbackScreen(win,opt,sentPerf,letterPerf,cumSentPerf);
        end
        sendEvent(ev(eSecEnd,condVal));
        
        dispInfo(win.pointer,textComplete,opt.colText);
    catch ME
        results = vertcat(headersSentence,dataSentence,headersRecall,dataRecall);
        save 'lastExperiment.mat' results;
        
        rethrow(ME)
    end
    
    results = vertcat(headersSentence,dataSentence,headersRecall,dataRecall);
    save 'lastExperiment.mat' results;

    function letterPerf = judgeRecall(stimLetters,buffer)
        n = min(length(stimLetters),length(buffer));
        c = eq(stimLetters(1:n),buffer(1:n));
        letterPerf.nCorrect = length(c(c==1));
        letterPerf.nTotal = length(stimLetters);
        disp(['  Recall set: ' stimLetters]);
        disp(['  Response:   ' buffer]);
        fprintf('  Perf:       %d of %d correct\n', letterPerf.nCorrect, letterPerf.nTotal);
        
    function showFeedbackScreen(win,opt,sentPerf,letterPerf,cumSentPerf)
        textPerformance = sprintf(...
            ['You were correct on %d of %d sentences. (%.2f%%)\n\n' ...
             'You were correct on %d of %d letters.\n\n' ...
             'Click the mouse button to continue.'], ...
             sentPerf.nCorrect,sentPerf.nTotal,100*sentPerf.nCorrect/sentPerf.nTotal, ...
             letterPerf.nCorrect,letterPerf.nTotal);
        textCumPerf = sprintf('%.2f%%',100*cumSentPerf.nCorrect/cumSentPerf.nTotal);
        
        DrawFormattedText(win.pointer,textPerformance,'center','center',opt.colText);
        DrawFormattedText(win.pointer,textCumPerf, ...
            win.rect(RectRight)-120,win.rect(RectTop) + 5,[255 0 0]);
        Screen('Flip',win.pointer);
        GetClicks(win.pointer);
        
    function [response,rt] = showSensePrompt(win,opt,r)
        DrawFormattedText(win.pointer,'This sentence makes sense.', ...
            'center','center',opt.colText);
        % Draw buttons
        Screen('FrameRect',win.pointer,opt.colText, r.yes,2);
        DrawFormattedText(win.pointer,'TRUE',r.yesCenterX-25,r.yesCenterY-15,opt.colText);

        Screen('FrameRect',win.pointer,opt.colText, r.no,2);
        DrawFormattedText(win.pointer,'FALSE',r.noCenterX-35,r.noCenterY-15,opt.colText);

        [VBLTimestamp StimulusOnsetTime] = Screen('Flip',win.pointer);

        % @@MARKER@@ Sentence makes sense prompt appears
        bGetClicks = true;
        while(bGetClicks)
            [clicks,x,y] = GetClicks(win.pointer);
            if(IsInRect(x,y,r.yes))
                response = true;
                bGetClicks = false;
            elseif(IsInRect(x,y,r.no))
                response = false;
                bGetClicks = false;
            end
        end
        clickTime = GetSecs();
        rt = clickTime - StimulusOnsetTime;

    function [x,y,buttons] = GetTimedClicks(h,timeLimit,absTime)
        if(~exist('absTime','var'))
            absTime = 0;
        end

        if(absTime)
            cutoffTime = timeLimit;
        else
            start = GetSecs();
            cutoffTime = start + timeLimit;
        end

        [x,y,buttons] = GetMouse(h);
        while any(buttons) && GetSecs() < cutoffTime % Wait until buttons are released
            [x,y,buttons] = GetMouse(h);
        end
        while ~any(buttons) && GetSecs() < cutoffTime % Wait until first button press
            [x,y,buttons] = GetMouse(h);
        end
    
    function rt = showSentence(win,opt,text,tFixation,tStimulus,condVal,trialType,bPractice)
        % Marker definitions
        eSentPres = [];
        eSentResponse = 5;

        if(exist('condVal','var') && exist('trialType','var'))
            bMarkers = true;
            if(~exist('bPractice','var'))
                bPractice = false;
            end
        else
            bMarkers = false;
        end
        % Clear stim flip with fixation cross
        Screen('DrawLine',win.pointer,opt.colText,win.mx-10,win.my,win.mx+10,win.my,2);
        Screen('DrawLine',win.pointer,opt.colText,win.mx,win.my-10,win.mx,win.my+10,2);
        Screen('Flip',win.pointer);
        WaitSecs(tFixation);

        % Draw text
        DrawFormattedText(win.pointer,text,'center','center',opt.colText);
        %if(~opt.bWindowed) 
        %    setMouse(win.mx,win.my,win.pointer);
        %end

        % Stim display flip
        [VBLTimestamp StimulusOnsetTime] = Screen('Flip',win.pointer);
        if(bMarkers)
            sendEvent(ev(eSentPres,2*condVal-trialType,bPractice));
        end
        
        bRespMade = false;
        if(~exist('tStimulus','var') || tStimulus <= 0) % No time limit
            GetClicks(win.pointer);
            bRespMade = true;
        else
            [x,y,buttons] = GetTimedClicks(win.pointer,tStimulus);
            if(any(buttons))
                bRespMade = true;
            end
        end

        if(bRespMade)
            % @@MARKER@@ Response to sentence prompt
            if(bMarkers)
                sendEvent(ev(eSentResponse,1,bPractice));
            end
            clickTime = GetSecs();
            rt = clickTime - StimulusOnsetTime;
        else
            % @@MARKER@@ Absence of response to sentence prompt (timeout)
            if(bMarkers)
                sendEvent(ev(eSentResponse,2,bPractice));
            end
            rt = -1;
        end

    function showLetter(win,opt,letter,tFixation,tStimulus,condVal,bPractice)
        % Marker definition(s)
        eLetterPres = [5 6];
        if(exist('condVal','var'))
            bMarkers = true;
            if(~exist('bPractice','var'))
                bPractice = false;
            end
        else
            bMarkers = false;
        end
        Screen('DrawLine',win.pointer,opt.colText,win.mx-10,win.my,win.mx+10,win.my,2);
        Screen('DrawLine',win.pointer,opt.colText,win.mx,win.my-10,win.mx,win.my+10,2);
        Screen('Flip',win.pointer);
        WaitSecs(tFixation);
        DrawFormattedText(win.pointer,letter,'center','center', ...
            opt.colText);
        Screen('Flip',win.pointer);
        % @@MARKER@@ Letter appears
        if(bMarkers)
            sendEvent(ev(eLetterPres,condVal,bPractice));
        end
        WaitSecs(tStimulus);

    function buffer = showRecallScreen(win,opt,r,mLetters,condVal,bPractice)
        % Marker definition(s)
        eRecallPres = 7;
        eRecallResponse = [5 7];

        if(exist('condVal','var'))
            bMarkers = true;
            if(~exist('bPractice','var'))
                bPractice = false;
            end
        else
            bMarkers = false;
        end
        
        % Draw letter boxes
        for i=1:r.X
            for j=1:r.Y
                Screen('FrameRect',win.pointer, opt.colText, r.letters{j,i},2);
                [mx,my] = RectCenter(r.letters{j,i});
                DrawFormattedText(win.pointer,mLetters(j,i),mx-5,my-15,opt.colText);
            end
        end

        % Draw ? Button
        Screen('FrameRect',win.pointer,opt.colText, r.unknown,2);
        [mx,my] = RectCenter(r.unknown);
        DrawFormattedText(win.pointer,'?',mx-5,my-15,opt.colText);

        % Draw Back Button
        Screen('FrameRect',win.pointer,opt.colText, r.back,2);
        [mx,my] = RectCenter(r.back);
        DrawFormattedText(win.pointer,'Back',mx-25,my-15,opt.colText);

        % Draw Ok Button
        Screen('FrameRect',win.pointer,opt.colText, r.ok,2);
        [mx,my] = RectCenter(r.ok);
        DrawFormattedText(win.pointer,'Ok',mx-15,my-15,opt.colText);

        Screen('Flip',win.pointer, [], 1);
        % @@MARKER@@ Recall screen appears
        if(bMarkers)
            sendEvent(ev(eRecallPres,condVal,bPractice));
        end
        buffer = [];
        bTakeInput = true;
        while(bTakeInput)
           [clicks,x,y] = GetClicks(win.pointer);
           % Function buttons
           if(IsInRect(x,y,r.unknown)==1)
               buffer = strcat(buffer,'?');
           elseif(IsInRect(x,y,r.back)==1 && ~isempty(buffer))
               buffer = buffer(1:end-1);
           elseif(IsInRect(x,y,r.ok)==1)
               % @@MARKER@@ Click Response Completed
               if(bMarkers)
                   sendEvent(ev(eRecallResponse,condVal,bPractice));
               end
               Screen('FillRect',win.pointer,opt.colClear);
               Screen('Flip',win.pointer);
               bTakeInput = false;
           end

           % Letter buttons
           for i=1:numel(mLetters)
               if(IsInRect(x,y,r.letters{i})==1)
                   buffer = strcat(buffer,mLetters(i));
               end
           end

           if(bTakeInput)
               Screen('FillRect',win.pointer,opt.colClear,r.buffer);
               DrawFormattedText(win.pointer,buffer,'center', ...
                   r.yOffset + ((r.sizeY + r.padding) * 4) + 20, opt.colText);
               %disp(['Buffer = ' buffer]);
               Screen('Flip',win.pointer, [], 1);
           end
        end
