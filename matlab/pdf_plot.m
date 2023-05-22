% Plot PDF of the generated samples

clc;    clear;

tic;

N = 10000000;
Seed = 1;

z = ctg_seed(Seed);
r = ctg_gen(z, N);
x_gng = icdf_gen(r);
y_gng = double(x_gng)/2^11;    % standard normal distribution


x = -6:0.02:6;
pdf_ideal = normpdf(x);

L = length(x);
cdf_fi = zeros(1, L);
for k = 1:L
    cdf_fi(k) = sum(y_gng <= x(k));
end
pdf_fi = diff(cdf_fi) / N * 50;

stem(x, [pdf_fi 0],'Color',[0.6 0.6 0.6], 'MarkerSize', 0, 'LineWidth', 2);
hold on;
plot(x, pdf_ideal, 'k', 'LineWidth', 2);
xlabel('x');
ylabel('PDF(x)')
axis([-6 6 0 0.45]);

toc;
