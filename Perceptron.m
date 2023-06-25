clear
xy_data = importdata('xy_data.mat');
w = [0,0,0,0,0];
for i = 1:1000
    for t = 1:60
        [Seg,Si_n,S_n] = Segment(xy_data(:,:,t));
        [PN] = Label(t,S_n);
        for j = 1:S_n
            f1 = Si_n(j);
            
            xyData = zeros(Si_n(j),2);
            for k = 1:Si_n(j)
                xyData(k,:) = xy_data(Seg(k,j),:,t);
            end
            m = mean(xyData);
            n = zeros(1,Si_n(j));
            for k = 1:Si_n(j)
                n(1,k) = norm(xyData(k,:) - m);
            end
            f2 = (sum(n) / Si_n(j)) ^ 0.5;
            
            minIndex = find(xyData(:,1) == min(xyData(:,1)));
            maxIndex = find(xyData(:,1) == max(xyData(:,1)));
            f3 = xyData(maxIndex,1) - xyData(minIndex,1);
            
            A = [-2 * xyData,ones(Si_n(j),1)];
            b = zeros(Si_n(j),1);
            for k = 1:Si_n(j)
                b(k,1) = -(xyData(k,1)) ^ 2 - (xyData(k,2)) ^ 2;
            end
            xp = A \ b;
            f4 = 0;
            for k = 1:Si_n(j)
                f4 = f4 + ((-(xp(3) - xp(1) ^ 2 - xp(2) ^ 2)) ^ 0.5 - norm([xp(1),xp(2)] - xyData(k,:))) ^ 2;
            end
            
            f5 = (-(xp(3) - xp(1) ^ 2 - xp(2) ^ 2)) ^ 0.5;
            
            if (PN(j) == 1)
                y = 1;
            end
            if (PN(j) == -1)
                y = 0;
            end
            if (w(1) * f1 + w(2) * f2 + w(3) * f3 + w(4) * f4 + w(5) * f5 >= 0)
                h = 1;
            end
            if (w(1) * f1 + w(2) * f2 + w(3) * f3 + w(4) * f4 + w(5) * f5 < 0)
                h = 0;
            end
            f = [f1,f2,f3,f4,f5];
            for s = 1:5
                w(s) = w(s) + (y - h) * f(s);
            end
        end
    end
end
correct = 0;
wrong = 0;
for i = 61:120
    [Seg,Si_n,S_n] = Segment(xy_data(:,:,i));
    [PN] = Label(t,S_n);
    for j = 1:S_n
        f1 = Si_n(j);
            
        xyData = zeros(Si_n(j),2);
        for k = 1:Si_n(j)
            xyData(k,:) = xy_data(Seg(k,j),:,t);
        end
        m = mean(xyData);
        n = zeros(1,Si_n(j));
        for k = 1:Si_n(j)
            n(1,k) = norm(xyData(k,:) - m);
        end
        f2 = (sum(n) / Si_n(j)) ^ 0.5;
            
        minIndex = find(xyData(:,1) == min(xyData(:,1)));
        maxIndex = find(xyData(:,1) == max(xyData(:,1)));
        f3 = xyData(maxIndex,1) - xyData(minIndex,1);
            
        A = [-2 * xyData,ones(Si_n(j),1)];
        b = zeros(Si_n(j),1);
        for k = 1:Si_n(j)
            b(k,1) = -(xyData(k,1)) ^ 2 - (xyData(k,2)) ^ 2;
        end
        xp = A \ b;
        f4 = 0;
        for k = 1:Si_n(j)
            f4 = f4 + ((-(xp(3) - xp(1) ^ 2 - xp(2) ^ 2)) ^ 0.5 - norm([xp(1),xp(2)] - xyData(k,:))) ^ 2;
        end
            
        f5 = (-(xp(3) - xp(1) ^ 2 - xp(2) ^ 2)) ^ 0.5;
        
        if (w(1) * f1 + w(2) * f2 + w(3) * f3 + w(4) * f4 + w(5) * f5 >= 0)
            fprintf("t = %i , Segment %i is leg.\n",i,j);
            if (PN(j) == 1)
                correct = correct + 1;
            end
            if (PN(j) == -1)
                wrong = wrong + 1;
            end
        end
        if (w(1) * f1 + w(2) * f2 + w(3) * f3 + w(4) * f4 + w(5) * f5 < 0)
            fprintf("t = %i , Segment %i is not leg.\n",i,j);
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