function [muData, semData,out] = natSc_ProjectmyData(data, weights,baselineSample)

%This function calculates the mean and standard error of each RC component.
    
    dataOut = rcaProject(data, weights);
    
    if size(data,1) == 1 %for single subject
    catData = cat(3, dataOut{:});
    muData = nanmean(catData, 3);
    semData = nanstd(catData, [], 3)/(sqrt(size(catData, 3))); %This sem
    %is based on number of trials. 
    
    else %for more than 1 subject. 
    musubjects = cellfun(@(x) nanmean(x,3), dataOut,'UniformOutput',false);%avergae 120 trials within each subject
    catsubjects = cat(3, musubjects{:}); %concatenate 21 subjects
    muData = nanmean(catsubjects, 3); %calculate mean based on 21 subject mean
    semData = nanstd(catsubjects, [], 3)/(sqrt(size(dataOut, 1)));%calculate standard error based on 21 subjects
    end
    
    %baselining uisng the first n=baselineSample time samples
    baseline = nanmean(muData(1:baselineSample,:),1);
    %muData = muData - repmat(muData(1, :), [size(muData, 1) 1]);
    muData = muData - repmat(baseline, [size(muData, 1) 1]);
    %Below is only needed for the permutation test in individual difference
    %ranking
    nComp =1;
    out = squeeze(dataOut{1}(:,nComp,:)); %
    bl = nanmean(out(1:baselineSample,:),1);
    out = out - repmat(bl,size(out,1),1);
end
