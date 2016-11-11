test=3; %choose the case below
switch test
    case 1 %m>n (overdetermined) and linearly independent columns
        X=[1 2 3; -4+j -5+j -6+j;1 0 0;0 1 0];
    case 2 %n>m (underdetermined) and rows are linearly independent
        X=[1 2 3; -4+j -5+j -6+j];
    case 3 %neither rows nor columns of X are linearly independent
        X=[1 2 3 3; 2 4 6 6; -4+j -5+j -6+j -12+3*j];
end
Xp_svd = pinv(X) %pseudoinverse via SVD decomposition
Xp_over = inv(X'*X)*X' %valid when columns are linearly independent
Xp_under = X'*inv(X*X') %valid when rows are linearly independent
rank(X'*X) %X'*X is square but may not be full rank
rank(X*X') %X*X' is square but may not be full rank
Xhermitian=X'*X*pinv(X) %equal to X' (this property is always valid)
Xhermitian2=pinv(X)*X*X' %equal to X' (the property itself is valid)
maxError_over=max(abs(Xp_svd(:)-Xp_over(:))) %error for overdetermin.
maxError_under=max(abs(Xp_svd(:)-Xp_under(:))) %for underdetermined