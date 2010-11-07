n = 10;  
X = normrnd(0,1,[n 2]);
X = bsxfun(@minus,X,mean(X));
S = [0.5 -sqrt(3)/2; sqrt(3)/2 0.5];
Y = normrnd(0.5*X*S+2,0.05,n,2);
Y = bsxfun(@minus,Y,mean(Y));
figure(1);
[d,Z,tr] = procrustes(X,Y);
plot(X(:,1),X(:,2),'rx',...
     Y(:,1),Y(:,2),'b.',...
     Z(:,1),Z(:,2),'bx');
 
figure(2);
Z = Y*(Y \ X);
plot(X(:,1),X(:,2),'rx',...
     Y(:,1),Y(:,2),'b.',...
     Z(:,1),Z(:,2),'bx');