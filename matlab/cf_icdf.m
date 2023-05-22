% Curve fitting for inverse of the normal cumulative distribution function

clc;    clear;

tic;

Nlzd = 61;
Nuni = 4;
Nsamp = 15;

addr = 0;
for idxLzd = 0:Nlzd
    for idxUni = 0:Nuni-1
        % Print segment information
        fprintf('(%d)  LZD: %d  Seg: %d  Value: 0b0.0', addr, idxLzd, idxUni);
        for k = 1:idxLzd
            fprintf('0');
        end
        if (idxLzd < Nlzd)
            fprintf('1');
        end
        fprintf('%s', dec2bin(idxUni, 2));
        restW = Nlzd-1-idxLzd;
        for k = 1:(Nlzd-1-idxLzd)
            fprintf('x');
        end
        fprintf('\n');
        
        % Generate sample point
        if (idxLzd < Nlzd)
            x0 = (4 + idxUni) / 2^(idxLzd+4);
            if (restW >= Nsamp)
                x1 = (0:2^Nsamp-1)';
                x = x1 / 2^Nsamp;
                x2 = x0 + x1 / 2^(idxLzd+4+Nsamp);
            else
                x1 = (0:2^restW-1)';
                x = x1 / 2^restW;
                x2 = x0 + x1 / 2^(idxLzd+4+restW);
            end
        else
            if (idxUni == 0)
                x0 = 0.5 / 2^(Nlzd+3);
            else
                x0 = idxUni / 2^(Nlzd+3);
            end
            x = 0;
            x2 = x0;
        end
        y = -norminv(x2);
        fprintf('#Data = %d  min(y) = %f  max(y) = %f\n', ...
            length(y), min(y), max(y));
        if (length(y) >= 2^Nsamp)
            fprintf('max(delta(y)) = %g\n', abs(max(diff(y))));
        end
        
        % Fitting
        c = cf_fit(x, y);
        c0(addr + 1) = c(1);
        c1(addr + 1) = c(2);
        c2(addr + 1) = c(3);
        e = c(3)*x.^2 + c(2)*x + c(1) - y;
        err(addr + 1) = max(abs(e));
        fprintf('max(abs(e)) = %g\n', err(addr + 1));
        
        % Quatization (y = (c2*x + c1)*x + c0)
        % x: u<15,15> -> s<16,15>
        % c0: u<18,14> -> s<19,14>
        % c1: s<18,19> <= 0
        % c2: u<17,23>
        x_fi = floor(x*2^15);
        c_fi(1) = round(c(1) * 2^14);
        c_fi(2) = round(c(2) * 2^19);
        c_fi(3) = round(c(3) * 2^23);
        c0_fi(addr + 1) = c_fi(1);
        c1_fi(addr + 1) = c_fi(2);
        c2_fi(addr + 1) = c_fi(3);
        mul1 = c_fi(3) * x_fi;    % u<32,38> -> s<33,38>
        sum1 = mul1 + c_fi(2)*2^19;    % s<38,38>
        sum1_fi = floor(sum1 / 2^20);    % s<18,18>
        mul2 = sum1_fi .* x_fi;    % s<34,33> -> s<33,33>
        mul2_fi = floor(mul2 / 2^19);    % s<14,14>
        sum2 = mul2_fi + c_fi(1);    % s<19,14> -> u<18,14>
        sum2_fi = nearest(sum2 / 2^3);    % u<15,11>
        y_fi = sum2_fi / 2^11;
        e_fi = y_fi - y;
        err_fi(addr + 1) = max(abs(e_fi));
        fprintf('max(abs(e_fi)) = %g\n', err_fi(addr + 1));
        
        fprintf('\n');
        addr = addr + 1;
    end
end

fprintf('------------------------------------------------------------\n');
fprintf('ULP = 2^(-11) = %.10f\n', 2^(-11));
fprintf('%-30s = %.10f (%.6f ULP)\n', 'maximum floating-point error', max(err), max(err)/2^-11);
fprintf('%-30s = %.10f (%.6f ULP)\n', 'maximum fixed-point error', max(err_fi), max(err_fi)/2^-11);
fprintf('------------------------------------------------------------\n');

save('cf_vars.mat');

toc;
