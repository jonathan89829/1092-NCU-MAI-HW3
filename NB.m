clear
xy_data = importdata('xy_data.mat');
feature1_f_m = 0;
feature1_f_s = 0;
feature2_f_m = 0;
feature2_f_s = 0;
feature3_f_m = 0;
feature3_f_s = 0;
feature4_f_m = 0;
feature4_f_s = 0;
feature5_f_m = 0;
feature5_f_s = 0;
size_f = 0;
feature1_m = 0;
feature1_s = 0;
feature2_m = 0;
feature2_s = 0;
feature3_m = 0;
feature3_s = 0;
feature4_m = 0;
feature4_s = 0;
feature5_m = 0;
feature5_s = 0;
size = 0;
for t = 1:60
    [Seg,Si_n,S_n] = Segment(xy_data(:,:,t));
    [PN] = Label(t,S_n);
    c1 = find(PN == 1);
    c2 = find(PN == -1);
    f1_f_all = zeros(1,length(c1));
    f2_f_all = zeros(1,length(c1));
    f3_f_all = zeros(1,length(c1));
    f4_f_all = zeros(1,length(c1));
    f5_f_all = zeros(1,length(c1));
    f1_all = zeros(1,length(c2));
    f2_all = zeros(1,length(c2));
    f3_all = zeros(1,length(c2));
    f4_all = zeros(1,length(c2));
    f5_all = zeros(1,length(c2));
    count1 = 1;
    count2 = 1;
    for i = 1:S_n
        if (PN(i) == 1)
            f1 = Si_n(i);
            f1_f_all(count1) = f1;
            
            xyData = zeros(Si_n(i),2);
            for j = 1:Si_n(i)
                xyData(j,:) = xy_data(Seg(j,i),:,t);
            end
            m = mean(xyData);
            n = zeros(1,Si_n(i));
            for j = 1:Si_n(i)
                n(1,j) = norm(xyData(j,:) - m);
            end
            f2 = (sum(n) / Si_n(i)) ^ 0.5;
            f2_f_all(count1) = f2;
            
            minIndex = find(xyData(:,1) == min(xyData(:,1)));
            maxIndex = find(xyData(:,1) == max(xyData(:,1)));
            f3 = xyData(maxIndex,1) - xyData(minIndex,1);
            f3_f_all(count1) = f3;
            
            A = [-2 * xyData,ones(Si_n(i),1)];
            b = zeros(Si_n(i),1);
            for j = 1:Si_n(i)
                b(j,1) = -(xyData(j,1)) ^ 2 - (xyData(j,2)) ^ 2;
            end
            xp = A \ b;
            f4 = 0;
            for j = 1:Si_n(i)
                f4 = f4 + ((-(xp(3) - xp(1) ^ 2 - xp(2) ^ 2)) ^ 0.5 - norm([xp(1),xp(2)] - xyData(j,:))) ^ 2;
            end
            f4_f_all(count1) = f4;
            
            f5 = (-(xp(3) - xp(1) ^ 2 - xp(2) ^ 2)) ^ 0.5;
            f5_f_all(count1) = f5;
            
            count1 = count1 + 1;
        end
        
        if (PN(i) == -1)
            f1 = Si_n(i);
            f1_all(count2) = f1;
            
            xyData = zeros(Si_n(i),2);
            for j = 1:Si_n(i)
                xyData(j,:) = xy_data(Seg(j,i),:,t);
            end
            m = mean(xyData);
            n = zeros(1,Si_n(i));
            for j = 1:Si_n(i)
                n(1,j) = norm(xyData(j,:) - m);
            end
            f2 = (sum(n) / Si_n(i)) ^ 0.5;
            f2_all(count2) = f2;
            
            minIndex = find(xyData(:,1) == min(xyData(:,1)));
            maxIndex = find(xyData(:,1) == max(xyData(:,1)));
            f3 = xyData(maxIndex,1) - xyData(minIndex,1);
            f3_all(count2) = f3;
            
            A = [-2 * xyData,ones(Si_n(i),1)];
            b = zeros(Si_n(i),1);
            for j = 1:Si_n(i)
                b(j,1) = -(xyData(j,1)) ^ 2 - (xyData(j,2)) ^ 2;
            end
            xp = A \ b;
            f4 = 0;
            for j = 1:Si_n(i)
                f4 = f4 + ((-(xp(3) - xp(1) ^ 2 - xp(2) ^ 2)) ^ 0.5 - norm([xp(1),xp(2)] - xyData(j,:))) ^ 2;
            end
            f4_all(count2) = f4;
            
            f5 = (-(xp(3) - xp(1) ^ 2 - xp(2) ^ 2)) ^ 0.5;
            f5_all(count2) = f5;
            
            count2 = count2 + 1;
        end
    end
    size_f = size_f + length(c1);
    size = size + length(c2);
    for i = 1:length(c1)
        feature1_f_m = feature1_f_m + f1_f_all(i);
        feature2_f_m = feature2_f_m + f2_f_all(i);
        feature3_f_m = feature3_f_m + f3_f_all(i);
        feature4_f_m = feature4_f_m + f4_f_all(i);
        feature5_f_m = feature5_f_m + f5_f_all(i);
        feature1_f_s = feature1_f_s + (f1_f_all(i)) ^ 2;
        feature2_f_s = feature2_f_s + (f2_f_all(i)) ^ 2;
        feature3_f_s = feature3_f_s + (f3_f_all(i)) ^ 2;
        feature4_f_s = feature4_f_s + (f4_f_all(i)) ^ 2;
        feature5_f_s = feature5_f_s + (f5_f_all(i)) ^ 2;
    end
    for i = 1:length(c2)
        feature1_m = feature1_m + f1_all(i);
        feature2_m = feature2_m + f2_all(i);
        feature3_m = feature3_m + f3_all(i);
        feature4_m = feature4_m + f4_all(i);
        feature5_m = feature5_m + f5_all(i);
        feature1_s = feature1_s + (f1_all(i)) ^ 2;
        feature2_s = feature2_s + (f2_all(i)) ^ 2;
        feature3_s = feature3_s + (f3_all(i)) ^ 2;
        feature4_s = feature4_s + (f4_all(i)) ^ 2;
        feature5_s = feature5_s + (f5_all(i)) ^ 2;
    end
