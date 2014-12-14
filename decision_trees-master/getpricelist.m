function l1=getpricelist()
% take a list of address in Cambridge MA and retrieve real estate info from
% Zillow API.

    % open the text file and get the list of addresses
    fid=fopen('addresslist.txt');
    file=textscan(fid,'%s','delimiter','\n','whitespace','');
    fclose(fid)
    addr=file{1,1};

    l1={};
    
    for i=1:size(addr,1)
        data=getaddressdata(addr{i,1},'Cambridge,MA');
        l1=[l1;data];
    end



