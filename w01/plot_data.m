clear ; close all; clc
X1 = [];
X2 = [];
Y1 = [];
Y2 = [];
data = load("points.dat");
[row, col] = size(data);
for num_row = 1:row
  row = data(num_row,:);
  if row(3) == 1
    X1 = [X1;row(1)];
    Y1 = [Y1;row(2)];
  else
    X2 = [X2;row(1)];
    Y2 = [Y2;row(2)];
  end
end;

line = load("line.dat");
w = load("w.dat");
a = line(1);
b = line(2);
a1 = -w(2) / w(3);
b1 = -w(1) / w(3);
scatter(X1, Y1, 'r');
hold on;
scatter(X2, Y2);
x = -1:0.1:1;
plot(x, a * x + b, x, a1 * x + b1);
