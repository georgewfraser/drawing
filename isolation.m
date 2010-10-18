function [snr, correct] = isolation(waves)
count = cellfun(@(x) size(x,2), waves);
waves(count<=10) = cell(sum(count(:)<=10),1);
count(count<=10) = 0;

correct = nan(size(waves));
snr = nan(size(waves));
for chan=find(sum(count(:,2:end),2)'>0)
    data = [waves{chan,1} waves{chan,2} waves{chan,3} waves{chan,4} waves{chan,5}]';
    class = [ones(1,size(waves{chan,1},2)) 2*ones(1,size(waves{chan,2},2)) 3*ones(1,size(waves{chan,3},2)) 4*ones(1,size(waves{chan,4},2)) 5*ones(1,size(waves{chan,5},2))];
    [coeff, scores] = princomp(data);
    
    testdata = cell(5,1);
    testclass = cell(5,1);
    for i=find(count(chan,:)>0)
        classmean = mean(scores(class==i,1:2));
        classvar = cov(scores(class==i,1:2));
        testdata{i} = mvnrnd(classmean, classvar, 1000);
        testclass{i} = repmat(i,size(testdata{i},1),1);
    end
    testdata = cell2mat(testdata);
    testclass = cell2mat(testclass);
    
    quadclass = classify(testdata,testdata,testclass,'quadratic');
    % Rows ~ output, cols ~ input
    confusion = nan(5,5);
    for inclass=1:5
        for outclass=1:5
            confusion(outclass,inclass) = sum(testclass==inclass & quadclass==outclass);
        end
    end
    
    sensitivity = confusion(eye(5)>0)./sum(confusion)';
    specificity = confusion(eye(5)>0)./sum(confusion,2);
    correct(chan,:) = (sensitivity+specificity)./2;
    
    for i=find(count(chan,:)>0)
        snr(chan,i) = mean(mean(data(class==i,:)).^2)/mean(var(data(class==i,:)));
    end
    
%     mu = mean(data);
%     clf; 
%     subplot(2,4,[1 2 5 6]);
%     hold on; 
%     axis image;
%     for i=1:5
%         if(sum(class==i)>size(data,2))
%             x = min(scores(:,1)):range(scores(:,1))/100:max(scores(:,1));
%             y = min(scores(:,2)):range(scores(:,2))/100:max(scores(:,2));
%             [x,y] = meshgrid(x,y);
%             z = nan(size(x));
%             classmean = mean(scores(class==i,1:2));
%             classvar = cov(scores(class==i,1:2));
%             z(:) = mvnpdf([x(:) y(:)], classmean, classvar);
%             z = log(z);
%             contour(x,y,z,quantile(z(:),[.25 .5 .75 .95]));
%         end
%     end
%     gscatter(scores(:,1),scores(:,2),class,'kybrg','ox+*^');
%     xlim([min(x(:)) max(x(:))]);
%     ylim([min(y(:)) max(y(:))]);
%     
%     if(count(chan,2)>0)
%     subplot(2,4,3);
%     plot(waves{chan,2});
%     end
%     if(count(chan,3)>0)
%     subplot(2,4,4);
%     plot(waves{chan,3});
%     end
%     if(count(chan,4)>0)
%     subplot(2,4,7);
%     plot(waves{chan,4});
%     end
%     if(count(chan,5)>0)
%     subplot(2,4,8);
%     plot(waves{chan,5});
%     end
%     
%     
%     keyboard;
end
end

function y = reconstruct(coeff, scores, mu)
y = scores*coeff(:,1:size(scores,2))';
y = bsxfun(@plus,y,mu);
end