function results = doNBack(opt,win)
    if(~exist('opt','var') || ~exist('win','var'))
        ME = MException('WLAB:NBack:WLABNotFound', ...
            'This function can only be called from WLAB');
        throw(ME);
    end
    
    % Marker definitions
    eStimPres = [];
    eTimeout = 5;
    eResponse = 6;
    eSecStart = [5 6];
    eSecEnd = 7;
    
    % Experimental variables
    
    headers = {'subID','numBack','N','practice','positionX', ...
        'positionY','posTrial','responded','respTime'};
    
    conditions = [1 3]; % [Easy Hard]
    sqSize = 80;       % Size of each square, in pixels
    sqPadding = 10;     % Space between each square, in pixels
    stimArrayDim = 3;   % Size of stimulus array (N x N)
    pSame = .5;         % Probability of generating a trial that is the same as the m-back trial

    if(opt.bSpeedy)
        numPracticeTrials = 5;
        numTestTrials = 10;
        stimDispTime = .5;
        blankTime = 2;
        stimRespTime = blankTime - 0.1;
    else
        numPracticeTrials = 20;
        numTestTrials = 100;
        stimDispTime = .5;  % 
        blankTime = 2.5;    % Length of time (in seconds) to blank display between trials
        stimRespTime = blankTime - 0.1;   % Length of time (in seconds) to accept response after stimulus presentation
    end
    
    mx = win.mx;
    my = win.my;
    %rect = Screen('Rect',win.pointer);
    %[mx, my] = RectCenter(rect);
    
    Screen('TextSize',win.pointer,18);
    
    stimOffset = ((sqSize * stimArrayDim) + (sqPadding * (stimArrayDim - 1))) / 2;
                       
    textGreet = [ ...
        'Spatial N-Back\n\n' ...
        'Code Copyright (c) 2010 Nick Penaranda\n' ...
        'George Mason University / ARCH Lab\n\n' ...
        'In this section of the experiment, you will try to keep track of\n' ...
        'the location of a white box as it moves around on the screen. \n\n' ...
        'Press any key to continue.'];
    
    textGreet2 = [ ...
        'There will be a white box that appears somewhere on the screen.\n' ...
        'After a short time, it will disappear then reappear again.\n' ...
        'You should try your best to remember where the white box appears.\n' ...
        'Each time it appears, your job is to compare its current location\n' ...
        'to its location some number of boxes ago.\n\n' ...
        'This number can either be 1 box ago or 3 boxes ago, depending\n' ...
        'on what part of the experiment you are on.\n\n' ...
        'In other words, if the number is 1 box ago, you will compare\n' ...
        'each white box''s location to the one just before it.\n\n' ...
        'If the number is 3 boxes ago, you will compare each white box''s\n' ...
        'location to the third box that appeared before the current one.\n\n' ...
        'Press any key to continue.'];
    
    textGreet3 = [ ...
        'When the current box is in the same location as the one you are\n' ...
        'comparing it to, you will press the "J" key.\n' ...
        'When it is not in the same location as the one you are comparing\n' ...
        'it to, you will press the "F" key.\n\n' ...
        'It is very important to answer as quickly and as accurately as\n' ...
        'possible. If you do not remember the location of a box, try\n' ...
        'your best to guess.\n\n' ...
        'You will be told how many boxes ago you will be comparing against\n' ...
        'and you will be given a chance to practice before each section.\n\n' ...
        'Do you have any questions?\n\n' ...
        'Press any key to continue.'];
        
    dispInfo(win.pointer,textGreet,opt.colText);
    dispInfo(win.pointer,textGreet2,opt.colText);
    dispInfo(win.pointer,textGreet3,opt.colText);
    
    % Latest trials are first, oldest trials are last. Remember m+1 
    % trials so we can increment difficulty by 1 if desired
      
    try
        r = 1;
        for cond=randperm(size(conditions,2));
            if(cond==1)
                condVal = 1;
            else
                condVal = 2;
            end
            
            numBack = conditions(cond);
            StimulusOnsetTime = 0;

            if(numBack > 1) 
                subText = 'boxes have';
            else
                subText = 'box has';
            end

            switch(numBack)
                case 1
                    subText2 = '2nd';
                case 2
                    subText2 = '3rd';
                otherwise
                    subText2 = sprintf('%dth',numBack+1);
            end                     

            if(numBack > 1)
                subText3 = 'boxes';
            else
                subText3 = 'box';
            end

            text = sprintf(['%d-Back.\n\n' ...
                'You will be comparing the current box to the box that appeared\n' ...
                '%d %s ago.\n\n' ...
                'Do not respond until after %d %s been shown.\n\n' ...
                'In other words, you should begin to respond\n' ...
                'when you see the %s box.\n\n' ...
                'Press the "J" key when the current box\n' ...
                'is in the same position as\n' ...
                'the box presented %d screen(s) ago.\n\n' ...
                'Press the "F" when the current box\n' ...
                'is NOT in the same position as\n' ...
                'the box presented %d screen(s) ago.\n' ...
                'Remember to try as best as you can to answer as quickly\n' ...
                'and accurately as possible\n\n' ...
                'Press any key to continue'], ...
                numBack, numBack, subText3, numBack, subText, subText2, numBack, numBack);
            dispInfo(win.pointer,text, opt.colText);

            bContinue = true;
            m = 1;
            maxTrials = numPracticeTrials+numTestTrials+(numBack*2);
            noRespCount = 0;
            while(bContinue)
                if(m == maxTrials), bContinue = false; end
                if(~bContinue), break; end
                
                % If we get 2 non-responses in a row, display remedial
                % message
                if(noRespCount>2)
                    remedialMsg = [ ...
                        'Remember that you should be comparing EVERY white box\n' ...
                        'to the box that appeared %d screen(s) ago.\n\n' ...
                        'That means that you should be responding by pressing either\n' ...
                        'the F key or the J key for EVERY white box that you see.\n\n' ...
                        'If you have any questions about how to perform this task,\n' ...
                        'please inform your experimenter.\n\n' ...
                        'This portion of the task will now restart.\n\n' ...
                        'Press any key to continue.'];
                    dispInfo(win.pointer,sprintf(remedialMsg,numBack),opt.colText);
                    if(bPractice), m = 1;
                    else m = 1 + numPracticeTrials + numBack; end
                    
                    noRespCount = 0;
                end
                if(m == 1)
                    sendEvent(ev(eSecStart,condVal)); % Section Start
                    n = 1;
                    bPractice = true;
                    prevCond = zeros(10,2);
                    curCond = [0 0];
                    text = sprintf([ ...
                        'You will now have %d boxes to practice this portion of the\n' ...
                        'experiment.\n\n' ...
                        'Do you have any questions?\n\n' ...
                        'If not, please place your fingers on the "F" and "J" keys now,\n' ...
                        'then press either key to begin practice.'], ...
                        numPracticeTrials + numBack);
                    dispInfo(win.pointer, text, opt.colText);
                elseif(m == 1 + numPracticeTrials + numBack)
                    n = 1;
                    noRespCount = 0;
                    prevCond = zeros(10,2);
                    curCond = [0 0];
                    text = sprintf([ ...
                        'That is the end of practice. The actual experiment is\n' ...
                        'identical to what you just did.\n\n' ...
                        'Do you have any questions?\n\n' ...
                        'You do not have to remember any of the previous boxes.\n\n' ...
                        'Please place your fingers on the "F" and "J" keys\n' ...
                        'once again.\n\n' ...
                        'When you are ready, press either key to begin the experiment.'], ...
                        numTestTrials + numBack);
                    dispInfo(win.pointer, text, opt.colText);
                    bPractice = false;
                end

                % Trial setup
                prevCond(2:end,:) = prevCond(1:end-1,:);
                prevCond(1,:) = curCond;

                p = rand();

                if(n > numBack && p <= pSame) % This trial will be the same as m-back trial
                    trialType = 1;
                    curCond = prevCond(numBack,:);
                else % Generate a random stimulus, ensuring that it isn't the same as m-back trial
                    if(n <= numBack)
                        trialType = -1;
                    else
                        trialType = 0;
                    end
                    curCond = ceil(rand(1,2)*stimArrayDim);
                    while(isequal(curCond,prevCond(numBack,:)))
                        curCond = ceil(rand(1,2)*stimArrayDim);
                    end
                end

                % Calculate stim coordinates
                sqLoc = [ ...
                    mx - stimOffset + sqPadding*(curCond(1)-1) + sqSize*(curCond(1)-1), ...
                    my - stimOffset + sqPadding*(curCond(2)-1) + sqSize*(curCond(2)-1), ...
                    mx - stimOffset + sqPadding*(curCond(1)-1) + sqSize*curCond(1), ...
                    my - stimOffset + sqPadding*(curCond(2)-1) + sqSize*curCond(2)];

                % Stim presentation
                Screen('FillRect',win.pointer,255,sqLoc);
                if(StimulusOnsetTime > 0)
                    [VBLTimeStamp, StimulusOnsetTime] = Screen('Flip',win.pointer, 0);
                else
                    [VBLTimeStamp, StimulusOnsetTime] = Screen('Flip',win.pointer, StimulusOnsetTime + blankTime);
                end
                sendEvent(ev(eStimPres,3*condVal-1-trialType,bPractice));
                                
                % Check for response and clear stim after expiration
                offTime = StimulusOnsetTime + stimDispTime;
                [keyIsDown, checkTime, keyCode] = KbCheck();
                while(~keyIsDown && checkTime <= StimulusOnsetTime + stimRespTime)
                    WaitSecs(.001);
                    [keyIsDown, checkTime, keyCode] = KbCheck();
                    if(checkTime >= offTime)
                        Screen('Flip',win.pointer,0);
                    end
                end

                trialRT = checkTime - StimulusOnsetTime;

                % Process input and provide feedback
                key = KbName(keyCode);
                dCorrect = -1;
                if(strcmp(key,'esc')==1) % Abort
                    ME = MException('WLAB:NBack:Abort', ...
                        'User aborted experiment.');
                    throw(ME);
                elseif(strcmp(key,'j')==1 && trialType == 0) % Positive response, negative trial
                    dCorrect = 0;
                    DrawFormattedText(win.pointer,'INCORRECT','center','center',opt.colText);
                    Screen('Flip',win.pointer);
                    trialResp = 1;
                elseif(strcmp(key,'j')==1 && trialType == 1) % Positive response, positive trial
                    dCorrect = 1;
                    DrawFormattedText(win.pointer,'CORRECT','center','center',opt.colText);
                    Screen('Flip',win.pointer);
                    trialResp = 1;
                elseif(strcmp(key,'f')==1 && trialType == 1) % Negative response, positive trial
                    dCorrect = 0;
                    DrawFormattedText(win.pointer,'INCORRECT','center','center',opt.colText);
                    Screen('Flip',win.pointer);
                    trialResp = 0;
                elseif(strcmp(key,'f')==1 && trialType == 0) % Negative response, negative trial
                    dCorrect = 1;
                    DrawFormattedText(win.pointer,'CORRECT','center','center',opt.colText);
                    Screen('Flip',win.pointer);
                    trialResp = 0;
                elseif(strcmp(key,'backspace')==1) % Skip
                    trialResp = -1;
                    bContinue = false;
                else
                    Screen('Flip',win.pointer);
                    sendEvent(ev(eTimeout,condVal,bPractice));
                    trialResp = -1;
                    trialRT = -1;
                end
                
                if(trialType ~= -1 && trialResp == -1)
                    noRespCount = noRespCount + 1;
                else
                    noRespCount = 0;
                end
                
                
                if(dCorrect > -1) % Some sort of valid response was made--send marker
                    sendEvent(ev(eResponse,2*condVal-dCorrect,bPractice));
                end

                % Record data
                data{r,1} = opt.subID;
                data{r,2} = conditions(cond);
                data{r,3} = n;
                data{r,4} = bPractice;
                data{r,5} = curCond(1);
                data{r,6} = curCond(2);
                data{r,7} = trialType;
                data{r,8} = trialResp;
                data{r,9} = trialRT;

                r = r + 1;
                n = n + 1;
                % Wait until next trial
                WaitSecs('UntilTime', StimulusOnsetTime + stimDispTime + blankTime);
                m = m + 1;
            end
            sendEvent(ev(eSecEnd,condVal)); % Section end
        end
        
        textEnd = [ ...
            'That concludes this portion of the experiment.\n\n' ...
            'Please inform your experimenter.'];
        dispInfo(win.pointer,textEnd,opt.colText);
    
    catch ME
        results = vertcat(headers,data);
        save 'lastExperiment.mat' results;
        
        rethrow(ME);
    end
    
    results = vertcat(headers,data);
    save 'lastExperiment.mat' results;

end