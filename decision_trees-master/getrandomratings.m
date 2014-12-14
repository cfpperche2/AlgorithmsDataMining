function result=getrandomratings(c)
% Access Hot or Not API to get 'hotness' ratings of random members. Returns
% ID-rating paris in cell array.

    apikey=''; % Hor or Not API key

    % construct URL for getRandomProfile
    url=sprintf('http://services.hotornot.com/rest/?app_key=%s', apikey);
    url=[url sprintf('&method=Rate.getRandomProfile&retrieve_num=%d', c)];
    url=[url '&get_rate_info=true&meet_users_only=true'];
    
    % parse resulting XML
    doc=xmlread(url);
    
    emids=doc.getElementsByTagName('emid');
    ratings=doc.getElementsByTagName('rating');
    
    % get user ID's and ratings from the DOM tree and return a cell array 
    % of ID-rating pairs. 
    rowsize=ratings.getLength;
    result=cell(rowsize,2);
    for i=1:rowsize
        if ~isempty(ratings.item(i-1).getFirstChild)
            result{i,1}=char(emids.item(i-1).getFirstChild.getData);
            result{i,2}=str2double(char(ratings.item(i-1).getFirstChild.getData));
        end
    end