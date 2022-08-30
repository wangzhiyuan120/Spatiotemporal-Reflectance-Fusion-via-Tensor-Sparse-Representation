function c=soft(a,b)
%ÈíãÐÖµ
%Soft(a, b)=sign(a)*max(|a|?b, 0)

c=sign(a).*max(abs(a-b),0);

end