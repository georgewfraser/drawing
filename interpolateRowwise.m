function y = interpolateRowwise(tx, x, ty)
if(numel(ty)==0 || sum(size(tx)~=size(x))>0)
    error('MYCODE:badarg','tx ~ %d x ~ [%d,%d] ty ~ %d',numel(tx),size(x,1),size(x,2),numel(ty));
end
y = interpolateRowwiseMex(tx,x,ty);