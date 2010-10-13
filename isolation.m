function [snr, correct] = isolation(waves)
count = cellfun(@(x) size(x,2), waves);
waves(count<=48) = cell(sum(count(:)<=48),1);

for chan=find(sum(count(:,2:end),2)'>0)
    data = [waves{chan,1} waves{chan,2} waves{chan,3} waves{chan,4} waves{chan,5}]';
    class = [ones(1,size(waves{chan,1},2)) 2*ones(1,size(waves{chan,2},2)) 3*ones(1,size(waves{chan,3},2)) 4*ones(1,size(waves{chan,4},2)) 5*ones(1,size(waves{chan,5},2))];
    
    testdata = cell(5,1);
    testclass = cell(5,1);
    for i=find(count(chan,:)>0)
        testdata{i} = mvnrnd(mean(waves{chan,i},2)',cov(waves{chan,i}'),1000);
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
    
    [coeff, scores] = princomp(data);
    mu = mean(data);
    clf; hold on; axis image;
    subplot(2,4,[1 2 5 6]);
    gm = cell(5,1);
%     colors = 'kybrg';
    for i=1:5
        if(sum(class==i)>size(data,2))
            gm{i} = gmdistribution(mean(data(class==i,:)),cov(data(class==i,:)));
            x = min(scores(:,1)):range(scores(:,1))/100:max(scores(:,1));
            y = min(scores(:,2)):range(scores(:,2))/100:max(scores(:,2));
            [x,y] = meshgrid(x,y);
            z = nan(size(x));
            z(:) = gm{i}.pdf(reconstruct(coeff,[x(:) y(:)],mu));
            contour(x,y,z);
%             ezcontour(@(pc1,pc2) gm{i}.pdf(reconstruct(coeff,[pc1 pc2],mu)));
%             plot(scores(class==i,1),scores(class==i,2),[colors(i) '.']);
        end
    end
    gscatter(scores(:,1),scores(:,2),class,'kybrg','ox+*^');
    xlim([min(x(:)) max(x(:))]);
    ylim([min(y(:)) max(y(:))]);
    
    if(count(chan,2)>0)
    subplot(2,4,3);
    plot(waves{chan,2});
    end
    if(count(chan,3)>0)
    subplot(2,4,4);
    plot(waves{chan,3});
    end
    if(count(chan,4)>0)
    subplot(2,4,7);
    plot(waves{chan,4});
    end
    if(count(chan,5)>0)
    subplot(2,4,8);
    plot(waves{chan,5});
    end
    
    
    keyboard;
end
end

function y = reconstruct(coeff, scores, mu)
y = scores*coeff(:,1:size(scores,2))';
y = bsxfun(@plus,y,mu);
end