function results = getInput(prompt)
    r = inputdlg(prompt,'Input Required');
    if(~isempty(r)), results = r{1};
    else results = [];
    end
end