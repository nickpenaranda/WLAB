function output = wlab(opt)
    clc; 
    disp('__Workload_Assessment_Battery______________');
    disp('(c) 2010 Nick Penaranda, George Mason University');
    
    AssertOpenGL; 
    
    evalin('base','global wlabEventOut;');
    global wlabEventOut;
    
    if(~exist('TrackStart','file') || ~exist('TrackStop','file'))
        bTET = false;
    else
        bTET = true;
    end
    
    if(~exist('opt','var'))
        % Options
        opt.bWindowed = true;
        opt.nWinSize = [1024 768];
        opt.colClear = [128 128 128];
        opt.colText =  [255 255 255];
        opt.bSpeedy = false;
        [opt.conExpNames opt.conExperiments] = getExperiments();
        opt.subID = getInput('Subject ID');
    end
    
    % WLAB Constants
    conDataPath = 'data/';
    %[conExpNames conExperiments] = getExperiments();
    %conExperiments = {@doNBack,@doSternberg,@doRSpan};
    %conExpNames = {'NBack','Sternberg','RSpan'};
    conNumExperiments = size(opt.conExperiments,2);
    
    % Seed RNG
    RandStream.setDefaultStream(RandStream('mt19937ar','seed',sum(100*clock)));

    % Set up screen
    Screen('Preference','SyncTestSettings', .005, 50, .1, 5);
    Screen('Preference','SkipSyncTests',1);
    Screen('Preference','Verbosity',0);
    Screen('Preference','SuppressAlLWarnings',1);
    Screen('Preference','VisualDebugLevel',1);
    
    % Experiment variables
    vExpOrder = randperm(conNumExperiments);
    vExperiments = opt.conExperiments(vExpOrder);
    vExpNames = opt.conExpNames(vExpOrder);
    
    
%     fprintf('  Subject ID: %s\n', opt.subID);
%     fprintf('  Order of experiments:');
%     for i=vExpOrder, fprintf(' %s',opt.conExpNames{i}); end
%     fprintf('\n\n');
    
    win = [];
     if(~opt.bWindowed)
        scrNum = max(Screen('Screens'));
        winSize = [];
    else
        if(length(Screen('Screens'))>1)
            scrNum = 1;
        else
            scrNum = 0;
        end
        screenSize = Screen('Rect',scrNum);
        marginX = (screenSize(3) - opt.nWinSize(1))/2;
        marginY = (screenSize(4) - opt.nWinSize(2))/2;
        winSize = [marginX marginY marginX+opt.nWinSize(1) ...
            marginY+opt.nWinSize(2)];
    end
    
    % Display options
    fprintf('__Options__________________________________ \n\n');
    
    fprintf('  Windowed:    ');
    if(opt.bWindowed) 
        fprintf('yes\n');
        fprintf('  Window size: %dx%d\n',opt.nWinSize(1),opt.nWinSize(2));
    else fprintf('no\n');
    end
    
    fprintf('  Abbreviated: ');
    if(opt.bSpeedy), fprintf('yes\n');
    else fprintf('no\n');
    end
    
    fprintf('  BG Color:    %s\n',mat2str(opt.colClear));
    fprintf('  Text Color:  %s\n',mat2str(opt.colText));
    fprintf('  Subject ID:  %s\n',opt.subID);
    fprintf('  Experiments: ');
    for i=vExpOrder, fprintf(' %s',opt.conExpNames{i}); end
    fprintf('\n');
    fprintf('___________________________________________ \n\n');

    bContinue = true;
    for i=1:conNumExperiments
        if(~bContinue), break; end;
        
        try %PTB Screen
            bRetry = true;
            while(bRetry)
                ListenChar(2)
                fprintf('___________________________________________\n');
                fprintf('  Now running: %s\n\n',vExpNames{i});
                disp('  EXPERIMENTER: Begin EEG Recording for this task');
                disp('  (Press any key to launch module)');
                %fprintf(['Please ensure EEG has been properly set up.\n' ...
                %    '<Press any key to begin>\n'],vExpNames{i});
                KbWait([],3);
                
                % Clear wlabEventOut
                wlabEventOut = [];
                
                if(bTET)
                    % Hack
                    fNameTET = sprintf('C:\\Documents and Settings\\Carryl\\My Documents\\MATLAB\\WLAB\\data\\%s_%s_eyetracking.csv',opt.subID,vExpNames{i});
                    TrackStart(0,fNameTET);
                end
                
                [win.pointer,win.rect] = Screen('OpenWindow',scrNum, opt.colClear, winSize);
                [win.mx win.my] = RectCenter(win.rect);
                
                fNamePrefix = sprintf('%s%s_%s',conDataPath,opt.subID,vExpNames{i});
                try %Experiment
                    results = vExperiments{i}(opt,win);
                    disp(results);
                    fName = [fNamePrefix '.xls'];
                    xlswrite(fName,results);
                    fNameMarkers = [fNamePrefix '_markers.csv'];
                    csvwrite(fNameMarkers,wlabEventOut);
                    fprintf('  %s results written to %s\n', ...
                        vExpNames{i}, fName);
                    bRetry = false;
                    Screen('CloseAll');
                    fprintf('  %s completed successfully.\n',vExpNames{i});
                catch ME
                    fName = [fNamePrefix '_PARTIAL.xls'];
                    load 'lastExperiment.mat'; % Restore partial results
                    xlswrite(fName,results);
                    fNameMarkers = [fNamePrefix '_markers_PARTIAL.csv'];
                    csvwrite(fNameMarkers,wlabEventOut);
                    fprintf('  Partial %s results written to %s\n', ...
                        vExpNames{i}, fName);
                    ListenChar(0);
                    Screen('CloseAll');
                    disp('Entering debug... Type exit to continue');
                    keyboard;
                    fprintf('  Error: %s failed to complete.\n', vExpNames{i});
                    eMsg = sprintf('Error: %s failed to complete: %s\nRetry?', ...
                        vExpNames{i}, ME.message);
                    r = questdlg(eMsg,'Experiment Error', 'Retry', 'Skip', ...
                        'Abort','Retry');
                    switch(r),
                        case 'Abort',
                            fprintf('___________________________________________ \n\n');
                            fprintf('  WLAB Aborted.\n');
                            bRetry = false;
                            bContinue = false;
                        case 'Retry',
                            fprintf('  Retrying: %s.\n',vExpNames{i});
                            bRetry = true;
                        case 'Skip',
                            fprintf('  Skipping: %s.\n',vExpNames{i});
                            bRetry = false;
                    end
                end
                if(bTET)
                    TrackStop();
                end
            end
        catch ME
            ListenChar(0);
            Screen('CloseAll');
            rethrow(ME);
        end
        
        ListenChar(0);
        Screen('CloseAll');
    end
    output = [];
end