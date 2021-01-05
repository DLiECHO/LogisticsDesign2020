function [d] = distance(a,b,ord,to_origin,Tmatrix)
if a <= 0 && b <= 0
    d = 0;
elseif b == 0 || b == -1
    d = to_origin(ord(a,1));
elseif a == 0 || a == -1
    d = to_origin(ord(b,1));
else
%     disp(a);
%     disp(b);
    d = Tmatrix(ord(a,1),ord(b,1),1);
end