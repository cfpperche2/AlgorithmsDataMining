function test_predicted = C4_5(train_features, attrs, test_features)

    N = size(train_features,1);
    uc = unique(train_features.(5));

bounday_regions = get_boundary_regions(train_features, attrs);
data_entropy = get_entropy(train_features.(5),uc);
gain_info = get_gain_info(train_features,attrs,uc);


end

function data_entropy = get_entropy(dataset,uc)
    data_entropy = 0;
    for i=1:size(uc,1)
        IndexC = ismember(dataset, uc(i));
        Index = find(IndexC==1);
        prior = length(Index)/length(dataset);
        data_entropy = data_entropy - (prior*log2(prior));
    end
end

function gain_info = get_gain_info(dataset,attrs,uc)
% Gain(A|S) = Entropy(S) - Sum(|Pv|/|P| * Entropy(A|S))
    gain_info=0;
    entropy_dataset = get_entropy(dataset.(5),uc);
    len_dataset = size(dataset,1);
    
    for i=1:size(attrs,2)
        [uattrs] = unique(double(dataset(:,i)));
        cattrs = [uattrs,histc((double(dataset(:,i))),uattrs)];
        pattrs = cattrs(:,2)/len_dataset;
        
        
        
        
    end
    gain_info = pattrs;
    
    
end

function gain_ratio = get_gain_ratio(train_features)
end

function boundary_regions = get_boundary_regions(dataset, attrs)
    boundary_regions = [];
    for i=1:size(attrs,2)
        [dataset_sort index_sort] = sort(unique(double(dataset(:,i))));
        boundary_regions(i) = median(dataset_sort);
    end
end