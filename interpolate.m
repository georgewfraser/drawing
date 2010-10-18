function y = interpolate(tx, x, ty)
if(numel(ty)==0 || numel(tx)~=size(x,1))
    error('MYCODE:badarg','tx ~ %d x ~ [%d,%d] ty ~ %d',numel(tx),size(x,1),size(x,2),numel(ty));
end
y = interpolateMex(tx,x,ty);