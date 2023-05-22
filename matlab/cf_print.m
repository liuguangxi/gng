% Print c0, c1, c2

clc;    clear;

load cf_vars.mat;


% c0: u<18,14>
fid = fopen('c0.txt', 'wt');
for k = 1:length(c0_fi)
    fprintf(fid, '%s\n', dec2bin(c0_fi(k), 18));
end
fclose(fid);


% c1: s<18,19>
fid = fopen('c1.txt', 'wt');
for k = 1:length(c1_fi)
    tmp = fi(c1_fi(k), 1, 18, 0);
    fprintf(fid, '%s\n', tmp.bin);
end
fclose(fid);


% c2: u<17,23>
fid = fopen('c2.txt', 'wt');
for k = 1:length(c2_fi)
    fprintf(fid, '%s\n', dec2bin(c2_fi(k), 17));
end
fclose(fid);
