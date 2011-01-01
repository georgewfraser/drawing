function coutRateMean = preferredPixel(coutRateMean)
for day=1:length(coutRateMean)
    coutRateMean{day} = structfun(@(X) X==max(X(:)), coutRateMean{day}, 'UniformOutput', false);
    coutRateMean{day} = struct2cell(coutRateMean{day});
    coutRateMean{day} = reshape(coutRateMean{day},1,1,numel(coutRateMean{day}));
    coutRateMean{day} = cell2mat(coutRateMean{day});
    coutRateMean{day} = sum(coutRateMean{day},3);
end
coutRateMean = reshape(coutRateMean,1,1,numel(coutRateMean));
coutRateMean = cell2mat(coutRateMean);
coutRateMean = sum(coutRateMean,3);

% coutRateMean = [sum(coutRateMean(:,1:5),2) sum(coutRateMean(:,6:10),2) sum(coutRateMean(:,11:15),2) sum(coutRateMean(:,16:20),2)];
% coutRateMean = coutRateMean(:,[1*ones(1,5) 2*ones(1,5) 3*ones(1,5) 4*ones(1,5)]);