clear
xy_data = importdata('xy_data.mat');
a = 0;
B = 0;
for t = 1:60
    [Seg,Si_n,S_n] = Segment(xy_data(:,:,t));
    [PN] = Label(t,S_n);
    a = a + length(find(PN == 1));
    B = B + length(find(PN == -1));
end

l = zeros(1,a + B);
d = zeros(1,a + B);
c = 1;
for t = 1:60
    [Seg,Si_n,S_n] = Segment(xy_data(:,:,t));
    [PN] = Label(t,S_n);
    for j = 1:S_n
        if (PN(j) == 1)
            d(c) = 1 / (2 * a);
            l(c) = 1;
            c = c + 1;
        end
        if (PN(j) == -1)
            d(c) = 1 / (2 * B);
            l(c) = -1;
            c = c + 1;
        end
    end
end

h = zeros(5,a + B);
c1 = 1;
for t = 1:60
    [Seg,Si_n,S_n] = Segment(xy_data(:,:,t));
    [PN] = Label(t,S_n);
    for j = 1:S_n
        f1 = Si_n(j);
        
        xsum = 0;
        ysum = 0;
        for k = 1:Si_n(j)
            xsum = xsum + xy_data(Seg(k,j),1,t);
            ysum = ysum + xy_data(Seg(k,j),2,t);
        end
        averagex = xsum / Si_n(j);
        averagey = ysum / Si_n(j);
        summation = 0;
        for k = 1:Si_n(j)
            summation = summation + (xy_data(Seg(k,j),1,t) - averagex) ^ 2 + (xy_data(Seg(k,j),2,t) - averagey) ^ 2;
        end
        f2 = sqrt(summation / Si_n(j));
        
        xdata = zeros(1,Si_n(j));
        for k = 1:Si_n(j)
            xdata(k) = xy_data(Seg(k,j),1,t);
        end
        minIndex = find(xdata == min(xdata));
        maxIndex = find(xdata == max(xdata));
        f3 = xy_data(maxIndex,1,t) - xy_data(minIndex,1,t);
        
        A = ones(Si_n(j),3);
        for k = 1:Si_n(j)
            A(k,1) = -2 * xy_data(Seg(k,j),1,t);
            A(k,2) = -2 * xy_data(Seg(k,j),2,t);
        end
        b = zeros(Si_n(j),1);
        for k = 1:Si_n(j)
            b(k,1) = -(xy_data(Seg(k,j),1,t)) ^ 2 - xy_data(Seg(k,j),2,t) ^ 2;
        end
        xp = A \ b;
        f4 = 0;
        for k = 1:Si_n(j)
            f4 = f4 + (sqrt(-(xp(3) - xp(1) ^ 2 - xp(2) ^ 2)) - sqrt((xp(1) - xy_data(Seg(k,j),1,t)) ^ 2 + (xp(2) - xy_data(Seg(k,j),2,t)))) ^ 2;
        end
        
        f5 = sqrt(-(xp(3) - xp(1) ^ 2 - xp(2) ^ 2));
        
        f = [f1,f2,f3,f4,f5];
        value = [14,0.04,0.025,0.01629,0.096];
        for z = 1:5
            if (f(z) < value(z))
                h(z,c1) = 1;
            end
            if (f(z) >= value(z))
                h(z,c1) = -1;
            end
        end
        c1 = c1 + 1;
    end
end

xx = [0,0,0,0];
xxIndex = 1;
a_t = zeros(1,5);
for t = 1:5
    r = zeros(1,5);
    s = sum(d);
    for i = 1:a + b
        d(i) = d(i) / s;
    end
    for i = 1:5
        if (i ~= xx(1) && i ~= xx(2) && i ~= xx(3) && i ~= xx(4))
            for j = 1:a + B
                r(i) = abs(r(i) + d(j) * l(j) * h(i,j));
            end
        end
    end
    x = find(r == max(r));
    at = log((1 + r(x)) / (1 - r(x))) / 2;
    a_t(x) = at;
    for i = 1:5
        if (i ~= xx(1) && i ~= xx(2) && i ~= xx(3) && i ~= xx(4))
            for j = 1:a + B
                d(j) = d(j) * exp(-at * l(j) * h(i,j));
            end
        end
    end
    xx(xxIndex) = x;
    xxIndex = xxIndex + 1;
end
correct = 0;
wrong = 0;
for t = 61:120
    [Seg,Si_n,S_n] = Segment(xy_data(:,:,t));
    [PN] = Label(t,S_n);
    for j = 1:S_n
        f1 = Si_n(j);
        
        xsum = 0;
        ysum = 0;
        for k = 1:Si_n(j)
            xsum = xsum + xy_data(Seg(k,j),1,t);
            ysum = ysum + xy_data(Seg(k,j),2,t);
        end
        averagex = xsum / Si_n(j);
        averagey = ysum / Si_n(j);
        summation = 0;
        for k = 1:Si_n(j)
            summation = summation + (xy_data(Seg(k,j),1,t) - averagex) ^ 2 + (xy_data(Seg(k,j),2,t) - averagey) ^ 2;
        end
        f2 = sqrt(summation / Si_n(j));
        
        xdata = zeros(1,Si_n(j));
        for k = 1:Si_n(j)
            xdata(k) = xy_data(Seg(k,j),1,t);
        end
        minIndex = find(xdata == min(xdata));
        maxIndex = find(xdata == max(xdata));
        f3 = xy_data(maxIndex,1,t) - xy_data(minIndex,1,t);
        
        A = ones(Si_n(j),3);
        for k = 1:Si_n(j)
            A(k,1) = -2 * xy_data(Seg(k,j),1,t);
            A(k,2) = -2 * xy_data(Seg(k,j),2,t);
        end
        b = zeros(Si_n(j),1);
        for k = 1:Si_n(j)
            b(k,1) = -(xy_data(Seg(k,j),1,t)) ^ 2 - xy_data(Seg(k,j),2,t) ^ 2;
        end
        xp = A \ b;
        f4 = 0;
        for k = 1:Si_n(j)
            f4 = f4 + (sqrt(-(xp(3) - xp(1) ^ 2 - xp(2) ^ 2)) - sqrt((xp(1) - xy_data(Seg(k,j),1,t)) ^ 2 + (xp(2) - xy_data(Seg(k,j),2,t)))) ^ 2;
        end
        
        f5 = sqrt(-(xp(3) - xp(1) ^ 2 - xp(2) ^ 2));
        
        f_t = [f1,f2,f3,f4,f5];
        value = [17,0.3178,0.1808,0.0175,0.8076];
        H = [0,0,0,0,0];
        for z = 1:5
            if (f(z) < value(z))
                H(z) = 1;
            end
            if (f(z) >= value(z))
                H(z) = -1;
            end
        end
        test = 0;
        for z = 1:5
            test = test + H(z) * a_t(z);
        end
        if (test > 0)
            fprintf("t = %i , Segment %i is leg.\n",t,j);
            if (PN(j) == 1)
                correct = correct + 1;
            end
            if (PN(j) == -1)
                wrong = wrong + 1;
            end
        end
        if (test <= 0)
            fprintf("t = %i , Segment %i is not leg.\n",t,j);
            if (PN(j) == -1)
                correct = correct + 1;
            end
            if (PN(j) == 1)
                wrong = wrong + 1;
            end
        end
    end
end
display((correct / (correct + wrong)) * 100 + " %");