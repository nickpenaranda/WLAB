function dispInfo(screen,text,color)
    DrawFormattedText(screen,text,'center','center',color, [], [], [], 1.15);
    Screen('Flip',screen);

    bButtonsDown = true;
    while(bButtonsDown)
        [x,y,buttons] = GetMouse;
        [keyIsDown] = KbCheck;
        if(~keyIsDown && ~any(buttons))
            bButtonsDown = false;
        else
            WaitSecs(.005);
        end
    end
    
    bContinue = true;
    while(bContinue)
        [x,y,buttons] = GetMouse;
        [keyIsDown] = KbCheck;
        if(keyIsDown || any(buttons))
            bContinue = false;
        else
            WaitSecs(.005);
        end
    end
    
    bButtonsDown = true;
    while(bButtonsDown)
        [x,y,buttons] = GetMouse;
        [keyIsDown] = KbCheck;
        if(~keyIsDown && ~any(buttons))
            bButtonsDown = false;
        else
            WaitSecs(.005);
        end
    end
end