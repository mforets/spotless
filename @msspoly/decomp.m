function [o1,o2,o3]=decomp(q)
%
%  [x,p,M]=decomp(q)
%
%  q -- An n-by-k msspoly.
%
%  Returns:
%  x -- an v-by-1 free msspoly including all variables appearing in q.
%  p -- an m-by-v array of non-negative integers.
%  M -- an (nk)-by-m sparse array of doubles.
%
%  Satisfying:
%
%  (*)    q(i) = sum_k M(i,k) prod_j x(j)^p(k,j)
%
%
%  [p,M]=decomp(q,x)
%
%  q -- A n-by-k msspoly.
%  x -- A v-by-1 free msspoly.
%
%  p -- an m-by-v array of non-negative integers.
%  M -- an (nk)-by-m msspoly with deg(M,x) == 0.
%
%  which also satisfy the formula (*).
%


if nargin == 1
    if length(q) == 0
        x = msspoly();
        p = [];
        M = [];
    else
        % First flatten the matrix.
        sub = q.sub;
        ind = sub2ind(q.dim,sub(:,1),sub(:,2));
        nk = prod(q.dim);
        
        % Next, build the list of unique monomials.
        varpow = [q.var q.pow];
        [~,J,K] = unique(varpow,'rows');
        uvar = q.var(J,:);
        upow = q.pow(J,:);
        
        % K maps row number to corresponding monomial.
        m = length(J); % number of unique monomials.    
        M = sparse(ind,K,q.coeff,nk,m); 
        
        % Next construct the full list of variable id numbers.
        xn = unique(q.var(q.var(:)~=0));  % All the ID numbers.
        xn = reshape(xn,[],1);
        v = length(xn);                   % Count.

        varn = msspoly.match_list(xn,uvar);     % Replace entries of var with
                                          % indices into xn.
        
        vind = find(varn ~= 0); % index of location of variables.
        [i,~] = ind2sub(size(varn),vind); % find row number
                                          % (corresponds to unique monomial).
        p = sparse(i,varn(vind),upow(vind),m,v);
        x  = msspoly(size(xn),[(1:v)' ones(v,1)],xn,ones(v,1),ones(v,1)); 
    end
    o1 = x;
    o2 = p;
    o3 = M;
% else
%     [f,xn] = msspoly.isfreemsspoly(x);
    
%     if ~f || size(x,2) ~= 1
%         error('Second argument must be k-by-1 free msspoly.');
%     end
%     keyboard
%     var = q.var;
%     match = msspoly.match_list(xn,q.var);
%     pow = q.pow.*(match ~= 0);
%     var = var.*(match ~= 0);
    
%     [var,I1] = sort(var,2,'descend');
    
%     ind = sub2ind(size(var),reshape(repmat((1:size(var,1))',1,size(var,2)),[],1),I1(:));
%     pow = reshape(pow(ind),size(var));
    
%     [mnm,I2] = unique([var pow],'rows');
    
    
end
end
