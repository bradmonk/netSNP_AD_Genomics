function [FISHP, FISHOR] = fishp(CASEREFS, CASEALTS, CTRLREFS, CTRLALTS)
%% fishp.m USAGE NOTES
%{
% 
% Syntax
% -----------------------------------------------------
%
%   [p, or] = fishp(G1refs, G1alts, G2refs, G2alts)
% 
%
% 
% Description
% -----------------------------------------------------
% 
%   fishp(SNPcells, IDarray) 
%   takes Nx1 arrays: G1refs, G1alts, G2refs, G2alts
% 
%   For each chr:pos with were at least one variant exists, there are
%   counts for each: G1refs, G1alts, G2refs, G2alts. This function takes
%   those four Nx1 arrays and computes the Fisher's Exact Test p-value
%   and odds ratio for each loci. The output variables are the same size
%   as the inputs.
%
%
% 
% Example
% -----------------------------------------------------
% 
%     [p, or] = fishp(G1refs, G1alts, G2refs, G2alts)
% 
% 
% 
% See Also
% -----------------------------------------------------
%   http://bradleymonk.com/genos
%   http://bradleymonk.com/neuralnets
% 
% 
% Attribution
% -----------------------------------------------------
%   Created by: Bradley Monk
%   email: brad.monk@gmail.com
%   website: bradleymonk.com
%   2018.01.23
%
%}
%%

    sz = size(CASEREFS,1);

    tb = [CASEREFS CASEALTS CTRLREFS CTRLALTS];

    FISHP  = zeros(sz,1);
    FISHOR = zeros(sz,1);

    % parfor nn = 1:size(tb,1)
    for nn = 1:sz

        x = reshape(tb(nn,:),[2,2])';

        r1 = sum(x(1,:));
        r2 = sum(x(2,:));
        c1 = sum(x(:,1));
        c2 = sum(x(:,2));
        n = sum(x(:));


        if min(r1,c1)<= min(r2,c2)
            x11 = (0 : min(r1,c1))';
        else
            x22 = (0 : min(r2,c2))';
            x12 = c2 - x22;
            x11 = r1 - x12;
        end       

        p1 = hygepdf(x(1,1),n,r1,c1);
        p2 = hygepdf(x11,n,r1,c1);
        p = sum(p2(p2 < p1+10*eps(p1)));

        or = x(1,1)*x(2,2)/x(1,2)/x(2,1);

        FISHP(nn)  = p;
        FISHOR(nn) = or;

        if ~mod(nn,10000); disp(nn/sz); end
    end

end