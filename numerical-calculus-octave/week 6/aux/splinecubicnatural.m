function pp=splinecubicnatural(nodes,values)
n=length(nodes);
dx=diff(nodes);  ddiv=diff(values)./dx;
A=zeros(n);B=zeros(n,1);
for i=2:n-1
    A(i,[i-1,i,i+1])=[dx(i),2*(dx(i-1)+dx(i)),dx(i-1)];
    B(i)=3*(dx(i)*ddiv(i-1)+dx(i-1)*ddiv(i));
end
A(1,[1 2])=[2 1];A(n,[n-1 n])=[1 2];
B(1)=3*ddiv(1);B(n)=3*ddiv(n-1);
m=A\B;
coefs=zeros(n-1,4);
coefs(:,[3,4])=[m(1:n-1) values(1:n-1)'];
coefs(:,1)=(m(2:n)+m(1:n-1)-2*ddiv')./(dx'.^2);
coefs(:,2)=(ddiv'-m(1:n-1))./dx'-coefs(:,1).*dx';
pp = mkpp(nodes,coefs);