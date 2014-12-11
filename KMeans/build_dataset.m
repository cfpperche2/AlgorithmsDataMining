function [ds, unique_class, num_features] = build_dataset (features, classes, attributes, description)
    ds = mat2dataset(features);
    ds.Properties.VarNames = attributes;
    ds.Properties.Description = description;
    ds.Classes = nominal(classes);
    unique_class = unique(ds.(size(ds,2)));
    num_features = size(ds,1);
end