end
trainingMean1_f = feature1_f_m / size_f;
trainingMean2_f = feature2_f_m / size_f;
trainingMean3_f = feature3_f_m / size_f;
trainingMean4_f = feature4_f_m / size_f;
trainingMean5_f = feature5_f_m / size_f;
trainingMean1 = feature1_m / size;
trainingMean2 = feature2_m / size;
trainingMean3 = feature3_m / size;
trainingMean4 = feature4_m / size;
trainingMean5 = feature5_m / size;
trainingStd1_f = ((feature1_f_s / size_f) - (trainingMean1_f) ^ 2) ^ 0.5;
trainingStd2_f = ((feature2_f_s / size_f) - (trainingMean2_f) ^ 2) ^ 0.5;
trainingStd3_f = ((feature3_f_s / size_f) - (trainingMean3_f) ^ 2) ^ 0.5;
trainingStd4_f = ((feature4_f_s / size_f) - (trainingMean4_f) ^ 2) ^ 0.5;
trainingStd5_f = ((feature5_f_s / size_f) - (trainingMean5_f) ^ 2) ^ 0.5;
trainingStd1 = ((feature1_s / size) - (trainingMean1) ^ 2) ^ 0.5;
trainingStd2 = ((feature2_s / size) - (trainingMean2) ^ 2) ^ 0.5;
trainingStd3 = ((feature3_s / size) - (trainingMean3) ^ 2) ^ 0.5;
trainingStd4 = ((feature4_s / size) - (trainingMean4) ^ 2) ^ 0.5;
trainingStd5 = ((feature5_s / size) - (trainingMean5) ^ 2) ^ 0.5;

trainingMean_f = [trainingMean1_f,trainingMean2_f,trainingMean3_f,trainingMean4_f,trainingMean5_f];
trainingMean = [trainingMean1,trainingMean2,trainingMean3,trainingMean4,trainingMean5];
trainingStd_f = [trainingStd1_f,trainingStd2_f,trainingStd3_f,trainingStd4_f,trainingStd5_f];
trainingStd = [trainingStd1,trainingStd2,trainingStd3,trainingStd4,trainingStd5];

p1 = size_f / (size + size_f);
p2 = size / (size + size_f);
correct = 0;
wrong = 0;
for t = 61:120
    [Seg,Si_n,S_n] = Segment(xy_data(:,:,t));
    [PN] = Label(t,S_n);
    for i = 1:S_n
        f1 = Si_n(i);
        
        xyData = zeros(Si_n(i),2);
        for j = 1:Si_n(i)
            xyData(j,:) = xy_data(Seg(j,i),:,t);
        end
        m = mean(xyData);
        n = zeros(1,Si_n(i));
        for j = 1:Si_n(i)
            n(1,j) = norm(xyData(j,:) - m);
        end
        f2 = (sum(n) / Si_n(i)) ^ 0.5;
        
        minIndex = find(xyData(:,1) == min(xyData(:,1)));
        maxIndex = find(xyData(:,1) == max(xyData(:,1)));
        f3 = xyData(maxIndex,1) - xyData(minIndex,1);
        
        A = [-2 * xyData,ones(Si_n(i),1)];
        b = zeros(Si_n(i),1);
        for j = 1:Si_n(i)
            b(j,1) = -(xyData(j,1)) ^ 2 - (xyData(j,2)) ^ 2;
        end
        xp = A \ b;
        f4 = 0;
        for j = 1:Si_n(i)
            f4 = f4 + ((-(xp(3) - xp(1) ^ 2 - xp(2) ^ 2)) ^ 0.5 - norm([xp(1),xp(2)] - xyData(j,:))) ^ 2;
        end
        
        f5 = (-(xp(3) - xp(1) ^ 2 - xp(2) ^ 2)) ^ 0.5;
        
        f = [f1,f2,f3,f4,f5];
        g1 = [0,0,0,0,0];
        g2 = [0,0,0,0,0];
        for j = 1:5
            aa1 = -(f(j) - trainingMean_f(j)) ^ 2;
            bb1 = 2 * (trainingStd_f(j)) ^ 2;
            g1(j) = (exp(aa1 / bb1)) / (2 * pi * (trainingStd_f(j)) ^ 2) ^ 0.5;
            aa2 = -(f(j) - trainingMean(j)) ^ 2;
            bb2 = 2 * (trainingStd(j)) ^ 2;
            g2(j) = (exp(aa2 / bb2)) / (2 * pi * (trainingStd(j)) ^ 2) ^ 0.5;
        end
        test1 = p1;
        test2 = p2;
        for j = 1:5
            test1 = test1 * g1(j);
            test2 = test2 * g2(j);
        end
        if (test1 > test2)
            fprintf("t = %i , Segment %i is leg.\n",t,i);
            if (PN(i) == 1)
                correct = correct + 1;
            end
            if (PN(i) == -1)
                wrong = wrong + 1;
            end
        end
        if (test1 < test2)
            fprintf("t = %i , Segment %i is not leg.\n",t,i);
            if (PN(i) == -1)
                correct = correct + 1;
            end
            if (PN(i) == 1)
                wrong = wrong + 1;
            end
        end
    end
end
display((correct / (correct + wrong)) * 100 + " %");