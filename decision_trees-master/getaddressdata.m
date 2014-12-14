function data=getaddressdata(address, city)
% Access Zillow API to get real estate information

zwskey=''; % Zillow Web Services ID

% replace space with '+' for urlencoding
escad=regexprep(address,' ','+');

% construct the URL
url='http://www.zillow.com/webservice/GetDeepSearchResults.htm?';
url=[url sprintf('zws-id=%s&address=%s&citystatezip=%s',zwskey,escad,city)];

% parse resulting XML
doc=xmlread(url);
code=char(doc.getElementsByTagName('code').item(0).getFirstChild.getData);

% Code 0 means success, otherwise there was an error
if ~strcmp(code,'0')
    data=[];
else
    try
        zipcode=char(doc.getElementsByTagName('zipcode').item(0).getFirstChild.getData);
        use=char(doc.getElementsByTagName('useCode').item(0).getFirstChild.getData);
        year=char(doc.getElementsByTagName('yearBuilt').item(0).getFirstChild.getData);
        bath=char(doc.getElementsByTagName('bathrooms').item(0).getFirstChild.getData);
        bed=char(doc.getElementsByTagName('bedrooms').item(0).getFirstChild.getData);
        price=char(doc.getElementsByTagName('amount').item(0).getFirstChild.getData);
    catch
        data=[];
    end
    data={zipcode,use,str2double(year),str2double(bath),str2double(bed),str2double(price)};
end