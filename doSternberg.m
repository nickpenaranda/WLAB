function results = doSternberg(opt,win)
    if(~exist('opt','var') || ~exist('win','var'))
        ME = MException('WLAB:Sternberg:WLABNotFound', ...
            'This function can only be called from WLAB');
        throw(ME);
    end
    
    % Marker definitions
    eRecallPres = [];
    eTestPres = [5];
    eResponse = [6];
    eSecStart = [5 6];
    eSecEnd   = [7];
    
    textGreet = ['Sternberg Memory Task\n\n' ...
        'Task Copyright (c) 1969 Dr. Saul Sternberg\n\n' ...
        'Adapted to MATLAB as a part of WLAB\n' ...
        'Code Copyright (c) 2010 Nick Penaranda\n' ...
        'George Mason University / ARCH Lab\n\n' ...
        'In this section of the experiment we will be testing your\n' ...
        'ability to remember a list of numbers.\n\n' ...
        'This section will take approximately 10-15 minutes.\n\n' ...
        'Press any key to continue.'];
    textGreet2 = [ ...
        'This experiment is split into two groups of problems.\n\n' ...
        'For each group of problems, you will be given instructions then\n' ...
        'given a chance to practice.\n\n' ...
        'For each problem, you will be shown a list of numbers. Try to\n' ...
        'remember this list as best as possible.\n' ...
        'After you see the list of numbers, you will see a "#" sign\n' ...
        'and then a number.\n\n' ...
        'You must then decide if this number was or was not in the list\n' ...
        'of numbers.\n\n' ...
        'If the number WAS in the list, you will press the "J" key\n' ...
        'If the number WAS NOT in the list, you will press the "F" key\n\n' ...
        'It is very important to respond as quickly and accurately as\n' ...
        'possible.\n\n' ...
        'Press any key to continue.'];
        
    dispInfo(win.pointer,textGreet,opt.colText);
    dispInfo(win.pointer,textGreet2,opt.colText);

    headers = {'subID','condition','N','practice','seriesSize','series', ...
        'probe','positiveTrial','response','respTime'};
    
    data = cell(1,1);
    % Experimental parameters
    conditions = [1 3; 4 6]; % [minEasy maxEasy ; minHard maxHard]
    stim = {'1','2', '3', '4', '5', '6', '7', '8', '9', '0'};
    warnStim = '#';
    
    if(opt.bSpeedy)
        numPracticeTrials = 5;
        numTestTrials = [8 6];
        stimTime = 0.4;
        preWarnInterval = 1;
        warnTime = 0.2;
        trialInterval = 2.0;
        feedbackTime = 0.5;
    else
        numPracticeTrials = 8;
        % The original task had 40 test trials. Reduced to 32 for brevity
        numTestTrials = [32 24];
        stimTime = 1.2;
        preWarnInterval = 2;
        warnTime = 0.2;
        trialInterval = 3.7;
        feedbackTime = 1.2;
    end
    
    
    % Main loop, practice loop first
    try
        r = 1;
        for cond = randperm(size(conditions,1))
            bContinue = true;
            if(cond(1)==1)
                condVal = 1;
            else
                condVal = 2;
            end
            text = sprintf([ ...
                'This group of problems will have %d to %d numbers in\n' ...
                'each list.\n\n' ...
                'Remember, if the number that appears after the list\n' ...
                'was in the list, you should press the "J" key.\n\n' ...
                'If it was not in the list, you should press the "F" key.\n\n' ...
                'After you make a response, the computer will tell you if\n' ...
                'you were correct or incorrect.\n\n' ...
                'Also remember that it is very important to answer as quickly\n' ...
                'and as accurately as possible.\n\n' ...
                'Do you have any questions?\n\n' ...
                'You will now be given a chance to practice this group of\n' ...
                'problems.\n\n' ...
                'Press any key to continue.'], ...
                conditions(cond,1), conditions(cond,2));
            dispInfo(win.pointer,text, opt.colText);


            sendEvent(ev(eSecStart,condVal)); % Section start
            for n=1:numPracticeTrials+numTestTrials(condVal)
                if(~bContinue), break; end

                if(n == 1)
                    bPractice = true;
                    text = sprintf([ ...
                        'You will have %d practice problems.\n\n' ...
                        'Please put your left index finger on the "F" key\n' ...
                        'and your right index finger on the "J" key now.\n' ...
                        'Then, press either key to begin.\n\n' ...
                        'Your practice problems will begin immediately.\n'], ...
                        numPracticeTrials);
                    dispInfo(win.pointer,text,opt.colText);
                elseif(n == 1 + numPracticeTrials)
                    text = sprintf([ ...
                        'That was the end of practice.\n\n' ...
                        'Do you have any questions?\n\n' ...
                        'There will be %d experimental problems.\n' ...
                        'When you are ready, press any key to begin.\n\n'], ...
                        numTestTrials(condVal));
                    dispInfo(win.pointer,text, ...
                        opt.colText);
                    bPractice = false;
                end

                % Trial setup
                seriesSize = Sample(conditions(cond,1):conditions(cond,2));
                trialStim = shuffle(stim);
                pSeries = trialStim(1:seriesSize);
                nSeries = trialStim(seriesSize+1:end);
                p = rand();
                if(p >= 0.5) % Positive trial
                    trialType = 1;
                    testStim = cell2mat(Sample(pSeries));
                else
                    trialType = 0;
                    testStim = cell2mat(Sample(nSeries));
                end

                % Stim presentation
                StimulusOnsetTime = 0;
                sendEvent(ev(eRecallPres,condVal,bPractice)); % Recall presentation
                for i=1:seriesSize
                    DrawFormattedText(win.pointer,pSeries{i}, ...
                        'center','center',opt.colText);
                    if(StimulusOnsetTime > 0)
                        [VBLTimestamp StimulusOnsetTime] = ...
                            Screen('Flip',win.pointer,StimulusOnsetTime ...
                            + stimTime);
                    else
                        [VBLTimestamp StimulusOnsetTime] = ...
                            Screen('Flip',win.pointer,0);
                    end
                end
                
                % Clear after last stim of positive series
                [VBLTimestamp StimulusOnsetTime] = ...
                    Screen('Flip',win.pointer,StimulusOnsetTime + stimTime);

                % Warning signal
                DrawFormattedText(win.pointer,warnStim, ...
                    'center','center',opt.colText);
                [VBLTimestamp StimulusOnsetTime] = ...
                    Screen('Flip',win.pointer,StimulusOnsetTime + preWarnInterval);

                % Test stimulus
                DrawFormattedText(win.pointer,testStim, ...
                    'center','center',opt.colText);
                [VBLTimestamp, StimulusOnsetTime] = ...
                    Screen('Flip',win.pointer,StimulusOnsetTime + warnTime);

                sendEvent(ev(eTestPres,2*condVal-trialType,bPractice)); % Test stimulus marker
                
                % Wait for input
                [secs,keyCode] = KbWait([],2);
                trialRT = secs - StimulusOnsetTime;

                % Process input
                key  = KbName(keyCode);
                trialResp = -1; % Undefined response
                if(strcmp(key,'esc')==1) % Abort
                    ME = MException('WLAB:Sternberg:Abort', ...
                        'User aborted experiment.');
                    throw(ME);
                elseif(strcmp(key,'f')==1) % Negative response
                    trialResp = 0;
                elseif(strcmp(key,'j')==1) % Positive response
                    trialResp = 1;
                elseif(strcmp(key,'backspace')==1) % Skip
                    bContinue = false;
                end
                
                % Provide feedback
                if(trialType == trialResp)
                    dCorrect = 1;
                    feedback = 'Correct';
                else
                    dCorrect = 0;
                    feedback = 'Incorrect';
                end
                sendEvent(ev(eResponse,2*condVal-dCorrect,bPractice));
                
                % Clear stimulus, show feedback
                DrawFormattedText(win.pointer,feedback,'center','center', ...
                    opt.colText);
                [VBLTimestamp, StimulusOnsetTime] = ...
                    Screen('Flip',win.pointer,0);

                % Clear feedback
                Screen('Flip',win.pointer,StimulusOnsetTime + feedbackTime);

                % Record data
                data{r,1} = opt.subID;
                data{r,2} = cond;
                data{r,3} = n;
                data{r,4} = bPractice;
                data{r,5} = size(pSeries,2);
                data{r,6} = cell2mat(pSeries);
                data{r,7} = testStim;
                data{r,8} = trialType;
                data{r,9} = trialResp;
                data{r,10} = trialRT;

                r = r + 1;
                % Wait until next trial
                WaitSecs('UntilTime',StimulusOnsetTime + trialInterval);
            end
            sendEvent(ev(eSecEnd,condVal));
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