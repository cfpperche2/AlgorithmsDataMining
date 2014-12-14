function result=getpeopledata(ratings)
% % Access Hot or Not API to get demographic data for individuals specified
% in the input argument, which is a cell array of ID-rating pairs. 

    apikey=''; % Hor or Not API key

    % Reduce branching possibilities by aggregating states into regions
    stateregions=...
        {'New England', {'ct','mn','ma','nh','ri','vt'};
        'Mid Atlantic',{'de','md','nj','ny','pa'};
        'South',{'al','ak','fl','ga','ky','la','ms','mo','nc','sc','tn','va','wv'};
        'Midwest',{'il','in','ia','ks','mi','ne','nd','oh','sd','wi'};
        'West',{'ak','ca','co','hi','id','mt','nv','or','ut','wa','wy'}};
    
    result={};
    
    for i=1:size(ratings,1)
        emid=ratings{i,1};
        rating=ratings{i,2};
    
        % construct URL for MeetMe.getProfile method
        url=sprintf('http://services.hotornot.com/rest/?app_key=%s', apikey);
        url=[url sprintf('&method=MeetMe.getProfile&emid=%s&get_keywords=true',emid)];

        % get all the info about this person
        try
            rating=rating+0.5;
            % parse resulting XML
            doc=xmlread(url);
            gender=char(doc.getElementsByTagName('gender').item(0).getFirstChild.getData);
            age=char(doc.getElementsByTagName('age').item(0).getFirstChild.getData);
            loc=char(doc.getElementsByTagName('location').item(0).getFirstChild.getData);
            
            % Convert state to region
            for j=1:size(stateregions,1)
                if sum(strcmp(loc(1:2),stateregions{j,2}))
                    region=stateregions{j,1};
                end
            end
            
            % add to the result
            if ~isempty(region)
                data={gender,str2double(age),region,rating};
                result=[result;data];
            end
        end
    end